## theatre

The file `theatre.cls` is a LaTeX2 class designed to easily produce stage-play scripts for actors.
Since it's rare for playwrights to also be experts of programming, most of the LaTeX-like macros and environments are conveniently hidden behind simple commands: as a result, the `.tex` file should be readable even by the uninitiated.

It currently supports:

  * Cover page with title, author, copyright, draft version number and contact information;
  * Automatic cast list generation, with support for group characters and character descriptions;
  * User-friendly macros to declare main characters, character lines and stage directions; to split the script into acts and scenes; to declare minor characters and extras;
  * Optional subtitles for acts and scenes, automatic numbering, automatic table of contents, automatic list of characters within each scene (slightly buggy);
  * "Script personalization" for one or many characters, with their name on the cover and a bold font for every reference to them within the script (dialogue lines, stage directions, cast list, etc.). Additionally, a Python script can batch generate a personalized copy for each main character.
  * A draft mode for preliminary table readings, with larger line skip to modify and annotate lines

It will soon support:

  * Technical directions
  * (Bug-free) Automatic list of characters in each scene, in order of appearance
  * More information on headers and footers

It will eventually support:

  * Customizable formatting for all elements (titles, dialogue, stage and technical directions)
  * A TikZ-drawn stage template before each act to annotate the stage layout (doors, furniture, objects...)
  * "Director" landscape mode with stage schematic drawn on the side, to annotate character movements
  * Rehearsal mode: actor's lines intentionally left blank
  * Lightweight mode: only printing the pages where an actor actually appears
  * A full user manual

The class is derived both from `stage.cls` (from which I borrowed the title page) and from `dramatist.sty` (from which I borrowed everything else)

## Usage

A full(?) working example is provided by the `example.tex` file.

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
