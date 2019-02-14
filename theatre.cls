\ProvidesClass{theatre}[2019/02/14 v0.8 Script Format for stage plays]
\NeedsTeXFormat{LaTeX2e}

%% Default options
\PassOptionsToClass{12pt, a4paper, oneside, openright}{extbook}
\DeclareOption{openany}{\OptionNotUsed}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extbook}}
\ProcessOptions\relax		% process all options
\LoadClass{extbook}


%\@ifundefined{if@openright}{\newif\if@openright}{}

%\RequirePackage{cm-super}			% for vectorized fonts
\RequirePackage[T1]{fontenc}			% for bold small caps
\RequirePackage{etoolbox, environ}	% for dynamic list of chars in each scene
\RequirePackage{xparse}		% for IfBooleanTF and other stuff
\RequirePackage{xspace}	% add space after macro when appropriate
%\RequirePackage{fancyhdr}
%\RequirePackage{extramarks}
%\RequirePackage{tikz}
\RequirePackage{nameref}

%%%%%%%%%%%%%%%%%%%%%%%		Options

\IfFileExists{silence.sty}{
	\RequirePackage{silence}
	\typeout{^^J^^J
			SUPPRESSING ALL "MULTIPLY-DEFINED" WARNINGS
			^^J^^J}
	\WarningFilter{latex}{There were multiply-defined labels}
	\WarningFilter{latex}{Label `act}
}{
	\ClassWarningNoLine{theatre}{%
		Large number of warnings incoming! \MessageBreak
		To suppress warnings, use the 'silence'\MessageBreak
		package%
	}
}


% if mirror flag, turn all drawings upside down
% if drawing flag, turn off/on drawings and tikz dependency (remember the group chars brace!)


%%%%%%%%%%%%%%%%%%%%%%%		Names (english)

\newcommand{\casttitlename}{Cast of Characters}
\newcommand{\acttitlename}{Act}
\newcommand{\scenetitlename}{Scene}
\newcommand{\scriptendlocalizedtext}{The End}
\newcommand{\draftlocalizedtext}{DRAFT}
\newcommand{\versionlocalizedtext}{VERSION}
\newcommand{\curtainlocalizedtext}{THE CURTAIN FALLS}

%%%%%%%%%%%%%%%%%%%%%%%		Names (multi-lang)

\AtBeginDocument{
  \@ifpackagewith{babel}{english}{%
    \addto\captionsitalian{%
    	\renewcommand*\casttitlename{Cast of Characters}%
    	\renewcommand*\acttitlename{Act}%
    	\renewcommand*\scenetitlename{Scene}%
    	\renewcommand*\scriptendlocalizedtext{The End}%
    	\renewcommand*\draftlocalizedtext{DRAFT}%
    	\renewcommand*\versionlocalizedtext{VERSION}%
    	\renewcommand*\curtainlocalizedtext{THE CURTAIN FALLS}%
    }%
  }{}
  \@ifpackagewith{babel}{italian}{%
    \addto\captionsitalian{%
    	\renewcommand*\casttitlename{Personaggi}%
    	\renewcommand*\acttitlename{Atto}%
    	\renewcommand*\scenetitlename{Scena}%
    	\renewcommand*\scriptendlocalizedtext{Fine}%
    	\renewcommand*\draftlocalizedtext{BOZZA}%
    	\renewcommand*\versionlocalizedtext{VERSIONE}%
    	\renewcommand*\curtainlocalizedtext{CALA IL SIPARIO}
    }%
  }{}
}

%%%%%%%%%%%%%%%%%%%%%%%		Font styles

\parindent 0pt

\newcommand{\namefont}{\scshape}
\newcommand{\starfont}{\bf\namefont\large}

\newcommand{\actionfont}{\it}
\newcommand{\stagedirfont}{}

\newcommand{\titlestarfont}{\starfont\Huge}

\newcommand{\casttitlefont}{\scshape\Large}
\newcommand{\castfont}{\namefont}
\newcommand{\caststarfont}{\starfont\large}

\newcommand{\acttitlefont}{\scshape\Large}

\newcommand{\scenetitlefont}{\scshape\large}
\newcommand{\scenecastfont}{\namefont\small}

%%%%%%%%%%%%%%%%%%%%%%%		Counters

\newcounter{castlistcounter}
\newcounter{totalcharcounter}
\newcounter{actcounter}
\newcounter{scenecounter}[actcounter]
\newcounter{entrancecounter}[scenecounter]

\newcounter{grouptemp}
\newcounter{casttemp}
\newcounter{charstemp}

%%%%%%%%%%%%%%%%%%%%%%%		Flags

\newif\if@atleastonechar
\newif\if@thischarstar				% checks if the current character is starred
\newif\if@hasbeenformatted 		% checks if the current paragraph has been formatted as a line or an action

%%%%%%%%%%%%%%%%%%%%%%%		Temp files

\newwrite\titlecast
\immediate\openout\titlecast=\jobname-titlecast.tmp

%%%%%%%%%%%%%%%%%%%%%%%		Title

% convert to internal functions
\newcommand{\draft}[1]{						\gdef\@draftno{#1}}		% draft number
\newcommand{\version}[1]{					\gdef\@versionno{#1}}	% version number (same as draft number)
\newcommand{\copyrightnotice}[1]{	\gdef\@crightnotice{#1}}	% copyright
\newcommand{\address}[1]{					\gdef\@address{#1}}	    % physical address
\newcommand{\telephone}[1]{				\gdef\@telephone{#1}}	% telephone number
\newcommand{\email}[1]{						\gdef\@email{#1}}		% email address

% create title page
\renewcommand{\maketitle}{
	\begin{titlepage}
		\vspace*{\fill}
		\center{\Huge \textsc{\@title}}
		\par
		\center{\Large \@author}
		\par\vspace{1cm}
		\ifdefined\@draftno{\small \MakeUppercase\draftlocalizedtext\ \@draftno}\fi%
		\ifdefined\@versionno{\small \MakeUppercase\versionlocalizedtext\ \@versionno}\fi%
		\vfill
		\immediate\closeout\titlecast
		{\titlestarfont\input{\jobname-titlecast.tmp}}
		\vfill
		\begin{flushright}
			\ifdefined\@crightnotice{\copyright\ \@crightnotice\par}\fi
			\ifdefined\@address{\@address\par}\fi
			\ifdefined\@telephone{\@telephone\par}\fi
			\ifdefined\@email{\@email}\fi
		\end{flushright}
	\end{titlepage}
}

%%%%%%%%%%%%%%%%%%%%%%%		Characters

% \character[Timothy Williams][a young boy]{Timothy}{tim}
% \character[a young boy]{Timothy}{tim}
% \character{Timothy}{tim}

\NewDocumentCommand{\character}{s}{%
	\IfBooleanTF{#1}						% if starred, use special fonts
		{\@thischarstartrue}
		{\@thischarstarfalse}
	\@ifnextchar[
		{\char@cast}			% has description, add to cast list
		{\char@simplemacros}	% no description, just create macros
}

\def\char@cast[#1]{
	\@ifnextchar[
		{\char@castfull{#1}}
		{\char@castfull{}[#1]}	% add empty [full name] if absent
}

\def\char@castfull#1[#2]#3#4{
	\stepcounter{castlistcounter}
	\stepcounter{totalcharcounter}

	\if@thischarstar{			% add character to title page
		\immediate\write\titlecast{#3\par}
	}\fi

	% use script name if full name is empty
	\if\relax\detokenize{#1}\relax
		\if@thischarstar{
			\csgdef{persona@\Roman{castlistcounter}}{\caststarfont#3}
		}\else{
			\csgdef{persona@\Roman{castlistcounter}}{\castfont#3}
		}\fi
	\else
		\if@thischarstar{
			\csgdef{persona@\Roman{castlistcounter}}{\caststarfont#1}
		}\else{
			\csgdef{persona@\Roman{castlistcounter}}{\castfont#1}
		}\fi
	\fi

	\@namedef{description@\Roman{castlistcounter}}{#2}

	% first expand the totalcharcounter, then pass it as argument
	\edef\@Romanchar{\Roman{totalcharcounter}}
	\expandafter\char@fullmacros\expandafter{\@Romanchar}{#3}{#4}
}

%%%%%%%%%%%%%%%%%%%%%%%		Character macros

\newcommand{\@ction}{do}					% suffix for stage directions command, ex. \timdo
\newcommand{\@font}{font}					% suffix for the font of each particular character, ex. {\timfont TINY TIM}

\def\char@simplemacros#1#2{				% args={Timothy}{tim}
	\@namedef{#2}{%
		\if@hasbeenformatted{%
			\namefont#1%
		}\else\@firstofone{
			\begingroup
			\catcode`\^^M=\active%
			\catcode`\(=\active\relax%
			\catcode`\)=\active\relax%
			\catcode`\_=\active\relax%
			\formatdialogue{\namefont#1}%
		}\fi
		\xspace
	}
	\@namedef{#2\@ction}{%
		\if@hasbeenformatted{%
			\namefont#1%
		}\else\@firstofone{
			\begingroup
			\catcode`\^^M=\active\relax%
			\formataction{\namefont#1}%
		}\fi
		\xspace
	}
}

