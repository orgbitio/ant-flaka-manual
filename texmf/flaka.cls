%
% This is Latex class 'flaka'. It is going to be used like
%  \documentclass{flaka}
% in the Flaka manual.

\def\flakaversion{1.2}
\def\documentversion{1.1}
\NeedsTeXFormat{LaTeX2e}
% Declare this class
\ProvidesClass{flaka}[2010/02/10 haefelinger IT flaka]

% Make this class behaving like a book.
\LoadClass[10pt, a4paper,final]{article}[1999/04/29]

% Load the flaka style (which can also be used outside of this class)
\RequirePackage[hyperlink]{flaka}

% end-of-file