## theatre

The file `theatre.cls` is a LaTeX2 class designed to easily produce stage-play scripts for actors.
Since it's rare for playwrights to also be experts of programming, most of the LaTeX-like macros and environments are conveniently hidden behind simple commands: as a result, the `.tex` file should be readable even by the uninitiated.

It currently supports:

  * Cover page with title, author, copyright, draft version number and contact information;
  * User-friendly way to declare new characters and extras;
  * 'Personal copy' mode for one/many characters, with their name on the cover and bolded lines.
  * Automatic cast list generation, with support for group characters and character descriptions;
  * Acts and scenes with optional titles, automatic numbering, automatic table of contents.
  * Stage directions (for single characters only, WIP)

It will soon support:

  * Larger, bolded font in cast list too for specific characters (also in title page?)
  * Stage directions for more than one actor
  * Technical directions

It will eventually support:

  * Automatic list of characters present in each scene (still some issues)
  * Customizable formatting for all elements (titles, dialogue, stage and technical directions)
  * A TikZ-drawn stage template before each act to annotate the stage layout (doors, furniture...)
  * Similar smaller drawings at the right side of the page to let actors annotate their movements during scenes
  * Landscape mode
  * Rehearsal mode (actor's line intentionally left blank)

The class is derived both from `stage.cls` (from which I borrowed the title page) and from `dramatist.sty` (from which I borrowed everything else)

## Usage

A full(?) working example is provided by the `example.tex` file. I have no idea if I'm infringing any rights.

## TODO list

* list of characters for each scene (only if declared in castlist)

* optional argument for `\scene` to manually include extras in the castlist

* do not break down lines over two pages (maybe use curly brackets enclosure)

* Title page:
  * total page count
  * estimated run time (?)
  * version marking
  
* all pages:
  * header with "title - act X", page number
  * footer with version number, page number

* Create a `\stagedir` macro capable of accepting graciously `\characterdo`, for ex. `\johndo` kisses `\laurado` should have both capitalized

* Technical directions should be right aligned, with double line spacing above and below

* OPTIONAL diagram for stage movements:
  * written on right margin of each page, fill using textheight / figureheight
  * get drawing from (editable) external tikz file, or external figure
  * insert a flag for no drawing at all --> disable `\Requirepackage{tikz}`, change back margins
  * how to handle right-aligned technical directions?

* create a `\setting` macro, which occupies a newpage: half for setting description, half for large diagram
  
* Option to landscape mode for directors (larger margins, diagrams on the side)

* Option for two-sided printing (margins, diagram, etc)

* Option for rehearsal mode (actor's lines are invisible (just use white-on-white coloring))

## Various Ideas

Should I repeat a character's name after a stage direction, if they continue their lines?

Can there be more plays in a single document? Do they show in table of contents?

Fu*k localization

Create a detailed guide on how to use acts and scenes, how to define characters, bla bla bla... see thalia package

Write down available options for each command, also check defaults