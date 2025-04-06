return {
  s({trig="\\begin", snippetType="snippet", dscr="Begin and end an arbitrary environment"},
    fmta(
      [[
      \begin{<>}
          <>
      \end{<>}
      ]],
      {i(1),i(2),rep(1),}
    )
  ),
  s({trig=";fig", snippetType="snippet", dscr="A basic figure environment"},
    fmta(
      [[
      \begin{figure}
      \centering
      \includegraphics[<>]{<>}
      \caption{
          \textbf{<>}
          <>
          }
      \label{fig:<>}
      \end{figure}

      ]],
      { 
        i(1, "args"),
        i(2,"filename"),
        i(3, "captionBold"),
        i(4, "captionText"),
        i(5,"figureLabel"),
      }
    )
  ),
  s({trig=";i",snippetType="autosnippet",desc="Bound operations",wordTrig=false},
    fmta([[
      <>
      ]],
      {
        c(1, {
          sn(nil, fmta([[ \int_{<>}^{<>} ]], {i(1), i(2)})),
          sn(nil, fmta([[ \sum_{<>}^{<>} ]], {i(1), i(2)})),
          sn(nil, fmta([[ \cup_{<>}^{<>} ]], {i(1), i(2)})),
          sn(nil, fmta([[ \cap_{<>}^{<>} ]], {i(1), i(2)})),
          sn(nil, fmta([[ \Big|_{<>}^{<>} ]], {i(1), i(2)})),
        }),
      }
    )
  ),
  s({trig=";temp",snippetType="autosnippet",desc="Document templates",wordTrig=false},
    fmta([[
      <>
      ]],
      {
      c(1,{
        sn(nil,fmta(
          [[ 
            \documentclass[12pt]{amsart}
            \usepackage{graphicx} % Required for inserting images
            \usepackage{enumerate}
            \usepackage{amsmath}
            \usepackage{amsthm}
            \usepackage{amsfonts}
            \usepackage{bbm}

            % Numbered Environments
            % -------------------------------------------------------------------
            \newtheorem{theorem}{Theorem}[section]
            \newtheorem{lemma}[theorem]{Lemma}
            \newtheorem{proposition}[theorem]{Proposition}
            \newtheorem{corollary}[theorem]{Corollary}
            \newtheorem{conjecture}{Conjecture}[section]

            % Unnumbered Environments
            % -------------------------------------------------------------------
            \newtheorem*{utheorem}{Theorem}
            \newtheorem*{ulemma}{Lemma}
            \newtheorem*{uproposition}{Proposition}
            \newtheorem*{ucorollary}{Corollary}

            \title{<>}
            \author{<>}
            \date{<>}

            \begin{document}

            \maketitle

            <>
            
            \end{document}
          ]],
          {i(1),i(2),i(3),i(4)})),
        })
      }
    )
  ),
}
