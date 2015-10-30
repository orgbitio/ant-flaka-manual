%
% This is Latex class "ant-flaka". It is going to be used like
%  \documentclass{ant-flaka}
% in this manual.

%
% Define some variables
%
\ifdefined\flakaversion\else\def\flakaversion{\it{undefined}}\fi
\ifdefined\documentversion\else\def\documentversion{\it{undefined}}\fi

%
% MISC
%
\NeedsTeXFormat{LaTeX2e}

% Declare this class
\ProvidesClass{ant-flaka}[2010/02/10 haefelinger IT ant-flaka]

% Make this class behaving like a book.
\LoadClass[11pt, a4paper,final]{article}[1999/04/29]

% Load the flaka style (which can also be used outside of this class)
\RequirePackage[hyperlink]{ant-flaka}

% end-of-file