## theatre

`theatre.cls` is a LaTeX2ε class designed to easily produce stage-play scripts for actors.
Since it's rare for playwrights to also be experts of programming, most of the LaTeX-like macros and environments are conveniently hidden behind simple commands: as a result, the `.tex` file should be readable even by the uninitiated.

It currently supports:
  * Full title page, with author, copyright, draft number and contact information;
  * Easy character declaration, with a special font for starred characters and the possibility to define a new character on-the-fly;
  * Automatic cast list generation, with support for group characters and character descriptions;
  * Acts and scenes with optional titles, proper numbering, automatic table of contents;
  * Automatic list of characters present in each scene (working, some issues).

It will support:
  * Stage directions
  * Technical directions
  * Customizable formatting for all elements (titles, dialogue, stage and technical directions)
  * A TikZ-drawn stage template before each act to annotate the stage layout (doors, furniture...)
  * Similar smaller drawings at the right side of the page to annotate actor's movements during scenes
  * Landscape mode
  * Rehearsal mode (actor's line intentionally left blank)

The class is derived both from `stage.cls` (from which I borrowed the title page) and from `dramatist.sty` (from which I borrowed everything else)

## Usage

A full working example is provided by the `example.tex` file. I have no idea if I'm infringing any rights.

## TODO list
1) create a `\stagedir` macro capable of accepting graciously `\characterdo`

2) Write and format technical directions
  * should be aligned to the right, in caps

3) Draw the stage with tikz
  * large drawing at the opposite page before each act start
  * smaller drawings overlayed to the right of dialogue
  * change margin of everything... how to handle right-side technical directions?

4) Options
  * parametrize the number of drawings on the side of the page
  * insert a flag for rotating the drawing (90, 180, 270)
  * insert a flag for no drawing at all --> disable `\Requirepackage{tikz}`, change back margins
  
5) Option to landscape mode
6) Option to rehearsal mode
