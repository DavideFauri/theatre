\ProvidesClass{teatro}[2015/01/27 v0.1b Script Format for stage plays]
\NeedsTeXFormat{LaTeX2e}
\LoadClass[12pt, oneside, a4paper, openright]{book}

%\@ifundefined{if@openright}{\newif\if@openright}{} 

\RequirePackage{etoolbox, environ}	% for dynamic list of chars in each scene
\RequirePackage{xparse}
%\RequirePackage{fancyhdr}
%\RequirePackage{extramarks}
\RequirePackage{xspace}	% add space after macro when appropriate
%\RequirePackage{tikz}

%%%%%%%%%%%%%%%%%%%%%%%		Options

\ProcessOptions\relax		% ignore all options

% if mirror flag, turn all drawings upside down
% if drawing flag, turn off/on drawings and tikz dependency (remember the group chars brace!)

%%%%%%%%%%%%%%%%%%%%%%%		Font styles

\parindent 0pt

\newcommand{\namefont}{\scshape}
\newcommand{\starfont}{\bf\scshape}
\newcommand{\actionfont}{}
\newcommand{\stagedirfont}{}

\newcommand{\casttitlename}{Cast of Characters}
\newcommand{\casttitlefont}{\scshape\Large}
\newcommand{\castfont}{\scshape}

\newcommand{\acttitlename}{Act}
\newcommand{\acttitlefont}{\scshape\Large}

\newcommand{\scenetitlename}{Scene}
\newcommand{\scenetitlefont}{\scshape\large}
\newcommand{\scenecastfont}{\scshape}

%%%%%%%%%%%%%%%%%%%%%%%		Counters

\newcounter{castlistcounter}
\newcounter{totalcharcounter}
\newcounter{actcounter}
\newcounter{scenecounter}[actcounter]

\newcounter{grouptemp}
\newcounter{casttemp}
\newcounter{flagstemp}

%%%%%%%%%%%%%%%%%%%%%%%		Flags

%%%%%%%%%%%%%%%%%%%%%%%		Title

