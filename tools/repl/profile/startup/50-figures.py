"""Route matplotlib figures into the terminal via `wezterm imgcat`.

Without a `wezterm` binary on this host (e.g. over ssh) the PNG path is printed
instead. Inside tmux, inline rendering needs `allow-passthrough on`.

plt.show() saves every open figure to a session directory, renders it in the
REPL pane, and closes it. Nothing displays until you ask. Helpers:

  figs()      list this session's figures
  fig(n)      re-display figure n; negative counts from the end (default -1)
  preview(n)  open figure n in the OS image viewer at full resolution
"""

import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

matplotlib.rcParams["savefig.dpi"] = 150
matplotlib.rcParams["savefig.bbox"] = "tight"

_FIG_ROOT = Path.home() / ".cache" / "da-figs"
_FIG_DIR = _FIG_ROOT / f"{time.strftime('%Y%m%d-%H%M%S')}-{os.getpid()}"
_saved = []


def _prune(days=7):
    if not _FIG_ROOT.is_dir():
        return
    cutoff = time.time() - days * 86400
    for d in _FIG_ROOT.iterdir():
        if d.is_dir() and d.stat().st_mtime < cutoff:
            shutil.rmtree(d, ignore_errors=True)


_prune()


def _imgcat(path):
    if shutil.which("wezterm"):
        subprocess.run(["wezterm", "imgcat", str(path)])
    else:
        print(f"    {path}")


def _show(*_args, **_kwargs):
    nums = plt.get_fignums()
    if not nums:
        print("no open figures")
        return
    _FIG_DIR.mkdir(parents=True, exist_ok=True)
    for num in nums:
        path = _FIG_DIR / f"fig-{len(_saved) + 1:03d}.png"
        plt.figure(num).savefig(path)
        _saved.append(path)
        print(f"[{len(_saved)}] {path.name}")
        _imgcat(path)
    plt.close("all")


plt.show = _show


def _resolve(n):
    if not _saved:
        print("no figures yet")
        return None
    try:
        return _saved[n - 1] if n > 0 else _saved[n]
    except IndexError:
        print(f"no figure {n} (have {len(_saved)})")
        return None


def figs():
    """List this session's figures."""
    if not _saved:
        print("no figures yet")
    for i, path in enumerate(_saved, 1):
        print(f"[{i}] {path}")


def fig(n=-1):
    """Re-display figure n in the terminal (default: most recent)."""
    path = _resolve(n)
    if path:
        print(path.name)
        _imgcat(path)


def preview(n=-1):
    """Open figure n in the OS image viewer at full resolution."""
    path = _resolve(n)
    if path:
        opener = "open" if sys.platform == "darwin" else "xdg-open"
        subprocess.run([opener, str(path)])
