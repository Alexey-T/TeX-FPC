% This is a change file of TeX for GNU Pascal, Wolfgang Helbig, Nov. 2007
% Handle command line as the first line, Apr. 2008
% Open vi at the offending line in error dialog Apr. 2008
% Avoid an underful last line,  use buffered output for dvi file, Jul. 2008
% That "finished" the program. But I kept on improving:
% July 2008:
% Don't print empty lines on terminal and log file.
% Don't trim ninput lines.
% November 2009:
% The last improvement caused an error: On reading a blank only
% first line might go into a loop. This error cannot be noticed by the user.
% It was noticed by Joachim Kuebart
% Some changes were necessary run TeX_GPC to Mac OS X
% with the current version of GPC. (pointed out by Martin Monperrus and
% Luis Rivera)
% July 2016: Switch from GNU Pascal to Free Pascal
% There is no GPC on Mac OS X, Debian 8, OpenBSD.
% 

[0] About TeX-FPC
@x
\def\gglob{20, 26} % this should be the next two sections of "<Global...>"
@y
\def\gglob{20, 26} % this should be the next two sections of "<Global...>"
\input webmac-fpc

\emergencystretch 0.6in % avoid overfull boxes 

\let\maybe=\iffalse % print changed modules only.

% put a mark in the left margin. (see Exercise 14.28 in The TeXbook)
\def\marke#1{\strut\vadjust{\kern-\dp\strutbox\vbox to 0pt{\vss
  \llap{\bf #1\/\quad\strut}}}\ignorespaces }

\def\name{\TeX}

\N0\*.  \[0] About \namefpc.
\namefpc\ is a Unix implementation of Donald~E. Knuth's \TeX82 in
the version 3.14159265 from January 2014. It is based on Free~Pascal.
The accompaning \.{README} file tells you how to build and run
\namefpc.  To help you identify the differences of \TeX82 and
\namefpc, the numbers of modified modules carry an asterisk. Letters
in the left margin indicate the reason for a change. They mean:
\medskip
\item{\bf E} fixes an error in \TeX82
\item{\bf e} fixes a small error in \TeX82
\item{\bf F} adds a feature as suggested by Knuth
\item{\bf P} removes a violation of Pascal (Jensen, Wirth: {\sl Pascal
User Manual and Report\/}, 3rd edition, 1985)
\item{\bf X} an FPC extension
\item{\bf U} make Unix happy
\item{\bf u} make Unix user happy
\item{\bf h} make Helbig happy
\item{\bf N} a note that helped me to understand this program.
\item{\bf B} a bug I couldn't fix.
\medskip

Identifiers that come with FPC~Pascal are coded as \.{WEB} macros and prefixed
by `\\{fpc\_}'. That helps to resolve name clashes.
\filbreak
Going with Dijkstra, see
\.{http://www.cs.utexas.edu/users/EWD/videos/noorderlicht.mpg}, I
don't believe in version numbers, since I don't believe in maintaining
software---I consider \namefpc\ finished---and it must go without
a number.
\filbreak
\namefpc\ slightly differs from \TeX: On input, trailing blanks are
not removed, on input of the first line, leading blanks are not
removed either. This lets you interactively enter `\.{I \\showbox0\
}' to make \namefpc\ show box 0.  This doesn't work if the trailing
blank were removed.

\TeX\ writes an additional empty line whenever it prompts you on
the terminal.  \namefpc\ doesn't. Finally \TeX\ emits an `\.{Underfull
\\hbox}' warning whenever the last line of a paragraph happens to include
glue only, because then \TeX\ would erroneously remove the
\.{parfillskip}. \namefpc\ will keep it.

% \TeX82 will emit an underfull box warning here, \namefpc\ won't.
\setbox0=\hbox to \hsize {\hfil\ \strut}
\noindent\box0\ \ \par
\bigskip
\address
\fi
@z

[2] Change the banner line
@x
known as `\TeX' [cf.~Stanford Computer Science report CS1027,
November 1984].

@d banner=='This is TeX, Version 3.14159265' {printed when \TeX\ starts}
@y
known as `\TeX' [cf.~Stanford Computer Science report CS1027,
November 1984].

\marke h Since \namefpc\ differs from \TeX\ to make me happy, I have to
change the banner line.