\def\char@fullmacros#1#2#3{					% args={\Roman{totalcharcounter}}{Timothy}{tim}

	% specifies the name for this character
	\csgdef{@char#1name}{\@nameuse{@char#1font}#2}

	% specifies the script font and castlist font for this character
	\if@thischarstar{
		\csgdef{@char#1font}{\starfont}
	}\else{
		\csgdef{@char#1font}{\namefont}
	}\fi

	% defines \timfont, for ease of use within the script
	\csgdef{#3\@font}{\@nameuse{@char#1font}}

	% defines \tim, expanding (just) the tokens that require totalcharcounter
	\csgdef{#3}{%
		\@ifundefined{r@act\Roman{actcounter}scene\Roman{scenecounter}char#1}
			{% if it's the first time that the macro is called in the scene, create label
				\refstepcounter{entrancecounter}%
				\label{act\Roman{actcounter}scene\Roman{scenecounter}char#1}%
			}{%
			}%
		\if@hasbeenformatted{%
			\@nameuse{@char#1font}#2%
		}\else\@firstofone{
			\begingroup
			\catcode`\^^M=\active\relax%
			\catcode`\(=\active\relax%
			\catcode`\)=\active\relax%
			\catcode`\_=\active\relax%
			\formatdialogue{{\@nameuse{@char#1font}#2}}%
			\expandafter\@gobble
		}\fi
		\xspace
	}

	% defines \timdo, expanding (just) the tokens that require totalcharcounter
	\csgdef{#3\@ction}{%
		\@ifundefined{r@act\Roman{actcounter}scene\Roman{scenecounter}char#1}
			{% if it's the first time that the macro is called in the scene, create label
				\refstepcounter{entrancecounter}%
				\label{act\Roman{actcounter}scene\Roman{scenecounter}char#1}}%
			{%
			}%
		\if@hasbeenformatted{%
			\@nameuse{@char#1font}#2%
		}\else\@firstofone{
			\begingroup
			\catcode`\^^M=\active\relax%
			\formataction{{\@nameuse{@char#1font}#2}}%
		}\fi
		\xspace
	}

	\settowidth{\@thischarlength}{\@nameuse{@char#1font}#2\space}	% get max length to properly indent
	\ifnum\@thischarlength>\maxcharlength
		\global\setlength{\maxcharlength}{\@thischarlength}
	\fi
}

%%%%%%%%%%%%%%%%%%%%%%%		Character macros (formataction, formatdialogue)

% Dialogue formatting
\begingroup
\catcode`\^^M=\active
\long\gdef\formatdialogue#1#2^^M{
	\@hasbeenformattedtrue

	\parindent-\maxcharlength		% for indenting correctly the char name
	\leftskip\maxcharlength

	\begin{minipage}[l]{\maxcharlength}
		\raggedright					% for long charnames
		% \leftmargini=0pt
		#1
	\end{minipage}%
	%
	#2
	\endgroup
	\par
	\@hasbeenformattedfalse
}
\endgroup

% Action formatting
\begingroup
\catcode`\^^M=\active%
\long\gdef\formataction#1^^M{
	\@hasbeenformattedtrue
	\parindent 0pt
	\leftskip 0.15\textwidth
	\rightskip\leftskip
	\vskip1ex
	\begin{minipage}[l]{0.7\textwidth}%
		\raggedright%
		\actionfont%
		(\unexpanded#1)
	\end{minipage}
	\vskip1ex
	\endgroup
	\par
	\@hasbeenformattedfalse
}
\endgroup

%%%%%%%%%%%%%%%%%%%%%%%		Group characters

%	\chargroup[two young boys]{
%		\gcharacter[Timothy Williams]{Timothy}{tim}
%		\gcharacter{Eric}{eric}
%	}

\NewDocumentCommand{\gcharacter}{s}{%
	\IfBooleanTF{#1}						% if starred, use special font
		{\global\let\@thischarfont\starfont
		\@thischarstartrue}
		{\global\let\@thischarfont\namefont
		\@thischarstarfalse}
	\@ifnextchar[
		{\gchar@cast}
		{\gchar@cast[]}			% add empty [full name] if absent
}

\newcommand\gchar@cast[3][]{
	\stepcounter{group@\Roman{castlistcounter}}
	\stepcounter{totalcharcounter}

	\if@thischarstar{			% add character to title page
		\immediate\write\titlecast{#2\par}}
	\fi

	% use script name if full name is empty
	\if\relax\detokenize{#1}\relax
		\if@thischarstar{
			\csgdef{gpersona@\Roman{castlistcounter}@\roman{group@\Roman{castlistcounter}}}{{\caststarfont#2}}
		}\else{
			\csgdef{gpersona@\Roman{castlistcounter}@\roman{group@\Roman{castlistcounter}}}{{\castfont#2}}
		}\fi
	\else
		\if@thischarstar{
			\csgdef{gpersona@\Roman{castlistcounter}@\roman{group@\Roman{castlistcounter}}}{{\caststarfont#1}}
		}\else{
			\csgdef{gpersona@\Roman{castlistcounter}@\roman{group@\Roman{castlistcounter}}}{{\castfont#1}}
		}\fi
	\fi

	% first expand the totalcharcounter, then pass it as argument
	\edef\@Romanchar{\Roman{totalcharcounter}}
	\expandafter\char@fullmacros\expandafter{\@Romanchar}{{\scshape#2}}{#3}
	}

\newsavebox{\tbox}

\newenvironment{chargroup}[1][]{
	\stepcounter{castlistcounter}			% each group counts as one character
	\csgdef{description@\Roman{castlistcounter}}{#1}	% description

	\newcounter{group@\Roman{castlistcounter}}	% count characters within the group
	\csgdef{persona@\Roman{castlistcounter}}{
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

\newlength{\castpageleftmargin}	\setlength{\castpageleftmargin}{1.5cm}
\newlength{\castpagerightmargin}	\setlength{\castpagerightmargin}{0pt}
\newlength{\castnamewidth} 		\setlength{\castnamewidth}{0.33\linewidth}
\newcommand{\castlistoptions}{	\itemsep=0pt
							\itemindent=0cm
							\topsep=0pt
							\parsep=10pt
							\listparindent=0cm}

%%%%% Functions %%%%%

\newcommand{\castlist}{
	\if@openright	\clearpage{\thispagestyle{empty}\cleardoublepage}
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
	\ifnum\value{actcounter}>0%
		\vspace{1.6ex}
		\centering
		\textsc{\curtainlocalizedtext}
		\par
	\fi

	\if@openright	\clearpage{\cleardoublepage}%\thispagestyle{empty}\cleardoublepage}
	\else			\clearpage
	\fi
	% \thispagestyle{plain}									% no header
}

\newcommand\@act[1]{
	\refstepcounter{actcounter}							% increment number of acts
	\phantomsection									% for hyperref
	\actmark{\acttitlename\ \theact}							% mark for headers
	\if\relax\detokenize{#1}\relax
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
	{\parindent 0pt	\parskip 0.25\baselineskip				% zero indentation, some line skip
	\centering\acttitlefont\acttitlename\ \theact				% print "Act III"
	%		<---- do not remove the %!
	\if\relax\detokenize{#1}\relax							% print act name
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

\newcommand\scene[1][]{
	\stepcounter{scenecounter}
	\vskip 1.0\baselineskip
	\@scene{#1}
	\parskip 0.5\baselineskip
}

\newcommand\@scene[1]{
	\phantomsection								% for hyperref
	\scenemark{\scenetitlename\ \thescene}				% mark for headers
	\if\relax\detokenize{#1}\relax
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
	\if\relax\detokenize{#1}\relax			% print scene name
	\else
		\sceneseparator#1
	\fi}%

	\par\nobreak{\recurse@scenecharlist}%
	\par\nobreak\vskip\aftersceneskip}
}

\newcommand\recurse@scenecharlist{%
	\stepcounter{charstemp}%
	%
	\@ifundefined{r@act\Roman{actcounter}scene\Roman{scenecounter}char\Roman{charstemp}}
		{}
		{\if@atleastonechar{,\ }\fi
		{\@nameuse{@char\Roman{charstemp}name}}%
		\@atleastonechartrue}%
	%
	\ifnum\value{charstemp}<\value{totalcharcounter}%
		\recurse@scenecharlist
	\fi
	\setcounter{charstemp}{0}%
}

%%%%%%%%%%%%%%%%%%%%%%%		Parentheticals

\def\@setupparen{
	\catcode`\(=\active\relax
	\catcode`\)=\active\relax
}
\def\@cleanupparen{
	\catcode`\(=12\relax
	\catcode`\)=12\relax
}

\@setupparen
\gdef(#1){{\itshape\char`\(#1\char`\)}}
\@cleanupparen

%%%%%%%%%%%%%%%%%%%%%%%		Underlined emphasis in lines

\def\@setupemph{
	\catcode`\_=\active\relax
}
\def\@cleanupemph{
	\catcode`\_=12\relax
}

\@setupemph
\gdef_#1_{\underline{#1}}
\@cleanupemph


%%%%%%%%%%%%%%%%%%%%%%%		Stage directions

\def\action#1{
	\begingroup
	\catcode`\^^M=\active\relax%
	\formataction{#1}%
}

%%%%%%%%%%%%%%%%%%%%%%%		Opening and technical directions



%%%%%%%%%%%%%%%%%%%%%%%		End of script

\AtEndDocument{
	\vspace{1.6ex}
	\centering
	\textsc{\curtainlocalizedtext}
	\par
	\vspace{1.6ex}
	\centering
	\textsc{\scriptendlocalizedtext}
}

%%%%%%%%%%%%%%%%%%%%%%%		Helper functions

\providecommand\phantomsection{}		% if hyperref does not exist
\newcommand\actmark[1]{}
\newcommand\scenemark[1]{}
\newcommand\castlistmark[1]{}

\newlength{\maxcharlength}\setlength{\maxcharlength}{0pt}
\newlength{\@thischarlength}

\long\def\@firstofone#1{#1}% Copied from the gobble package



