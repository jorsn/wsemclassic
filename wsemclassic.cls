% wsemclassic.cls
% Copyright 2013 Johannes Rosenberger
%
% This work may be distributed and/or modified under the
% conditions of a BSD Style License (see file 'LICENSE').
%
% This work consists of the file 'wsemclassic.cls'.


\NeedsTeXFormat{LaTeX2e}

\newcommand{\report}{report} % makes changing parent class later easier

\ProvidesClass{wsemclassic}[2013/06/08 document class for bavarian school w-seminar papers, based on \report]


\RequirePackage{kvoptions}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Option processing

\SetupKeyvalOptions{
	prefix = ws@
}

% strictness
\DeclareBoolOption[false]{strict}
\DeclareBoolOption[false]{stricttitle}

\DeclareBoolOption[false]{frenchspacing}
\DeclareComplementaryOption{nofrenchspacing}{frenchspacing}

% format and lang
\DeclareStringOption[12]{fontsize}	% pt
\DeclareStringOption[a4]{paper}
\DeclareStringOption[german]{lang}	% no ngerman
\DeclareBoolOption[true]{plxtex}  % pdf-, Xe-, or LuaTeX
\DeclareComplementaryOption{noplxtex}{plxtex}


% fontspec
\DeclareStringOption[quiet]{fontspecargs}
\DeclareStringOption[Ligatures={TeX, Common}, Fractions=On]{defaultfontfeatures}
\DeclareStringOption[CMU Serif]{mainfont}
\DeclareStringOption[CMU Sans Serif]{sansfont}
\DeclareStringOption[CMU Typewriter Text]{monofont}

% hyperref
\DeclareBoolOption[true]{hyperref}
\DeclareComplementaryOption{nohyperref}{hyperref}
\DeclareStringOption[unicode]{hyperrefargs}

% microtype
\DeclareStringOption[babel]{microtypeargs}

% amsmath
\DeclareStringOption{amsmathargs}

% titlesec
\DeclareStringOption[small]{titlesecargs}

% geometry
\DeclareStringOption{geometryargs}

% fancyhdr
\DeclareStringOption{fancyhdrargs}

% tocbibind
\DeclareStringOption[nottoc]{tocbibindargs}


% bibliography
\DeclareBoolOption[true]{bib}
\DeclareComplementaryOption{nobib}{bib}
\DeclareStringOption[\jobname]{bibfile}

% natbib
\DeclareBoolOption[true]{natbib}
\DeclareComplementaryOption{nonatbib}{natbib}
\DeclareStringOption[round]{natbibargs}
\DeclareStringOption[natdin]{bibstyle}


% and the rest
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{\report}}

\ProcessKeyvalOptions*\relax


% Parent class \report
\PassOptionsToClass{\ws@fontsize pt, \ws@lang}{\report}
\ifx \ws@paper custom \else
  \PassOptionsToClass{\ws@paper paper}{\report}
\fi

\LoadClass{\report}


\newcommand{\babellang}{
  \ifx \ws@lang german
    ngerman
  \else
    \ws@lang
  \fi
}


\RequirePackage{iftex}

\ifPDFTeX
  \RequirePackage[utf8x]{inputenx}
  \RequirePackage[T1]{fontenc}

  \RequirePackage[\babellang]{babel}
  \RequirePackage[fixlanguage]{babelbib}

\else % if luatex or xelatex
  \ifXeTeX
    \RequirePackage{polyglossia}
    \setdefaultlanguage[babelshorthands, spelling=new]{german}
  \else
    \RequirePackage[\babellang]{babel}
    \RequirePackage[fixlanguage]{babelbib}
  \fi

  \RequirePackage[\ws@fontspecargs]{fontspec}
  \defaultfontfeatures{\ws@defaultfontfeatures}
\fi


\ifws@hyperref
  \RequirePackage[\ws@hyperrefargs]{hyperref}
\fi

\ifws@plxtex
  \RequirePackage[\ws@microtypeargs]{microtype}