% convert to internal functions
\newcommand{\draft}[1]{				\gdef\@draftno{#1}}		% draft number
\newcommand{\copyrightnotice}[1]{		\gdef\@crightnotice{#1}}	% copyright
\newcommand{\address}[1]{			\gdef\@address{#1}}	% physical address
\newcommand{\contactinfo}[1]{		\gdef\@cinfo{#1}}		% contact information

% create title page
\renewcommand{\maketitle}{
	\begin{titlepage}
		\vspace*{\fill}
		\center{\Huge \textsc{\@title}}
		\par
		\center{\Large \@author}
		\par\vspace{1cm}
		\ifdefined\@draftno{\small DRAFT \@draftno}\fi
		\vfill\vfill
		\begin{flushright}
			\ifdefined\@crightnotice{\copyright\ \@crightnotice}\fi
			\par
			\ifdefined\@address{\@address}\fi
			\par
			\ifdefined\@cinfo{tel. \@cinfo}\fi
		\end{flushright}
	\end{titlepage}
}

%%%%%%%%%%%%%%%%%%%%%%%		Characters

% \character[Timothy Williams][a young boy]{Timothy}{tim}
% \character[a young boy]{Timothy}{tim}
% \character{Timothy}{tim}

\NewDocumentCommand{\character}{s}{%
	\IfBooleanTF{#1}						% if starred, use special font
		{\global\let\@thischarfont\starfont}
		{\global\let\@thischarfont\namefont}
	\@ifnextchar[
		{\char@cast}			% add to cast list
		{\char@simplemacros}	% just create macros
}

\def\char@cast[#1]{
	\@ifnextchar[
		{\char@castfull{#1}}
		{\char@castfull{}[#1]}	% add empty [full name] if absent
}

\def\char@castfull#1[#2]#3#4{
	\stepcounter{castlistcounter}
	\stepcounter{totalcharcounter}

	% use script name if full name is empty
	\ifx\dummycommand#1\dummycommand
		\@namedef{persona@\Roman{castlistcounter}}{{\castfont#3}}
	\else
		\@namedef{persona@\Roman{castlistcounter}}{{\castfont#1}}
	\fi
	
	\@namedef{description@\Roman{castlistcounter}}{#2}
	
	% first expand the totalcharcounter, then pass it as argument
	\edef\@Romanchar{\Roman{totalcharcounter}}
	\expandafter\char@fullmacros\expandafter{\@Romanchar}{#3}{#4}
}

%%%%%%%%%%%%%%%%%%%%%%%		Character macros

\newcommand{\@ction}{do}					% suffix for stage directions

\def\char@simplemacros#1#2{
	\@namedef{#2}{
		\begingroup
		\catcode`\^^M=\active%
		\formatdialogue{\namefont#1}
	}
	\@namedef{#2\@ction}{
		\begingroup
		\catcode`\^^M=\active%
		\formataction{\namefont#1\xspace}%
	}
}

\def\char@fullmacros#1#2#3{

	% specifies the font for this character
	\global\expandafter\let\csname @char#1font\endcsname\@thischarfont
	
	% defines \tim, expanding (just) the tokens that require totalcharcounter
	\global\@namedef{#3}{%
		% if it's the first time that the macro is called in the scene, append char name to list
		\ifcsname @char#1enters\endcsname
		\else
			\global\@namedef{@char#1enters}{\gappto\@scenecharlist{,\ #2}}
		\fi
		\begingroup
		\catcode`\^^M=\active%
		\formatdialogue{\@nameuse{@char#1font}#2}%
	}

	% defines \timdo, expanding (just) the tokens that require totalcharcounter
	\global\@namedef{#3\@ction}{
		
		% if it's the first time that the macro is called in the scene, append char name to list
		\ifcsname @char#1enters\endcsname
		\else
			\global\@namedef{@char#1enters}{\gappto\@scenecharlist{,\ #2}}
		\fi
		\begingroup
		\catcode`\^^M=\active%
		\formataction{\@nameuse{@char#1font}#2\space}%
	}

	\settowidth{\@thischarlength}{\@nameuse{@char#1font}#2\space}	% get max length to properly indent
	\ifnum\@thischarlength>\maxcharlength
		\global\setlength{\maxcharlength}{\@thischarlength}
	\fi
}

%%%%%%%%%%%%%%%%%%%%%%%		Character macros

\begingroup
\catcode`\^^M=\active
\long\gdef\formatdialogue#1#2^^M{
	
	\parindent-\maxcharlength
	\leftskip\maxcharlength
	
	\begin{minipage}[l]{\maxcharlength}
	\raggedright					% for long charnames
	%\leftmargini=0pt
	#1
	\end{minipage}%
	%
	#2
	\endgroup
	\par
}
\endgroup

\begingroup
\catcode`\^^M=\active%
\long\gdef\formataction#1^^M{
	\parindent 0pt
	\leftskip 0.15\textwidth
	\rightskip\leftskip
	\emph{#1}
	\endgroup
	\par
}
\endgroup

%%%%%%%%%%%%%%%%%%%%%%%		Group characters

%	\chargroup[two young boys]{
%		\gcharacter[Timothy Williams]{Timothy}{tim}
%		\gcharacter{Eric}{eric}
%	}

\NewDocumentCommand{\gcharacter}{s}{%
	\IfBooleanTF{#1}						% if starred, use special font
		{\global\let\@thischarfont\starfont}
		{\global\let\@thischarfont\namefont}
	\@ifnextchar[
		{\gchar@cast}
		{\gchar@cast[]}			% add empty [full name] if absent
}

\newcommand\gchar@cast[3][]{
	\stepcounter{group@\Roman{castlistcounter}}
	\stepcounter{totalcharcounter}

	% use script name if full name is empty
	\ifx\dummycommand#1\dummycommand
		\global\@namedef{gpersona@\Roman{castlistcounter}@\roman{group@\Roman{castlistcounter}}}{{\castfont#2}}
	\else
		\global\@namedef{gpersona@\Roman{castlistcounter}@\roman{group@\Roman{castlistcounter}}}{{\castfont#1}}
	\fi

	% first expand the totalcharcounter, then pass it as argument
	\edef\@Romanchar{\Roman{totalcharcounter}}
	\expandafter\char@fullmacros\expandafter{\@Romanchar}{#2}{#3}
	}

\newsavebox{\tbox}

\newenvironment{chargroup}[1][]{
	\stepcounter{castlistcounter}			% each group counts as one character
	\global\@namedef{description@\Roman{castlistcounter}}{#1}	% description

	\newcounter{group@\Roman{castlistcounter}}	% count characters within the group
	\global\@namedef{persona@\Roman{castlistcounter}}{
		\begin{lrbox}{\tbox}
			\begin{minipage}[c]{\castnamewidth}\raggedright
			\leftmargini=0pt
			\begin{list}{}{\castlistoptions}
				\@recursegroup
			\end{list}
			\end{minipage}
		\end{lrbox}
		
		\parbox{\castnamewidth}{
			\hfuzz=\wd\tbox		% ignore overfull warnings
			\usebox{\tbox}%		% comment to avoid spurious space
 			$\left.\rule{0pt}{\ht\tbox}\right\}$	
		}%						% comment to avoid spurious space
	}
}{}

% recursively generate group listing
\newcommand{\@recursegroup}{
	\ifnum\value{grouptemp}<\value{group@\Roman{casttemp}}
		\stepcounter{grouptemp}
		\item\@nameuse{gpersona@\Roman{casttemp}@\roman{grouptemp}}\strut
		\@recursegroup
	\fi
		\setcounter{grouptemp}{0}			% cleanup
}

%%%%%%%%%%%%%%%%%%%%%%%		Cast list

%%%%% Parameters %%%%%

\newlength{\beforecasttitleskip}	\setlength{\beforecasttitleskip}{0pt}
\newlength{\aftercasttitleskip}		\setlength{\aftercasttitleskip}{1cm}

\newlength{\castpageleftmargin}	\setlength{\castpageleftmargin}{2cm}
\newlength{\castpagerightmargin}	\setlength{\castpagerightmargin}{0pt}
\newlength{\castnamewidth} 		\setlength{\castnamewidth}{0.33\linewidth}
\newcommand{\castlistoptions}{	\itemsep=0pt
							\itemindent=0cm
							\topsep=0pt
							\parsep=10pt
							\listparindent=0cm}

%%%%% Functions %%%%%

\newcommand{\castlist}{	\if@openright	\clearpage{\thispagestyle{empty}\cleardoublepage}
	\else			\clearpage
	\fi
	\thispagestyle{empty}
	\@castlist
}

\newcommand{\@castlist}{
	\phantomsection							% for hyperref purposes
	\addcontentsline{toc}{chapter}{\casttitlename}
	\castlistmark{\casttitlename}					% mark for headers

	\vspace*{\beforecasttitleskip}					% print title
	{\centering\casttitlefont\casttitlename\par}
	\par\nobreak\vskip\aftercasttitleskip
	
	\begin{list}{}{	\leftmargin=\castpageleftmargin	% create list of characters
				\rightmargin=\castpagerightmargin
				\castlistoptions}
		\@recursecast
	\end{list}
}

\newcommand{\@recursecast}{				% iterate over characters
	\ifnum\value{casttemp}<\value{castlistcounter}
		\stepcounter{casttemp}

		\item{\begin{tabular}					% full name, description as a table
			{p{\castnamewidth}
			 p{\dimexpr \linewidth-\castnamewidth-4\tabcolsep}}
				\@nameuse{persona@\Roman{casttemp}}\strut
				&
				\@nameuse{description@\Roman{casttemp}}\strut
			\end{tabular}%
		}

		\@recursecast
	\fi
	\setcounter{casttemp}{0}
}

%%%%%%%%%%%%%%%%%%%%%%%		Act

%%%%% Parameters %%%%%

\newlength{\beforeactskip}	\setlength{\beforeactskip}{\baselineskip}
\newlength{\afteractskip}		\setlength{\afteractskip}{\baselineskip}

\newcommand{\actseparator}{:\ }

%%%%% Functions %%%%%

\newcommand{\theact}{\Roman{actcounter}}

\newcommand{\act}[1][]{
	\@openact
	\@act{#1}
}

\newcommand\@openact{
	\if@openright	\clearpage{\thispagestyle{empty}\cleardoublepage}
	\else			\clearpage
	\fi
	\thispagestyle{plain}									% no header
}

\newcommand\@act[1]{
	\refstepcounter{actcounter}							% increment number of acts
	\phantomsection									% for hyperref
	\actmark{\acttitlename\ \theact}							% mark for headers
	\ifx\dummycommand#1\dummycommand
		\addcontentsline{toc}{chapter}{\acttitlename\ \theact}
	\else
		\addcontentsline{toc}{chapter}{\acttitlename\ \theact\actseparator#1}
	\fi

	\@titleact{#1}										% print the whole act title

	\@afterindentfalse									% prevent indentation after title
	\@afterheading
}

\newcommand\@titleact[1]{
	\vspace*{\beforeactskip}
	{\parindent \z@									% zero indentation
	
	\centering\acttitlefont\acttitlename\ \theact				% print "Act III"
	%		<---- do not remove the %!
	\ifx\dummycommand#1\dummycommand				% print act name
	\else
		\actseparator\par\nobreak#1
	\fi
		
	\par\nobreak\vskip\afteractskip}
}

%%%%%%%%%%%%%%%%%%%%%%%		Scene

%%%%% Parameters %%%%%

\newlength{\beforesceneskip}	\setlength{\beforesceneskip}{0pt}
\newlength{\aftersceneskip}	\setlength{\aftersceneskip}{\baselineskip}

\newcommand{\sceneseparator}{\ --\ }

%%%%% Functions %%%%%%

\newcommand{\thescene}{\arabic{scenecounter}}

%\NewEnviron{scene}[1][]{
%	\stepcounter{scenecounter}
%	
%	\def\@scenecharlist{\scenecastfont\@gobbletwo}% \@gobbletwo will remove the first ",\ "
%	
%	\sbox0{\BODY}% will not be typeset but "executed" and stored in block 0
%	
%	\@resetcharflags
%	
%	\@scene{#1}
%	\BODY
%}[]

\newenvironment{scene}[1][]{
	\stepcounter{scenecounter}
	\def\@scenecharlist{\scenecastfont\@gobbletwo}
	\@scene{#1}
	\parskip 0.5\baselineskip
}{\@scenecharlist}

\newcommand\@scene[1]{
	\phantomsection								% for hyperref
	\scenemark{\scenetitlename\ \thescene}				% mark for headers
	\ifx\dummycommand#1\dummycommand
		\addcontentsline{toc}{section}{\scenetitlename\ \thescene}
	\else
		\addcontentsline{toc}{section}{\scenetitlename\ \thescene\sceneseparator#1}
	\fi

	\@titlescene{#1}								% print whole scene title
	
	%\@afterindentfalse								% prevent indentation after title
}

\newcommand\@titlescene[1]{
	\vspace*{\beforesceneskip}
	{\centering{\scenetitlefont\scenetitlename\ \thescene	% print "Scene 24"
	%		<---- do not remove the %!
	\ifx\dummycommand#1\dummycommand			% print scene name
	\else
		\sceneseparator#1
	\fi}
	\par\nobreak{\@scenecharlist\@empty\@empty}
	\par\nobreak\vskip\aftersceneskip}
}

%%%%%%%%%%%%%%%%%%%%%%%		Parentheticals



%%%%%%%%%%%%%%%%%%%%%%%		Stage directions



%%%%%%%%%%%%%%%%%%%%%%%		Opening and technical directions



%%%%%%%%%%%%%%%%%%%%%%%		End of script

\AtEndDocument{
	\vspace{1.6ex}
	\centering
	\textsc{The End}
}

%%%%%%%%%%%%%%%%%%%%%%%		Helper functions

\providecommand\phantomsection{}		% if hyperref does not exist
\newcommand\actmark[1]{}
\newcommand\scenemark[1]{}
\newcommand\castlistmark[1]{}

\newlength{\maxcharlength}\setlength{\maxcharlength}{0pt}
\newlength{\@thischarlength}

\csname dummycommand \endcsname

\newcommand\@resetcharflags{
	\stepcounter{flagstemp}%
	%	
		\ifcsname @char\Roman{flagstemp}enters\endcsname
			\@nameuse{@char\Roman{flagstemp}enters}
			\global\@namedef{@char\Roman{flagstemp}enters}{\undefined}
		\fi
	%
	\ifnum\value{flagstemp}<\value{totalcharcounter}
		\@resetcharflags
	\fi
	\setcounter{flagstemp}{0}
}