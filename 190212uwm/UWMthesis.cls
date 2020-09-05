\NeedsTeXFormat{LaTeX2e} 
\ProvidesClass{UWMThesis}[2007/09/11 v1.0 mami]

\LoadClass[12pt,letterpaper,oneside,openany]{book}

%% Included Packages
	\RequirePackage[doublespacing]{setspace}		% provides doublespace mode
	\RequirePackage{ifthen}			% boolean flags
	\RequirePackage{fancyhdr}		% used to redefine pagestyle{plain}
	
%% Variables and counters
	\newboolean{masters} \setboolean{masters}{false}					% true -> Masters, 
																						% false -> PhD
	\newboolean{multvolumes}\setboolean{multvolumes}{false}			% true -> thesis consists of multiple volumes,
																						% false -> one volume
	\newcounter{volume}\setcounter{volume}{1}								% counts the current volume
	\newboolean{singleappendix} \setboolean{singleappendix}{true}	% true -> thesis has only one appendix,
																						% false -> thesis has more than one appendix
	\newboolean{helpappendix} \setboolean{helpappendix}{false}		% true -> \ThesisAppendix has been called,
																						% false -> still in \ThesisMainmatter mode
																						% (use helpappendix only in this file)

%% Options for this class
	\DeclareOption{master}{\setboolean{masters}{true}}					% thesis in Master's mode
	\DeclareOption{phd}{\setboolean{masters}{false}}					% PhD mode
	\DeclareOption*{\ClassWarning{UWMThesis}{Unknown option `\CurrentOption'}} % other options produce warning 
	\ProcessOptions
	\ExecuteOptions{master}\ExecuteOptions{phd}

%% Default Values
	\newcommand{\UniversityName}{The University of Wisconsin--Milwaukee}
	\newcommand{\ThesisAuthor}{Name}
	\newcommand{\ThesisMonth}{December}
	\newcommand{\ThesisYear}{9999}
	\newcommand{\ThesisTitle}{Title}
	\newcommand{\ThesisType}{\ifthenelse{\boolean{masters}}{Thesis}{Dissertation}}
	\newcommand{\ThesisDegree}{\ifthenelse{\boolean{masters}}{Master of Science}{Doctor of Philosophy}}
	\newcommand{\ThesisArea}{Mathematics}
	\newcommand{\ThesisAdvisor}{Name}

%% Page Layout 
	\setlength{\evensidemargin}{0in}
	\setlength{\marginparwidth}{0.5in}
	\setlength{\topmargin}{-0.55in}
	\setlength{\headheight}{0.25in}
	\setlength{\textheight}{9.1in}
	\setlength{\textwidth}{5.9in}
	\setlength{\footskip}{0.3in}

%% redefine \frontmatter,\mainmatter,\appendix
	\newcommand{\ThesisFrontmatter}{	\pagenumbering{roman} 
												\pagestyle{plain}
												}
	\newcommand{\ThesisMainmatter}{	\mainmatter
												\fancypagestyle{plain}{%
													\fancyhf{}%
													\fancyhead[R]{\thepage}%
													\renewcommand{\headrulewidth}{0pt}%
													\renewcommand{\footrulewidth}{0pt}%
													}
												\pagestyle{myheadings}
												}	
	\newcommand{\ThesisAppendix}{ 	\appendix 
												\clearpage
												\setboolean{helpappendix}{true}
												\ifthenelse{\boolean{singleappendix}}{\addcontentsline{toc}{chapter}{\ \quad \textbf{Appendix}}}{}
												}

%% Preliminary Pages
	%% page ii of the thesis, called in \ThesisTitlepage, below
	\newcommand{\ThesisSignaturePage}{	\begin{center}
														\textsc{\Large \ThesisTitle}\\[4ex]
														by \\[4ex]
														\ThesisAuthor \\
														\vspace*{8ex}
%							  			         	\singlespace 		(Check with GradSchool)
														A \ThesisType\ Submitted in \\
														Partial Fulfillment of the \\
														Requirements for the Degree of \\[8ex]
														\textsc{\ThesisDegree} \\
														in \\
														\textsc{\ThesisArea} 
														\vspace*{8ex}
													
														at\\
														\UniversityName\\ 
														\ThesisMonth\ \ThesisYear
													\end{center}
													\vspace*{10ex}

													\hrule
													\vspace*{1ex}
													\indent Major Professor\hfill Date \qquad\mbox{}
													\vspace*{10ex}
	
													\hrule
													\vspace*{1ex}
													\indent Graduate School Approval \hfill Date \qquad\mbox{}
													\clearpage
													}
%% front page
	\newcommand{\ThesisTitlepage}{	\clearpage	
												\thispagestyle{empty}
												\ifthenelse{\(\not \boolean{multvolumes}\) \and
														 		\(\not\equal{\thevolume}{1}\)}{
														 			\ClassWarning{UWMTheorem}{Use ThesisTitlepage only once unless in multivolumes-mode.}
														 			}{
														 				}
												\ifthenelse{\equal{\thevolume}{1}}{
																								}{\addtocounter{page}{-1}
																									}
												\begin{center}
													\mbox{}\vspace*{8ex}\par
													\textsc{\Large \ThesisTitle}\\[3ex]
											      \ifthenelse{\boolean{multvolumes}}{\textsc{\Large Volume\ \Roman{volume}}\\[2ex]	
											      												}{\mbox{}\vspace*{1ex}
											      													}
											 		by \\[4ex]
													\ThesisAuthor\\
											      \vspace*{8ex}
%      											\singlespace
													A \ThesisType\ Submitted in \\
													Partial Fulfillment of the \\
													Requirements for the Degree of \\
													\vspace*{8ex}
			
													\textsc{\ThesisDegree} \\
													in \\
													\textsc{\ThesisArea} 
													\vspace*{8ex}
			
													at\\[4ex]
													\UniversityName\\ 
													\ThesisMonth\ \ThesisYear
												\end{center}
												\pagebreak
												\ifthenelse{\equal{\thevolume}{1}}{\ThesisSignaturePage
																								}{
																									}
												\addtocounter{volume}{1}
										}
%%Abstract environment
	\newenvironment*{ThesisAbstract}{	\begin{center}
														\textsc{\large Abstract} 
														\vspace*{2ex}
													  \begin{singlespace}
														\textsc{\large \ThesisTitle}\\[14pt]
  														by \\[14pt]
														\ThesisAuthor \\
														\end{singlespace}
														\vspace*{8mm}
														\singlespace
														\UniversityName, \ThesisYear \\
														Under the Supervision of Professor \ThesisAdvisor
													\end{center}
													\begin{doublespace}
													\vspace*{1.5ex}
													\setlength{\parindent}{0em}
													}{	\nobreak 
														\mbox{}
														\vspace*{10ex}
														\mbox{}
														\vfill
														\setlength{\parindent}{1.5em}
														\hrule
														\vspace{1ex}
														\indent  Major Professor \hfill Date \qquad\mbox{}
														\end{doublespace}
														\clearpage
														}
%% Copyrightpage
	\newcommand{\ThesisCopyright}{	\mbox{}
												\vfill
												\begin{singlespace}
												\begin{center}
													\textcopyright\ Copyright by \ThesisAuthor, \ThesisYear\\
													All Rights Reserved
												\end{center}
												\end{singlespace}
												\vfill
												\clearpage
												}
%% Dedication
	\newcommand{\ThesisDedication}[1]{	\mbox{}
													\vfill
													\begin{center}
														#1
													\end{center}
													\vfill
													\clearpage
													}
%% Frontispiece and epigraph use same command
	\newcommand{\ThesisFrontispiece}[1]{ 	\mbox{}
														\vfill
														\begin{center}
															#1
														\end{center}
														\vfill
														\clearpage
														}
%% Acknowledgement
	\newenvironment*{ThesisAcknowledgement}{	\clearpage
															
															\begin{center} 
																\textsc{\Large Acknowledgements} 
															\end{center}
															\vspace*{8ex}
															}{	\clearpage
																}

%% redefined lists and tables
	\renewcommand{\contentsname}{	\vspace{-1ex}
											\begin{center}
												{\Large \sc Table of Contents}
											\end{center}
											}
	\renewcommand{\listfigurename}{	\vspace{-1ex}
												\begin{center}
													{\Large \sc List of Figures}
												\end{center}
												}
	\renewcommand{\listtablename}{	\vspace*{-1ex}
												\begin{center}
													{\Large \sc List of Tables}
												\end{center}	
												}
	\renewcommand{\bibname}{	\begin{center}
											{\Large \sc Bibliography}
										\end{center}
										}

%% Environment to create Curriculum Vitae
	\newenvironment*{ThesisCV}{	\clearpage 
											\mbox{}
											\vspace{0.9in}
											\begin{center}
												{\bf \sc \Large Curriculum Vitae}
											\end{center} 
											\ifthenelse{\boolean{masters}}{	\ClassWarning{UWMThesis}{CV is used in PhD-Thesis only.}
																						}{
																							}
											}{	\nobreak	
												\parbox[c]{	\textwidth}{	\vspace*{14ex} 
																					\hrule
																					\vspace*{1ex}
																					\indent  Major Professor \hfill Date\qquad\mbox{}
																					}
												\clearpage
												}

%% redefine appearance of appendix if the flag \singleappendix is used (taken from book.cls)
	\renewcommand{\@makechapterhead}[1]{	\vspace*{-16ex}
														\ifthenelse{\boolean{helpappendix}}{	
															\vspace*{50\p@}
															{\parindent \z@ \raggedright \normalfont
															\ifnum \c@secnumdepth >\m@ne
													      \if@mainmatter
												      	\ifthenelse{\boolean{singleappendix}}{
												      		\Large\bfseries \@chapapp
												      		}{
												      			\Large\bfseries \@chapapp\space \thechapter
												      			}
															\par\nobreak
															\vskip 20\p@
															\fi
															\fi
															\interlinepenalty\@M
															\Large \bfseries #1\par\nobreak
															\vskip 40\p@
															}
														}{	\vspace*{50\p@}
															{\parindent \z@ \raggedright \normalfont
															\ifnum \c@secnumdepth >\m@ne
															\if@mainmatter
															\Large\bfseries \@chapapp\space \thechapter
															\par\nobreak
															\vskip 20\p@
															\fi
															\fi
															\interlinepenalty\@M
															\Large \bfseries #1\par\nobreak
															\vskip 40\p@
															}
															}
															}

	\renewcommand{\@makeschapterhead}[1]{	\vspace*{-6ex}
														{\parindent \z@ \raggedright
													   \normalfont
														\interlinepenalty\@M	
														\Large \bfseries  #1\par\nobreak
														\vskip 40\p@
														}
														}
																									
\endinput %% end of UWMThesis.cls