\fi

\RequirePackage[\ws@amsmathargs]{amsmath}
\RequirePackage{amsthm,amssymb}

\RequirePackage[\ws@titlesecargs]{titlesec}


\ifws@natbib
  \RequirePackage{natbib}
\fi


\RequirePackage{setspace}
\onehalfspacing

\RequirePackage[\ws@geometryargs]{geometry}
\newcommand{\setgeometry}[1]{\geometry{#1}}
\ifx \ws@paper custom \else
  \setgeometry{\ws@paper paper, scale=0.75, centering}
\fi

\RequirePackage{fancyhdr}
\pagestyle{fancy}


\RequirePackage[\ws@tocbibindargs]{tocbibind}


\renewcommand{\headwidth}{\textwidth}
\fancypagestyle{wsfancy}{
  \fancyhead{}

  \newif\iffirstsection
  \firstsectiontrue

  \def\setchaptermark##1{
	  \firstsectiontrue
	  \edef\mark@chapter{##1}
	  \rhead{\mark@chapter}
  }
  \def\setsectionmark##1{
	  \edef\mark@section{##1}
	  \lhead{\mark@section}
  }
  \def\setsubsectionmark##1{
	  \iffirstsection
	  \firstsectionfalse
	  \edef\mark@subsection{##1}
	  \lhead{\mark@section\\\mark@subsection}
	  \fi
  }

  \renewcommand{\chaptermark}[1]{\setchaptermark{\chaptername~\thechapter.~~##1}}
  \renewcommand{\sectionmark}[1]{\setsectionmark{\thesection~~##1}}
  \renewcommand{\subsectionmark}[1]{\setsubsectionmark{\thesubsection~~##1}}
}

\ifws@strict
  \setgeometry{top=2cm, bottom=2cm, left=2.5cm, right=2.5cm, a4paper}
  \titleformat{\chapter}{\normalfont\Large\bfseries}{\thechapter}{1em}{}{}
  \ws@frenchspacingtrue
  \ws@stricttitletrue

  \fancypagestyle{plain}{
    \fancyhf{}
    \chead{\thepage}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
  }
  \pagestyle{plain}
  \addtocontents{toc}{\protect\thispagestyle{empty}}
\else
  \pagestyle{wsfancy}
\fi

\ifws@frenchspacing
  \frenchspacing
\fi



\ifws@plxtex
  \newcommand{\spaced}[1]{\textls[250]{\ifPDFTeX\else\addfontfeatures{Renderer=Basic}\fi#1}}
\else
  \RequirePackage{soulutf8}
  \newcommand{\spaced}[1]{\so{#1}}
\fi

\newcommand{\mainstyle}[1]{\Large\bfseries\textsc{\spaced{#1}}}

\newcommand{\submainstyle}[1]{#1}
\newcommand{\subjectstyle}[1]{\textit{#1}}
\newcommand{\titlestyle}[1]{\large\textit{#1}}

\ifws@stricttitle
  \renewcommand{\mainstyle}[1]{\large\bfseries\MakeUppercase{\spaced{#1}}}
  \renewcommand{\titlestyle}[1]{\textit{#1}}
\fi

\renewcommand{\@date}{Date}
\newcommand{\@subject}{Subject}
\newcommand{\@school}{School}
\newcommand{\@major}{Major}
\newcommand{\@teacher}{Teacher Name}
\newcommand{\@place}{Place}


\ifws@hyperref
  \newcommand{\hypermeta}[2]{
    \hypersetup{
      pdf#1=#2
    }
  }
\else
  \newcommand{\hypermeta}[2]{}
\fi

\newcommand{\setmeta}[2]{
  {
    \def\@metaname{@#1}
    \expandafter\gdef\csname\@metaname\endcsname{#2}
    \hypermeta{#1}{#2}
  }
}

\renewcommand{\author}[1]{\setmeta{author}{#1}}
\renewcommand{\title}[1]{\setmeta{title}{#1}}
\renewcommand{\date}[1]{\setmeta{date}{#1}}
\newcommand{\subject}[1]{\setmeta{subject}{#1}}
\newcommand{\school}[1]{\setmeta{school}{#1}}
\newcommand{\major}[1]{\setmeta{major}{#1}}
\newcommand{\teacher}[1]{\setmeta{teacher}{#1}}
\newcommand{\place}[1]{\setmeta{place}{#1}}


\newcommand{\newcaption}[3]{
  {
    \def\@capname{caption@#1@#2}
    \def\@dcapname##1{caption@##1@#2}
    \expandafter\gdef\csname\@capname\endcsname{#3}
    \expandafter\xdef\csname#2\endcsname{\csname\@dcapname{\ws@lang}\endcsname}
  }
}

\newcaption{german}{qpname}{Qualifikationsphase}
\newcaption{german}{mainname}{Seminararbeit}
\newcaption{german}{submainname}{im Wissenschaftsprop\"adeutischen Seminar}
\newcaption{german}{authorname}{Verfasser}
\newcaption{german}{majorname}{Leitfach}
\newcaption{german}{teachername}{Seminarleiter}
\newcaption{german}{closingname}{Selbstst\"andigkeitserkl\"arung}



\newcommand{\placeholder}{\rule[-.5ex]{5cm}{.4pt}}

\renewcommand{\maketitle}{
  \begin{titlepage}
    \ifws@strict \else
      \newgeometry{left=2.5cm, right=2.5cm}
    \fi
    \setlength{\parindent}{\z@}
    \setlength{\parfillskip}{\z@\@plus1fil}
    %\setparsizes{\z@}{\z@}{\z@\@plus1fil}\par@updaterelative
    \singlespacing
    {\@school\hfill\@date\par}
    {\qpname\par}
    \vskip 7em
    \begin{center}
	    {\mainstyle{\mainname}\par}
      \vskip .5em
      {\submainstyle{\submainname}\par}
      \vskip .5em
      {\subjectstyle{\@subject}\par}
      \vskip .5em
      {\titlestyle{\@title}\par}
    \end{center}
    \vskip 10em
    \doublespacing
    \begin{tabular}{rl}
      \authorname: & \@author \\
      \majorname: & \@major \\
      \teachername: & \@teacher \\
      Abgabetermin: & \placeholder \\[1em]
      Note Seminararbeit: & \placeholder \\
      Punkte Seminararbeit (einfache Wertung): & \placeholder \\
      Punkte Pr\"asentation: & \placeholder \\
      Gesamtleistung (doppelte Wertung): & \placeholder \\
      Eintrag des Ergebnisses: & \placeholder \\[1em]
      Unterschrift des Seminarleiters: & \placeholder
    \end{tabular}
    \ifws@strict \else
      \restoregeometry
    \fi
  \end{titlepage}
  \stepcounter{page}
}


\newcommand{\makebib}{
  \ifws@bib
    \nocite{*}
    \bibliographystyle{\ws@bibstyle}
    \bibliography{\ws@bibfile}
  \fi
}

\newcommand{\makeclosing}{
 \newpage

 \setlength{\parindent}{\z@}
 \setlength{\parfillskip}{\z@\@plus1fil}
 %\setparsizes{\z@}{\z@}{\z@\@plus1fil}\par@updaterelative
 \chapter*{\protect\closingname}
 \addcontentsline{toc}{chapter}{\protect\closingname}
 {Ich erkl\"are, dass ich die Seminararbeit ohne fremde Hilfe angefertigt
 und nur die im Literaturverzeichnis angef\"uhrten Quellen und Hilfsmittel benutzt habe.\par}
 \vskip 2em
 {\@place, den \today\hfill\placeholder\par}
}


\AtBeginDocument{\maketitle\tableofcontents}
\AtEndDocument{\makebib\makeclosing}


% vim: filetype=tex shiftwidth=2 tabstop=2 expandtab
