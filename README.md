## theatre

`theatre.cls` is a LaTeX2ε class designed to easily produce stage-play scripts for actors.
Since it's rare for playwrights to also be experts of programming, most of the LaTeX-like macros and environments are conveniently hidden behind simple commands: as a result, the `.tex` file should be readable even by the uninitiated.

It currently supports:
  * Full title page, with author, copyright, draft number and contact information
  * Easy character declaration, even within the
  * Automatic cast list generation, with support for group characters and character descriptions
  * Acts and scenes with optional titles, proper numbering, automatic table of contents
  * Automatic list of characters present in each scene

It will support:
  * Stage directions
  * Technical directions
  * Customizable formatting for all elements (titles, dialogue, stage and technical directions)
  * A TikZ-drawn stage template before each act to annotate the stage layout (doors, furniture...)
  * Similar smaller drawings at the right side of the page to annotate actor's movements during scenes

The class is derived both from `stage.cls` (from which I borrowed the title page) and from `dramatist.sty` (from which I borrowed everything else)

## Usage

A full working example is provided by the `example.tex` file. I have no idea if I'm infringing any rights.

## TODO list
1) Make it so that `\characterdo` generates an `\item` when it's called at the begin of the stage direction, and just prints the character name if it's preceded by another `\characterdo` or a `\stagedir`
  * Both the commands should check an `\if@instagedir` flag
  * If true, just print character name
  * If false, do `\parsableitem` and set it to true
  * `\character`, `\techdir`, `\scene`, `\act` should set the flag to false
  
2) Correctly format stage directions
  * all in italics
  * centered

3) Correctly format character lines
  * indent using `\maxcharlength`
  * character names should be bold and capitals, change `\namefont`
  * parenthetical should be in italics, something like `\def(#1){{\itshape(#1)}}`

4) Write and format technical directions
  * should be aligned to the right, in caps

5) Draw the stage with tikz
  * large drawing at the opposite page before each act start
  * smaller drawings overlayed to the right of dialogue
  * change margin of everything... how to handle right-side technical directions?

6) Options
  * parametrize the number of drawings on the side of the page
  * insert a flag for rotating the drawing (90, 180, 270)
  * insert a flag for no drawing at all --> disable `\Requirepackage{tikz}`, change back margins
  
7) Change the group characters brace back to its non-tikz version
  * solve overfull hbox warnings
