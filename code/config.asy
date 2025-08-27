import settings;
import size10;

prc = false;
settings.outformat = "pdf";
settings.inlinetex = false;
settings.tex = "lualatex";

defaultpen(fontsize(10));

// Включает/отключает локаль (например, десятичный разделитель --- запятая)
// locale("ru_RU.UTF-8");

texpreamble("
\usepackage[no-math]{fontspec}
\usepackage{polyglossia}
\setdefaultlanguage[indentfirst=true,spelling=modern]{russian}
\setotherlanguage{english}

\usepackage{amsmath}
\usepackage{unicode-math}

\unimathsetup{
  mathbf=sym,
  mathrm=sym,
  mathsf=sym,
}

\setmainfont{IBM Plex Serif}
\setromanfont{IBM Plex Serif}
\setsansfont{IBM Plex Sans}
\setmonofont{IBM Plex Mono}

\setmathfont{Latin Modern Math}

\usepackage{physics-patch}
% Нужно, если включена локаль, иначе какая-то беда
% с сеткой на графиках см. https://asymptote.sourceforge.io/FAQ/section4.html#decsep
%\usepackage{icomma}
");