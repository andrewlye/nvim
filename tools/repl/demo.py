# %% data-analysis REPL demo — <space>ro opens the REPL, then <space>rj steps through cells
import numpy as np
import pandas as pd

# %% the last expression of a cell displays, notebook-style
df = pd.DataFrame({'x': np.linspace(0, 4 * np.pi, 200)})
df['y'] = np.sin(df.x) * np.exp(-df.x / 8)
df.describe()

# %% figures render in the pane only when you call plt.show()
import matplotlib.pyplot as plt

plt.plot(df.x, df.y)
plt.title('damped sine')
plt.show()

# %% figure history: figs() lists, fig(1) re-displays, preview(1) opens in Preview
figs()