@d banner=='This is TeX-FPC'
@z

[4] program header
@x
@d mtype==t@&y@&p@&e {this is a \.{WEB} coding trick:}
@y

\marke P Pascal wants the identifiers of the standard text files
\\{input} and \\{output} in the parameterlist of the program header.

\marke N One of the \.{WEB} macros is named \\{input}
as well. To make \.{TANGLE} write \.{INPUT} into the Pascal source
file instead of the expansion of the macro, you code the name as
a concatenation of one letter identifiers since one letter identifiers
cannot be macro names. The same
applies to \\{type}.

@d term_in==i @& n @& p @& u @& t
@d term_out==o @& u @& t @& p @& u @& t
@d mtype==t @& y @& p @& e
@f mtype==type
@z

[4] program header
@x
program TEX; {all file names are defined dynamically}
@y
program TEX(@!term_in,@!term_out);
@z

Since @x, @y, and @z only define a change block when they begin a
line, you deactivate a block by indenting it (shift right) and
activate it by unindenting it (shift left).  With vi set the cursor
to the @x line and type >} or <} to (un)indent a paragraph.

[7] shift left to turn debugging on, right to turn it off
@x
@d debug==@{ {change this to `$\\{debug}\equiv\null$' when debugging}
@d gubed==@t@>@} {change this to `$\\{gubed}\equiv\null$' when debugging}
@y
@d debug== {change this to `$\\{debug}\equiv\.{@@\{}$' when not debugging}
@d gubed== {change this to `$\\{gubed}\equiv\.{@@\}}$' when not debugging}
@z

[7] shift left to turn stats on, right to turn them off.
@x
@d stat==@{ {change this to `$\\{stat}\equiv\null$' when gathering
  usage statistics}
@d tats==@t@>@} {change this to `$\\{tats}\equiv\null$' when gathering
  usage statistics}
@y
@d stat== {change this to `$\\{stat}\equiv\.{@@\{}$' to turn off statistics}
@d tats== {change this to `$\\{tats}\equiv\.{@@\}}$' to turn off statistics}
@z


  [8] shift left to build TEX and right to build INITEX.
 @x initex
 @d init== {change this to `$\\{init}\equiv\.{@@\{}$' in the production version}
 @d tini== {change this to `$\\{tini}\equiv\.{@@\}}$' in the production version}
 @y
 @d init==@{ {change this to `$\\{init}\equiv $' for \.{INITEX}}
 @d tini==@t@>@} {change this to `$\\{tini}\equiv $' for \.{INITEX}}
 @z

[9] compiler directives, turn off I/O checking.
@x
@^overflow in arithmetic@>
@y
@^overflow in arithmetic@>

\marke X If the first character of a \PASCAL\ comment is a dollar
sign, Free~Pascal treats the comment as a ``compiler directive''.
FPC aborts when it detects an I/O error. To let  \namefpc\ handle
an I/O error while opening an input file, you have to turn off I/O
checking altogether by the \.{I-} directive.


\marke X \$MODE ISO sets integer size to 32 bit, defines file procedures
get, put and allows nonlocal gotos.

\marke b In contrast to \ph\ Free~Pascal offers no directive to
check for arithmetic overflow.

\marke e Knuth suggests to turn on range checking while debugging.
FPC aborts when it spots range violation. Those violations might
happen when the debugger shows a memery cell assumed to contain a
|glue_ratio|.  Even though turning of range checking doubles the
speed of \TeX\ I suggest to turn it on when not debugging, just to
get another check from Knuth for discovering an error.

@^system dependencies@>
@^GNU Pascal@>
@z

[9] compiler directives, turn off I/O checking, continued
@x
@{@&$C-,A+,D-@} {no range check, catch arithmetic overflow, no debug overhead}
@!debug @{@&$C+,D+@}@+ gubed {but turn everything on when debugging}
@y
@{@&$I-@} {no I/O checking}
@{@&$M@&O@&D@&E I@&S@&O@}
@!debug @{@&$R-@}@+ gubed {no range check while debugging}
@z

[10] default case branch
@x
\PASCAL s have, in fact, done this, successfully but not happily!)
@:PASCAL H}{\ph@>

@d othercases == others: {default for cases not listed explicitly}
@y
\PASCAL s have, in fact, done this, successfully but not happily!)
@:PASCAL H}{\ph@>

\marke X This is the only place I voluntarily use an FPC extension
to Pascal.
@^FPC Pascal@>

@d othercases == @+ else {default for cases not listed explicitly}
@z

[11]
@x
in production versions of \TeX.
@y
in production versions of \TeX.

\marke N I didn't change the constants, leaving it up to you to
adopt them to your task. Just keep the Pascal source for \.{tex}
around. So you can change them without going all the way through
modifying \.{tex.ch} and tangeling it.  Note that for \.{initex}
|mem_top| and |mem_max| must agree.

\marke U One of the constants is the filename of the string pool
file which needs an adoption to Unix.
@z

The changes headed by trip need to be made for the trip test suite.

[11]
	@x trip
	@!mem_max=30000; {greatest index in \TeX's internal |mem| array;
	@y
	@!mem_max=3000; {greatest index in \TeX's internal |mem| array;
	@z

[11]
	@x trip
	@!mem_min=0; {smallest index in \TeX's internal |mem| array;
	@y
	@!mem_min=1; {smallest index in \TeX's internal |mem| array;
	@z

[11]
	@x trip
	@!error_line=72; {width of context lines on terminal error messages}
	@!half_error_line=42; {width of first lines of contexts in terminal
	  error messages; should be between 30 and |error_line-15|}
	@!max_print_line=79; {width of longest text lines output; should be at least 60}
	@y
	@!error_line=64; {width of context lines on terminal error messages}
	@!half_error_line=32; {width of first lines of contexts in terminal
	  error messages; should be between 30 and |error_line-15|}
	@!max_print_line=72; {width of longest text lines output; should be at least 60}
	@z

[11] location of pool file
@x
@!pool_name='TeXformats:TEX.POOL                     ';
@y
@!pool_name='TeXformats/tex.pool'; { \marke X arrays of different length are 
assignment compatible. }
@z


[12]
	@x trip
	@d mem_bot=0 {smallest index in the |mem| array dumped by \.{INITEX};
	  must not be less than |mem_min|}
	@d mem_top==30000 {largest index in the |mem| array dumped by \.{INITEX};
	  must be substantially larger than |mem_bot|
	  and not greater than |mem_max|}
	@y
	@d mem_bot=1 {smallest index in the |mem| array dumped by \.{INITEX};
	  must not be less than |mem_min|}
	@d mem_top==3000 {largest index in the |mem| array dumped by \.{INITEX};
	  must be substantially larger than |mem_bot|
	  and not greater than |mem_max|}
	@z


[25]
@x
for us to specify simple operations on word files before they are defined.
@y
for us to specify simple operations on word files before they are
defined.

\marke X
@d fpc_byte==b @& y @& t @& e
@d fpc_string == r@&a@&w@&b@&y@&t@&e@&s@&t@&r@&i@&n@&g

@^FPC Pascal@>
@z

[25] the type of text_files is text
@x
@!eight_bits=0..255; {unsigned one-byte quantity}
@!alpha_file=packed file of text_char; {files that contain textual data}
@y
@!eight_bits=fpc_byte; {unsigned one-byte quantity}
@!alpha_file=t @& e @& x @& t; {\marke P Pascal requires |text|}
@z

[27]
@x
\TeX's file-opening procedures return |false| if no file identified by
|name_of_file| could be opened.

@d reset_OK(#)==erstat(#)=0
@d rewrite_OK(#)==erstat(#)=0
@y
\marke X In Pascal, external files must occur in the program heading
and FPC~Pascal asks the user whenever an external file is
opened.  But \.{initex} wants to reset \.{tex.pool} and rewrite
\.{plain.fmt} without asking
the user for the file name.
FPC~Pascal lets you assign the file name to an external file.
The function |fpc_io_result| returns a nonzero value if any
error occurred since the last invocation of |fpc_io_result|.

@^GNU Pascal@>
@^system dependencies@>

@d fpc_io_result==i@&o@&r@&e@&s@&u@&l@&t
@d fpc_assign==a@&s@&s@&i@&g@&n
@d reset_OK(#)==fpc_io_result=0
@d rewrite_OK(#)==fpc_io_result=0
@d clear_io_result==@+if fpc_io_result=0 then do_nothing
@z

[27] reset and rewrite for each of three file types
@x alpha_file
begin reset(f,name_of_file,'/O'); a_open_in:=reset_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); reset(f);
a_open_in:=reset_OK(f);
@z
@x 
begin rewrite(f,name_of_file,'/O'); a_open_out:=rewrite_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); rewrite(f);
a_open_out:=rewrite_OK(f);
@z

byte_file
@x
begin reset(f,name_of_file,'/O'); b_open_in:=reset_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); reset(f);
b_open_in:=reset_OK(f);
@z
@x
function b_open_out(var f:byte_file):boolean;
  {open a binary file for output}
begin rewrite(f,name_of_file,'/O'); b_open_out:=rewrite_OK(f);
@y
function b_open_out(var f:byte_file):boolean;
  {open a binary file for output}
begin clear_io_result; fpc_assign(f,name_of_file); rewrite(f);
b_open_out:=rewrite_OK(f);
@z

@x word_file
begin reset(f,name_of_file,'/O'); w_open_in:=reset_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); reset(f); w_open_in:=reset_OK(f);
@z
@x
begin rewrite(f,name_of_file,'/O'); w_open_out:=rewrite_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); rewrite(f);
w_open_out:=rewrite_OK(f);
@z

[31]
@x
finer tuning is often possible at well-developed \PASCAL\ sites.
@^inner loop@>

@p function input_ln(var f:alpha_file;@!bypass_eoln:boolean):boolean;
  {inputs the next line or returns |false|}
var last_nonblank:0..buf_size; {|last| with trailing blanks removed}
begin if bypass_eoln then if not eof(f) then get(f);
  {input the first character of the line into |f^|}
last:=first; {cf.\ Matthew 19\thinspace:\thinspace30}
if eof(f) then input_ln:=false
else  begin last_nonblank:=first;
  while not eoln(f) do
    begin if last>=max_buf_stack then
      begin max_buf_stack:=last+1;
      if max_buf_stack=buf_size then
        @<Report overflow of the input buffer, and abort@>;
      end;
    buffer[last]:=xord[f^]; get(f); incr(last);
    if buffer[last-1]<>" " then last_nonblank:=last;
    end;
  last:=last_nonblank; input_ln:=true;
  end;
end;
@y
finer tuning is often possible at well-developed \PASCAL\ sites.
@^inner loop@>

\marke h Since \namefpc\ does not remove trailing spaces, |buffer[last-1]|
might hold a space.

\marke P
\ph\ lets you |reset| the terminal input file with the first |get|
`surpressed'.  For several reasons, this feature is not exploited by
\namefpc. First, it is not provided by FPC. Second rightly so, since
it violates the specification of Pascal. Third, it makes the program
quite ugly by destroying the beautiful equivalence of terminal and
disk files.  Fourth, since \namefpc\ uses Pascal's standard text
file |input|, it should not reset that file at all.  Fifth, surpressing
the first |get| is offered by \ph\ to address a problem, namely
that the program stays in the reset function waiting for user input
and this problem is solved much more beautiful by ``lazy I/O'',
whereby the program only waits for user input if it is needed. This
is suggested in the {\sl Pascal User Manual}, implemented by
Free~Pascal and exploited by \namefpc. This leads to a much cleaner
implementaion of |input_ln|, which can always savely assume that
|f^| holds the first character of the next line. This condition is
established by Pascal's |reset| and maintained by |input_ln|.

\marke h
Unlike \TeX82 \namefpc\ leaves trailing spaces in the input line.

@p function input_ln(var f:alpha_file;@!bypass_eoln:boolean):boolean;
  {inputs the next line or returns |false|}
var ch: char;
begin
  {ignore |bypass_eoln|. Assuming |f| being positioned at the first character}
last:=first; {cf.\ Matthew 19\thinspace:\thinspace30}
if eof(f) then input_ln:=false
else  begin 
  while not eoln(f) do
    begin if last>=max_buf_stack then
      begin max_buf_stack:=last+1;
      if max_buf_stack=buf_size then begin
	read_ln(f); {complete the current line}
	@<Report overflow of the input buffer, and abort@>;
	end;
      end;
    read(f, ch); buffer[last]:=xord[ch]; incr(last);
    end;
  read_ln(f); {Advance |f| to the first character of the next line}
  input_ln:=true;
  end;
end;
@z

[32] term_in and term_out are the standard pascal files
@x
is considered an output file the file variable is |term_out|.
@^system dependencies@>

@<Glob...@>=
@!term_in:alpha_file; {the terminal as an input file}
@!term_out:alpha_file; {the terminal as an output file}
@y
is considered an output file the file variable is |term_out|.
\marke P Pascal's standard text files are declared implicitly.
@z

[33]
@x
@ Here is how to open the terminal files
in \ph. The `\.{/I}' switch suppresses the first |get|.
@:PASCAL H}{\ph@>
@^system dependencies@>

@d t_open_in==reset(term_in,'TTY:','/O/I') {open the terminal for text input}
@d t_open_out==rewrite(term_out,'TTY:','/O') {open the terminal for text output}
@y
@ Here is how to open the terminal files
in \ph. The `\.{/I}' switch suppresses the first |get|.
@:PASCAL H}{\ph@>
@^system dependencies@>

\marke P In Pascal, the standard text files are openend implicitly.

@d t_open_in==do_nothing {open the terminal for text input}
@d t_open_out==do_nothing {open the terminal for text output}
@z

[34]
@x
some instruction to the operating system.  The following macros show how
these operations can be specified in \ph:
@:PASCAL H}{\ph@>
@^system dependencies@>
@y
some instruction to the operating system.

\marke X
Unix holds terminal output, when it receives \.{\^S} and
continues writing to the terminal, when it receives \.{\^Q}.  These
`flow control' characters only work when sent from the terminal but
not when sent to the terminal.  \marke B Here I give up, since I
don't know how to restart the output from the writing side so
\namefpc\ does nothing. Mac OS X does not stop terminal output when
it receives \.{\^S}.

@^Free Pascal@>
@^system dependencies@>
@z

[34]
@x
@d update_terminal == break(term_out) {empty the terminal output buffer}
@d clear_terminal == break_in(term_in,true) {clear the terminal input buffer}
@d wake_up_terminal == do_nothing {cancel the user's cancellation of output}
@y
@d fpc_flush == f@&l@&u@&s@&h
@d update_terminal == fpc_flush(term_out) {empty the terminal output buffer}
@d clear_terminal == do_nothing {clear the terminal input buffer}
@d wake_up_terminal == do_nothing {cancel the user's cancellation of output}
@z

[35]
@x
  begin write_ln(term_out,'Buffer size exceeded!'); goto final_end;
@y
  begin write_ln(term_out,'Buffer size exceeded!'); fpc_halt(3);
@z

[36] command line
@x
not be typed immediately after~`\.{**}'.)

@d loc==cur_input.loc_field {location of first unread character in |buffer|}

@y
not be typed immediately after~`\.{**}'.)

\marke F This procedure puts the command line arguments separated
by spaces into |buffer|. Like |input_ln| it updates |last| so that
|buffer[first..last)| will contain the command line.

\marke X FPC~Pascal's function~|@!fpc_param_count| gives the number of
command line arguments. The function~|@!fpc_param_str(n)| returns the
n-th argument for |0 <= n <= gpc_param_count| in a |@!fpc_string|,
whose length is returned by the function~|@!gpc_length|.
A |fpc_string| is like a |packed array[1..fpc_length] of char| with
varying length.

@^FPC Pascal@>
@^system dependencies@>

@d loc==cur_input.loc_field {location of first unread character in |buffer|}
@d fpc_length==l @& e @& n @& g @& t @& h
@d fpc_param_count==p @& a @& r @& a @& m @& c @& o @& u @& n @& t
@d fpc_param_str==p @& a @& r @& a @& m @&s @& t @& r
  {FPC function returning the length of a |fpc_string|}

@p procedure input_command_ln; {get the command line in |buffer|}
var argc: integer; {argument counter}
    arg: fpc_string; {argument}
    cc: integer; {character counter in argument}
begin last := first; argc := 1;
while argc <= fpc_param_count do
  begin cc := 1; arg := fpc_param_str(argc); incr(argc);
  while cc <= fpc_length(arg) do
    begin
    if last+1>=buf_size then
      @<Report overflow of the input buffer, and abort@>;
    buffer[last] := xord[arg[cc]]; incr(last); incr(cc);
    end;
  if (argc <= fpc_param_count) then begin
    buffer[last] := " "; incr(last); {insert a space between arguments}
    end;
  end;
end;
@z

[37] command line.
@x
@ The following program does the required initialization
without retrieving a possible command line.
It should be clear how to modify this routine to deal with command lines,
if the system permits them.
@^system dependencies@>

@p function init_terminal:boolean; {gets the terminal input started}
label exit;
begin t_open_in;
loop@+begin wake_up_terminal; write(term_out,'**'); update_terminal;
@.**@>
  if not input_ln(term_in,true) then {this shouldn't happen}
    begin write_ln(term_out);
    write(term_out,'! End of file on the terminal... why?');
@.End of file on the terminal@>
    init_terminal:=false; return;
    end;
  loc:=first;
  while (loc<last)and(buffer[loc]=" ") do incr(loc);
  if loc<last then
    begin init_terminal:=true;
    return; {return unless the line was all blank}
    end;
  write_ln(term_out,'Please type the name of your input file.');
  end;
exit:end;
@y
@ \marke F The following program treats a non empty command line as
the first line.


@p function init_terminal:boolean; {gets the terminal input started}
label exit;
begin t_open_in; input_command_ln;
while first=last do begin
  wake_up_terminal; write(term_out,'**'); update_terminal;
@.**@>
  if not input_ln(term_in, true) then {this shouldn't happen}
    begin write_ln(term_out);
    write_ln(term_out,'! End of file on the terminal... why?');
@.End of file on the terminal@>
    init_terminal:=false; return;
    end;
  if first=last then
    write_ln(term_out,'Please type the name of your input file.');
  end;
loc := first;
init_terminal:=true;
exit: end;
@z
[109]
@x
routines cited there must be modified to allow negative glue ratios.)
@y
routines cited there must be modified to allow negative glue ratios.)

\marke X In FPC~Pascal the type |fpc_single| is appropiate.
@d fpc_single== s@&i@&n@&g@&l@&e
@z

@x
@!glue_ratio=real; {one-word representation of a glue expansion factor}
@y
@!glue_ratio=fpc_single; {one-word representation of a glue expansion
			 factor in GNU~Pascal}
@^FPC Pascal@>
@z

[112]
@x
macros are simplified in the obvious way when |min_quarterword=0|.
@^inner loop@>@^system dependencies@>

@d qi(#)==#+min_quarterword
  {to put an |eight_bits| item into a quarterword}
@d qo(#)==#-min_quarterword
  {to take an |eight_bits| item out of a quarterword}
@d hi(#)==#+min_halfword
  {to put a sixteen-bit item into a halfword}
@d ho(#)==#-min_halfword
  {to take a sixteen-bit item from a halfword}
@y
macros are simplified in the obvious way when |min_quarterword=0|.
\marke X Which is the case with FPC.
@^inner loop@>@^system dependencies@>

@d qi(#)==#
  {to put an |eight_bits| item into a quarterword}
@d qo(#)==#
  {to take an |eight_bits| item out of a quarterword}
@d hi(#)==#
  {to put a sixteen-bit item into a halfword}
@d ho(#)==#
  {to take a sixteen-bit item from a halfword}
@z

[360] Don't print empty lines
@x
@ All of the easy branches of |get_next| have now been taken care of.
There is one more branch.
@y
@ All of the easy branches of |get_next| have now been taken care of.
There is one more branch.

\marke h \TeX82 ends the current line by calling |print_ln| even
if the line is empty.  This causes an additional empty line, which
is ugly.  Calling |print_nl("")| is smarter.  It ends the current
line only if it is not empty.
@z

@x
    print_ln; first:=start;
@y
    print_nl(""); first:=start;
@z

@x [514]
|TEX_font_area|.  These system area names will, of course, vary from place
to place.
@y
|TEX_font_area|.  These system area names will, of course, vary from place
to place.

\marke U Use the Unix file separator.
@z

[514]
@x
@d TEX_area=="TeXinputs:"
@.TeXinputs@>
@d TEX_font_area=="TeXfonts:"
@.TeXfonts@>
@y
@d TEX_area=="TeXinputs/" {i.e., a subdirectory of the working directory}
@.TeXinputs@>
@d TEX_font_area=="TeXfonts/" {dito}
@.TeXfonts@>
@z

[516]
@x
  if (c=">")or(c=":") then
@y
  if c="/" then {use ``/'' as a file name separator\marke U}
@z

[519]
@x
@d append_to_name(#)==begin c:=#; incr(k);
@y
@d fpc_set_length==s@&e@&t@&l@&e@&n@&g@&t@&h

@d append_to_name(#)==begin c:=#; incr(k);
@z

[519]
@x
@!j:pool_pointer; {index into |str_pool|}
@y
@!j:pool_pointer; {index into |str_pool|}
@!rbs: fpc_string;
@z

[519]
@x
if k<=file_name_size then name_length:=k@+else name_length:=file_name_size;
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
end;
@y
if k<=file_name_size then name_length:=k@+else name_length:=file_name_size;
rbs := name_of_file;
fpc_set_length(rbs, name_length);
name_of_file := rbs;
end;
@z

[521]
@x
TEX_format_default:='TeXformats:plain.fmt';
@y
TEX_format_default:='TeXformats/plain.fmt';
 {``/'' is the Unix file name separator\marke U}
@z

[523]
@x
isn't found.
@y
isn't found.
\marke X With Free~Pascal you cannot set the length of a |packed array|.
But assigning the |name_of_file| to a |fpc_string|, setting the length to the
|fpc_string| and then assigning it to the |name_of_file| saves the day.
@z
[523]
@x
@!j:integer; {index into |buffer| or |TEX_format_default|}
@y
@!j:integer; {index into |buffer| or |TEX_format_default|}
rbs: fpc_string;
@z

@x
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
@y
rbs := name_of_file;
fpc_set_length(rbs, name_length);
name_of_file := rbs;
@z

[575] Don't check eof
@x
no error message is given for files having more than |lf| words.
@y
no error message is given for files having more than |lf| words.
\marke X EOF is true, even before the end of file is passed. This is
an error of the free pascal runtime library.
@z
@x
if eof(tfm_file) then abort;
@y
@z

[816] save pointer to penalty_node
@x
same number of |mem|~words.
@^data structure assumptions@>
@y
same number of |mem|~words.
@^data structure assumptions@>

\marke E
\TeX82 prunes discardable nodes from the beginning of a new line until
it reaches a nondiscardable node. Now, if the last line of a paragraph
contains discardables only, the \.{\\parfillskip} glue at the end of the
paragraph will also be removed, since it is a discardable. This will
give you an empty \.{\\hbox}. Finally \TeX\ appends \.{\\rightskip} glue.
This gives you a nonempty \.{\\hbox}, raising a \.{Underfull \\hbox}
warning.

To avoid this happening, \namefpc\ saves a pointer to the node
immediately preceding the \.{\\parfillskip} node and quits pruning
when it encounters this node several procedures later.
@^Underfull \\hbox...@>
@z

@x
link(tail):=new_param_glue(par_fill_skip_code);
@y
non_prunable_p := tail; {points to the node immediately before
\.{\\parfillskip}}
link(tail):=new_param_glue(par_fill_skip_code);
@z

[862] declare non_prunable_p
@x
The following declarations provide for a few other local variables that are
used in special calculations.

@y
The following declarations provide for a few other local variables that are
used in special calculations.

\marke E Declare the |non_prunable_p| pointer.
@z

@x
@!auto_breaking:boolean; {is node |cur_p| outside a formula?}
@y
@!auto_breaking:boolean; {is node |cur_p| outside a formula?}
non_prunable_p:pointer; {pointer to the node before \.{\\parfillskip}}
@z

[876] pass non_prunable_p
@x
(By introducing this subprocedure, we are able to keep |line_break|
from getting extremely long.)
@y
(By introducing this subprocedure, we are able to keep |line_break|
from getting extremely long.)

\marke E Pass |non_prunable_p| to the |post_line_break|~procedure.
@z

@x
post_line_break(final_widow_penalty)
@y
post_line_break(final_widow_penalty, non_prunable_p)
@z

[877] declare non_prunable_p
@x
of their new significance.) Then the lines are justified, one by one.

@y
of their new significance.) Then the lines are justified, one by one.

\marke E Declare another parameter. It holds the pointer to the node
immediately preceding \.{\\parfillskip}.
@z

@x
procedure post_line_break(@!final_widow_penalty:integer);
@y
procedure post_line_break(@!final_widow_penalty:integer;
  non_prunable_p:pointer);
@z

[879]
@x
are computed for non-discretionary breakpoints.
@y
are computed for non-discretionary breakpoints.

\marke E The pointer |non_prunable_p| references the node immediately
preceding the \.{\\parfillskip} node at the end of the paragraph.
Stop pruning at this node.
@z

[879]
@x
  if non_discardable(q) then goto done1;
@y
  if non_discardable(q) then goto done1;
  if q = non_prunable_p then goto done1; {retain \.{\\parfillskip} glue}
@z

[1327]
@x
if (x<>69069)or eof(fmt_file) then goto bad_fmt
@y
if (x<>69069) then goto bad_fmt
@z

[1332]
@x
The initial test involving |ready_already| should be deleted if the
\PASCAL\ runtime system is smart enough to detect such a ``mistake.''
@^system dependencies@>
@y
The initial test involving |ready_already| should be deleted if the
\PASCAL\ runtime system is smart enough to detect such a ``mistake.''
@^system dependencies@>

\marke h \namefpc\ tries to load the format file even before it
initializes the output routines. That way, it will print the name of
the format file on the terminal.

\marke X 
|@!fpc_halt|
passes the |history| as an exit code to the shell.

@^system dependencies@>
@^GNU Pascal@>
@^Unix@>

@d fpc_halt == h@&a@&l@&t
@z

[1332]
@x
start_of_TEX: @<Initialize the output routines@>;
@y
start_of_TEX: @<Preload the default format file@>;
@<Initialize the output routines@>;
@z

[1332]
@x
final_end: ready_already:=0;
@y
final_end:
fpc_halt(history);
  {pass |history| as the exit value to the system\marke u}
@z

[1333] print last end-of-line marker if needed
@x
This program doesn't bother to close the input files that may still be open.
@y
This program doesn't bother to close the input files that may still be open.

\marke h
Special care is taken to terminate the last line on the terminal.

@z

[1333] print last end-of-line marker if needed
@x
    slow_print(log_name); print_char(".");
    end;
  end;
end;
@y
    slow_print(log_name); print_char(".");
    end;
  end;
  if term_offset > 0 then wterm_cr;
end;
@z

[1338] return if eof.
@x
program below. (If |m=13|, there is an additional argument, |l|.)
@.debug \#@>

@y
program below. (If |m=13|, there is an additional argument, |l|.)
@.debug \#@>

\marke P A Pascal program must not read from the standard text file
if the end of file is reached. Even in this respect, Unix and Pascal
treat terminals and disk files alike.

@z
@x
begin loop begin wake_up_terminal;
@y
begin loop begin; wake_up_terminal;
@z

@x
  read(term_in,m);
@y
  if eof(term_in) then return;
  read(term_in,m);
@z

[1338] return if eof
@x
  else  begin read(term_in,n);
@y
  else  begin if eof(term_in) then return;
  read(term_in,n);
@z

[1339] return if eof
@x
13: begin read(term_in,l); print_cmd_chr(n,l);
@y
13: begin if eof(term_in) then return;
read(term_in,l); print_cmd_chr(n,l);
@z

[1379 and modules added for TeX-FPC]
@x
itself will get a new section number.
@^system dependencies@>
@y
itself will get a new section number.

\marke h Try to preload the default format file. This is called
even before the first line is read from the terminal, and thus
turns \.{VIRTEX} into \.{TEX}, at least as experienced by the user.
\.{INITEX} sets |format_ident| to `\.{INITEX}' and won't load a
format file here.

@<Preload the default format file@>=
if format_ident = 0 then
  begin pack_buffered_name(format_default_length - format_ext_length, 1, 0);
  if not w_open_in(fmt_file) then
    begin
    wterm_ln('I can''t find the format file ', name_of_file);
    goto final_end
    end;
  if not load_fmt_file then
    begin w_close(fmt_file); goto final_end
    end;
  w_close(fmt_file);
  end
@z
