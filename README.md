## scene

This branch is to find a system to avoid `\begin{scene}…\end{scene}` and all start-end delimiters in general.
Instead, the desired commands should just be `\scene[title]`, and it should parse all text until the next `\scene`, `\act`, or the end of the document.