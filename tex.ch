% This is a change file of TeX, Wolfgang Helbig, Nov. 2007-Feb. 2021

[0] About TeX-FPC
@x nwebmac
\outer\def\N#1. \[#2]#3.{\MN#1.\vfil\eject % begin starred section
  \def\rhead{PART #2:\uppercase{#3}} % define running headline
@y
\outer\def\N#1. \[#2]#3.{ % begin starred section
  {\xdef\modstar{#1}\let\*=\empty\xdef\modno{#1}}% remove \* from section name
  \ifx\modno\modstar \onmaybe \else\ontrue \fi
  \def\rhead{PART #2:\uppercase{#3}} % define running headline
  \ifon\mark{{{\tensy x}\modno}{\rhead}}
    \vfil\eject
  \fi
@z
Strangely, the first page is page 3
@x
\pageno=3
@y
@z
@x
\def\gglob{20, 26} % this should be the next two sections of "<Global...>"
@y
\def\gglob{20, 26} % this should be the next two sections of "<Global...>"
\input TeXinputs/webmac-fpc
\pagewidth=14.8 cm % Close to the original book format.
\setpage

\emergencystretch 0.6in % avoid overfull boxes 

\let\maybe=\iffalse % maybe -> print all, notmaybe -> print changed modules only

% put a mark in the left margin. (see Exercise 14.28 in The TeXbook)
\def\marke#1{\strut\vadjust{\vbox to 0pt
   {\vskip-\baselineskip\moveleft 2em\hbox{\bf #1\strut}\vss}}\ignorespaces}

\def\name{\TeX}

\N0\*.  \[0] About \namefpc.
\namefpc\ is a port of Donald~E. Knuth's typesetting program \TeX,
version 3.141592653 from February 2021 to Free~Pascal (FPC) and Unix.
To help you identify the differences of \TeX\ and
\namefpc, the numbers of modified modules carry an asterisk. Letters
in the left margin indicate the reason for a change. They mean:
\medskip
\item{\bf E} fixes an error in \TeX82
\item{\bf F} adds a feature as suggested by Knuth
\item{\bf P} fixes a violation of Pascal (Jensen, Wirth: {\sl Pascal
User Manual and Report\/}, 3rd edition, 1985)
\item{\bf X} describes an FPC extension 
\item{\bf U} necessary change in Unix
\item{\bf u} enhances usability in a Unix enviroment
\medskip
\item{(1)} \marke E \TeX82\ deletes area and extension of an input
file name and then only shows the base name of the file during error
recovery.

\item{(2)} \TeX82 prunes discardable nodes from the beginning of a
new line until it reaches a nondiscardable node. This might leave
you with an empty box resulting in an \.{Underfull box} warning.
Btw, I discovered this bug while trying to prove the line breaking
algorithm, not while plain testing it. If you have time, prove, if
not test.

\item{(3)} \TeX\ fails to respect end of file (Control-D) from
terminal input during debug dialog.

\item{(4)}
Igor Liferenko reported an extra space in the transcript file
after the user switched to \.{/batchmode} during error recovery.

\medskip
\item{(1)}\marke F\namefpc\ treats the command line as the first input line;

\item{(2)}\namefpc\ starts \.{ed}, the unix system editor, if the
user types `\.{E}' during error recovery.

\item{(3)}You can interrupt \namefpc\ by typing `\.{Control-C}'.

\medskip
\item{(1)}\marke P \TeX82 assumes that the terminal input file is
positioned {\sl before\/} the first character after being opened,
whereas \namefpc\ assumes that it is positioned {\sl at\/} the first
character, thus complying with the Pascal standard.

\item{(2)} The names of the standard text files must occur in the
program header whenever they are used.

\item{(3)} The standard text files must not be declared. Declared files
with the name of the standard text files are new internal files.

\item{(4)} The program must not open the standard text files.

\medskip
\item{(1)} \marke X FPC's extensions are needed to specify a file name
at run time, to check the existence of files and to access the
system date and time.  Identifiers from FPC~Pascal are prefixed
with \\{fpc\_} to help distinguish them from Pascal and \.{WEB}
identifiers and to avoid name clashes. Furthermore all FPC~Pascal
identifiers will appear together in the index.

\medskip
\item{(1)}\marke U The Unix file seperator is `\.{/}'
instead of `\.{:}'.
\medskip
\item{(1)}\marke u On exit, \namefpc\ passes its `history' to the
operating system.  This integer is zero when everything is fine,
one when something less serious like an overfull box was detected,
two when an error happened like an undefined control sequence, and
three when the program aborted because one of its tables overflowed
or because it couldn't find an input file while running in batch
mode.

\item{(2)} Valid input characters are the 94~visible ASCII characters
together with the three control characters horizontal tabulator,
form~feed, and space.

\item{(3)} Terminate last line on terminal. This is Unix, not DOS!

\item{(4)} Teach \TeX\ and user how to end the terminal input by Control-D.

\break
Like Dijkstra,
\.{http://www.cs.utexas.edu/users/EWD/videos/noorderlicht.mpg},
I dislike version numbers---I consider \namefpc\ finished.
I'd rather maintain invariants---not software.
\address
\fi
@z


% \TeX82 will emit an underfull box warning here, \namefpc\ won't.
\setbox0=\hbox to \hsize {\hfil\ \strut}
\noindent\box0\ \ \par
\bigskip
\fi

[2] Change the banner line
@x
known as `\TeX' [cf.~Stanford Computer Science report CS1027,
November 1984].

@d banner=='This is TeX, Version 3.141592653' {printed when \TeX\ starts}
@y
known as `\TeX' [cf.~Stanford Computer Science report CS1027,
November 1984].

Even though \namefpc\ does not differ from \TeX\ I proudly change
the banner! And take responsibility for any error.

@d banner=='This is TeX-FPC, 4th ed.'
@z

[4] program header
@x
@d mtype==t@&y@&p@&e {this is a \.{WEB} coding trick:}
@y

\marke P Pascal wants the identifiers of the standard text files
\\{input} and \\{output} in the parameter list of the program header.

@d term_in==i @& n @& p @& u @& t
@d term_out==o @& u @& t @& p @& u @& t
@d mtype==t@&y@&p@&e
@z

[4] program header
@x
program TEX; {all file names are defined dynamically}
@y
program TEX(@!term_in,@!term_out);
@z

[4] forward definition of signal catcher
@x
procedure initialize; {this procedure gets things started properly}
@y
procedure catch_signal(i: integer); interrupt@, forward;@t\2@>
procedure initialize; {this procedure gets things started properly}
@z

Since @x, @y, and @z only define a change block when they begin a
line, you deactivate a block by indenting it (shift right) and
activate it by unindenting it (shift left).  With vi set the cursor
to the @x line and type >} or <} to (un)indent a paragraph.

[7] shift left to turn debugging on, right to turn it off
	@x debug
	@d debug==@{ {change this to `$\\{debug}\equiv\null$' when debugging}
	@d gubed==@t@>@} {change this to `$\\{gubed}\equiv\null$' when debugging}
	@y
	@d debug=={change this to `$\\{debug}\equiv\.{@@\{}$' when not debugging}
	@d gubed=={change this to `$\\{gubed}\equiv\.{@@\}}$' when not debugging}
	@z

[7] shift left to turn stats on, right to turn them off.
@x stats
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
Turn off checking since the debugger might trigger a range
check when it accesses subfields of a memory word without knowing
what it is reading.
Overflow is checked if the result of an integer operation overflows
the range of 64bit |integer|.
FPC in default mode neither provides |goto| nor the I/O
procedures |get| and |put|, and 16-bit |integer|. The compiler
directive MODE ISO fixes all of it.

@^system dependencies@>
@^FPC Pascal@>
@z

[9] compiler directives, turn off I/O checking, continued
@x
@{@&$C-,A+,D-@} {no range check, catch arithmetic overflow, no debug overhead}
@!debug @{@&$C+,D+@}@+ gubed {but turn everything on when debugging}
@y
@{$MODE@,ISO@} {turn on mode ISO}
@{$Q+@} {turn on overflow checking}
@{$R+@} {turn on range checking}
@!debug
@{$Q-@}@,
@{$R-@}@+
gubed {turn off all checks when debugging}
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

@d othercases == @+ else  {default for cases not listed explicitly}
@z

The changes headed by trip need to be made for the trip test suite.
For trip activate all changeblocks with the first line @x trip.
	
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
@!pool_name='TeXformats/tex.pool'; { \marke U Unix filename. }
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

[23] we accept horizontal tab and form feed!
@x
right of these assignment statements to |chr(i)|.
@y
right of these assignment statements to |chr(i)|.

\marke u In Unix tab and form feed are valid characters.
The plain format categorizes the tab as a spacer and form feed
as an active character defined as \.{\\outer\\par}.
@z

[23] continued
@x
for i:=0 to @'37 do xchr[i]:=' ';
@y
for i:=0 to @'37 do xchr[i]:=' ';
xchr[@'11] := chr(@'11); {accept horizontal tab\marke u}
xchr[@'14] := chr(@'14); {accept form feed}
@z

[25] the type of text_files is text
@x
@!alpha_file=packed file of text_char; {files that contain textual data}
@y
@!alpha_file=t @& e @& x @& t; {\marke P the type of text files is |text|}
@z

[25] continued
@x
@!byte_file=packed file of eight_bits; {files that contain binary data}
@y
@!byte_file=packed file of eight_bits; {files that contain binary data}
@!untyped_file=file; {untyped files for buffered output}
@z

[27]
@x
\TeX's file-opening procedures return |false| if no file identified by
|name_of_file| could be opened.

@d reset_OK(#)==erstat(#)=0
@d rewrite_OK(#)==erstat(#)=0
@y
\marke X 
The procedure |fpc_assign| assigns an external file name to a file.
The function |fpc_io_result| returns a nonzero value if any
error occurred since the last invocation of |fpc_io_result|.
The runtime system halts the program when it experiences an
I/O error. Since \namefpc\ wants to survive while trying to open
a nonexistence file, it turns off I/O checking for the open procedures.

@^FPC Pascal@>
@^system dependencies@>

@d fpc_io_result==i @& o @& r @& e @& s @& u @& l @& t
@d fpc_assign==a @& s @& s @& i @& g @& n
@d reset_OK(#)==fpc_io_result=0
@d rewrite_OK(#)==fpc_io_result=0
@d clear_io_result==@+if fpc_io_result=0 then do_nothing
@z

[27] reset and rewrite for each of three file types

@x alpha_file
@p function a_open_in(var f:alpha_file):boolean;
  {open a text file for input}
begin reset(f,name_of_file,'/O'); a_open_in:=reset_OK(f);
@y
@p
@{@&$I-@} {turn of I/O checking}
@#
function a_open_in(var f:alpha_file):boolean;
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
begin rewrite(f,name_of_file,'/O'); b_open_out:=rewrite_OK(f);
@y
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
end;
@y
begin clear_io_result; fpc_assign(f,name_of_file); rewrite(f);
w_open_out:=rewrite_OK(f);
end;
@#
@{@&$I+@} {turn on I/O checking}
@z

[31] bypass eoln
@x
finer tuning is often possible at well-developed \PASCAL\ sites.
@y
finer tuning is often possible at well-developed \PASCAL\ sites.
@^|bypass eoln|@>

\marke P Standard Pascal never suppresses the first get, so |input_ln|
must not bypass the first character of the first line.  To maintain
this rule for subsequent lines, |input_ln| is changed to bypass the
end of line character at the end of line.
@z

[31] bypass eoln
@x
begin if bypass_eoln then if not eof(f) then get(f);
@y
begin
@z

[31] bypass eoln
@x
  last:=last_nonblank; input_ln:=true;
  end;
@y
  last:=last_nonblank; input_ln:=true;
  read_ln(f);
  end;
@z

[31] re-engineered input_ln
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

	\marke h
	Unlike \TeX82 \namefpc\ leaves trailing spaces in the input line.

	\marke N
	Whenever |input_ln| is to read the first line of a disk file,
	|bypass_eoln| is set to |false|, in all other cases it is set to
	|true|.  This causes |input_ln| to advance the file pointer.  For
	the first line, in ISO-Pascal and FPC-Pascal this is done by |reset()|
	-- on terminals and disk files alike.  But \TeX82 turns this off
	for the terminal, so the old |input_line| has to advance the file
	pointer if reading the first line from a terminal.  On return, the
	old |input_ln| leaves the file position at the end-of-line marker,
	which is to be bypassed on next invocation.

	The new |input_ln| bypasses the end-of-line marker allways at the
	end of line and never at the beginning of line. In other words
	|reset| establishes and |input_ln| maintains the invariant:

	\centerline {The file is positioned at the first character of the
	line or |eof|}

	\marke N
	`To hell with ``meaningful identifiers''!': The parameter |bypass_eoln|
	does not always cause |input_ln| to bypass an end-of-line marker.
	And the size of the buffer is not |buf_size| but |buf_size+1|. And
	the end-of-line marker is not a start-of-line marker!

	@p function input_ln(var f:alpha_file;@!bypass_eoln:boolean):boolean;
	  {inputs the next line or returns |false|}
	begin
	  {|f| is positioned at the first character of the line, or |eof(f)|}
	last:=first; {cf.\ Matthew 19\thinspace:\thinspace30}
	if eof(f) then input_ln:=false
	else  begin 
	  while not eoln(f) do
	    begin if last>=max_buf_stack then
	      begin max_buf_stack:=last+1;
	      if max_buf_stack=buf_size then begin
		read_ln(f); {complete the current line}
		@<Report overflow of the input buffer, and abort@>;
		end
	      end;
	      buffer[last]:=xord[f^]; get(f); incr(last)
	    end;
	  get(f); { advance to the first character of next line}
	  input_ln:=true
	  end 
	  {|f| is positioned at the first character of the next line, or |eof(f)|}
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

\marke P No need to declare standard input/output in standard Pascal.
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
In Unix, nothing needs to be done here.

@^FPC Pascal@>
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

[36] command line
@x
not be typed immediately after~`\.{**}'.)

@d loc==cur_input.loc_field {location of first unread character in |buffer|}

@y
not be typed immediately after~`\.{**}'.)

\marke X
An |@!fpc_string| is a |packed array[1..fpc_length] of
char| with varying length.
The function |@!fpc_length(s)| returns the length of the |fpc_string@,
s|.
The function |@!fpc_param_count| returns the number of
command line arguments less one.
The function |@!fpc_param_str(n)|
returns the n-th argument for |0 <= n <= fpc_param_count|.

\marke F This procedure puts the command line arguments separated
by spaces into |buffer|. Like |input_ln| it updates |last| so that
|buffer[first..last)| will contain the command line.

@^FPC Pascal@>
@^system dependencies@>

@d loc==cur_input.loc_field {location of first unread character in |buffer|}
@d fpc_string == s@& h@& o@& r@& t @& s @& t @& r @& i@& n @& g
@d fpc_length==l @& e @& n @& g @& t @& h
@d fpc_param_count==p @& a @& r @& a @& m @& c @& o @& u @& n @& t
@d fpc_param_str==p @& a @& r @& a @& m @&s @& t @& r

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
     if xord[arg[cc]] <> invalid_code then
        buffer[last] := xord[arg[cc]];
     incr(last); incr(cc)
    end;
  if (argc <= fpc_param_count) then begin
    buffer[last] := " "; incr(last) {insert a space between arguments}
    end
  end
end;
@z

[37] command line.
@x
It should be clear how to modify this routine to deal with command lines,
if the system permits them.
@^system dependencies@>

@p function init_terminal:boolean; {gets the terminal input started}
label exit;
begin t_open_in;
loop@+begin wake_up_terminal; write(term_out,'**'); update_terminal;
@y
\marke F The command line is treated as the first terminal line.

\marke u Tell user to end the terminal file by Control-D.

@p function init_terminal:boolean; {gets the terminal input started}
label exit;
begin t_open_in; input_command_ln;
loc := first;
if loc<last then
   begin init_terminal:=true; return; {first line is the command line}
   end;
loop@+begin write(term_out,'**');
@z

[37] chatty
@x chatty
    write(term_out,'! End of file on the terminal... why?');
@.End of file on the terminal@>
@y
@z

[37] hint Control-D
@x
  write_ln(term_out,'Please type the name of your input file.');
@y
  write_ln(term_out,'Please type the name of your input file or Control-D.');@/
@z

[51] leave tex.pool open
@x
@ @d bad_pool(#)==begin wake_up_terminal; write_ln(term_out,#);
  a_close(pool_file); get_strings_started:=false; return;
@y
@ @d bad_pool(#)==begin wake_up_terminal; write_ln(term_out,#);
  get_strings_started:=false; return;
@z

[51] print more sensible what you can't read
@x
else  bad_pool('! I can''t read TEX.POOL.')
@y
else  bad_pool('! I can''t read TeXformats/tex.pool.'){\marke u Unix file name}
@z

[53] TANGLE would'nt help. Don't guess but report what does not match.
@x
done: if a<>@$ then bad_pool('! TEX.POOL doesn''t match; TANGLE me again.');
@y
done: if a<>@$ then bad_pool
('! TeXformats/tex.pool doesn''t match. Not installed?'); {\marke u Unix file name}
@z

[79] start editor
@x
@!use_err_help:boolean; {should the |err_help| list be shown?}
@y
@^Editor@>
@!use_err_help:boolean; {should the |err_help| list be shown?}
@!want_edit: boolean; {start \.{vi}?}
@z

[80] initial value for edit arguments
@x
help_ptr:=0; use_err_help:=false;
@y
@^Editor@>
help_ptr:=0; use_err_help:=false;@/
want_edit := false; {\marke F don't start \.{ed}}
@z

[84] set edit_cmd
@x
  interaction:=scroll_mode; jump_out;
@y
  interaction:=scroll_mode; want_edit := true; jump_out;
@z

[86] extra space in log and missing last line terminator on terminal
@x
"Q":begin print_esc("batchmode"); decr(selector);
  end;
@y
"Q":print_esc("batchmode"); {\marke E don't turn off terminal now}
@z

[86] continued
@x
print("..."); print_ln; update_terminal; return;
@y
print("..."); print_ln; update_terminal;
if c="Q" then decr(selector);  return; { but now }
@z

[109] fpc_single for glue ratio.
@x
routines cited there must be modified to allow negative glue ratios.)
@y
routines cited there must be modified to allow negative glue ratios.)

\marke X In FPC~Pascal the type |fpc_single| seems appropiate.
@d fpc_single== s@&i@&n@&g@&l@&e
@z

@x
@!glue_ratio=real; {one-word representation of a glue expansion factor}
@y
@!glue_ratio=fpc_single; {one-word representation of a glue expansion
			 factor in FPC~Pascal}
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

[241]
@x
@p procedure fix_date_and_time;
begin sys_time:=12*60;
sys_day:=4; sys_month:=7; sys_year:=1776;  {self-evident truths}
time:=sys_time; {minutes since midnight}
day:=sys_day; {day of the month}
month:=sys_month; {month of the year}
year:=sys_year; {Anno Domini}
end;
@y
\marke X The functions |now|,  |decodedate|, and |decodetime| are provided
by the unit |sysutils|. The command line option \.{fpc~-Fasysutils~tex.p}
links that unit.
@^system dependencies@>
@^sysutils@>
@^FPC Pascal@>
When FPC is in ISO mode, it does not accept declaring a |unit| in the source
file.
@dfpc_now == now
@dfpc_decode_date == decodedate
@dfpc_decode_time == decodetime
@p procedure fix_date_and_time;
var yy,mm,dd: word;
    hh,ss,ms: word;
begin
fpc_decode_date(fpc_now,yy,mm,dd); {current date}
sys_day := dd; day:=sys_day;
sys_month := mm; month:=sys_month;
sys_year := yy; year := sys_year;@/
fpc_decode_time(fpc_now,hh,mm,ss,ms); {current time}
sys_time := hh*60+mm; time := sys_time; {minutes since midnight}
end;
@z

[360] Don't print empty lines
@x chatty
@ All of the easy branches of |get_next| have now been taken care of.
There is one more branch.
@y
@ All of the easy branches of |get_next| have now been taken care of.
There is one more branch.

\marke h \TeX82 ends the current line by calling |print_ln| even
if the line is empty.  This causes a spurious ugly empty line.
Calling |print_nl("")| is smarter.  It ends the current
line only if it is not empty.
@z

@x chatty
    if limit=start then {previous line was empty}
      print_nl("(Please type a command or say `\end')");
@.Please type...@>
    print_ln; first:=start;
@y
    if limit=-1 then {previous line was empty}
      print_nl("(Please type a command or say `\end')");
@.Please type...@>
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

\marke U In Unix strings are terminated by chr(0).

@d append_to_name(#)==begin c:=#; incr(k);
@z

[519] pack file name
@x
if k<=file_name_size then name_length:=k@+else name_length:=file_name_size;
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
end;
@y
if k<=file_name_size then name_length:=k@+else name_length:=file_name_size;
for k:=name_length+1 to file_name_size do name_of_file[k]:=chr(0);
end;
@z

[521] Unix file separator
@x
TEX_format_default:='TeXformats:plain.fmt';
@y
TEX_format_default:='TeXformats/plain.fmt';
 {``/'' is the Unix file name separator\marke U}
@z

[523] packed buffered name
@x
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
@y
@^FPC Pascal@>
for k:=name_length+1 to file_name_size do name_of_file[k]:=chr(0);
@z

[524 specify better, what you cannot read:
@x
  wterm_ln('I can''t find the PLAIN format file!');
@y
  wterm_ln('I can''t find TeXformats/plain.fmt!'); {\marke u Unix file name}
@z

[530] Control D will help
@x
print_nl("Please type another "); print(s);
@y
print_nl("Please type another "); print(s); print(" or Control-D");
@z

[537] Editor
@x
@ Let's turn now to the procedure that is used to initiate file reading
when an `\.{\\input}' command is being processed.
Beware: For historic reasons, this code foolishly conserves a tiny bit
of string pool space; but that can confuse the interactive `\.E' option.
@^system dependencies@>
@y
@ Let's turn now to the procedure that is used to initiate file reading
when an `\.{\\input}' command is being processed.
Beware: For historic reasons, this code foolishly conserves a tiny bit
of string pool space; but that can confuse the interactive `\.E' option.

\marke E In fact, it breaks the `\.E' option whenever the file to be
edited was opened after the log file.
In that case, the last string constructed is the name of the log file,
otherwise, the last string constructed is the name of the input file.
If the name of the input file is the last string constructed,
\TeX\ strips off area and extension to conserve string
pool space. The user is shown the base name of the file he wants
to edit to fix a bug.

Sadly, Knuth doesn't dare to fix this bug, which is known for at
least twelve years. Are we approaching the limits of ``Literate Programming''.
It looks beautiful but does it really help to cope with complexity?

@^Editor@>
@^Fix@>
@z

[537] never flush file name
@x
if name=str_ptr-1 then {conserve string pool space (but see note above)}
  begin flush_string; name:=cur_name;
  end;
@y
@z

[575] Don't check eof (fpc bug: eof off by one)
@x
if eof(tfm_file) then abort;
@y
@^FPC-EOF@>
@z

[597] buffered write
@x
output an array of words with one system call.
@y
output an array of words with one system call.
@^FPC-buffer@>

\marke P The procedure |fpc_blockwrite| takes a file, the first
byte in a buffer and the number of bytes to be written as parameters
and writes all bytes with one system call.  This in fact speeds up
\namefpc.

@d fpc_blockwrite == b @& l @& o @& c @& k @& w @& r @& i @& t @& e
@z

[597] use buffered i/o to speed up TeX
@x
var k:dvi_index;
begin for k:=a to b do write(dvi_file,dvi_buf[k]);
@y
begin fpc_blockwrite(dvi_file, dvi_buf[a], b-a+1);
@z

[816] save pointer to penalty_node
@x
same number of |mem|~words.
@^data structure assumptions@>
@y
same number of |mem|~words.
@^data structure assumptions@>
@^\TeX-Bug@>

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

	[1265] empty line after change of interaction mode
@x chatty
begin print_ln;
@y
begin print_nl(""); { print new line only if current line not empty \marke h}
@z

[1327] eof is broken
@x
if (x<>69069)or eof(fmt_file) then goto bad_fmt
@y
if (x<>69069) then goto bad_fmt
@^FPC-EOF@>
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

\marke X The procedure |@!fpc_halt| terminates the program and passes its
parameter to the shell.

@^system dependencies@>
@^FPC Pascal@>
@^Unix@>

@d fpc_halt == h@&a@&l@&t
@z

[1332] simulate tex, not virtex
	@x
	start_of_TEX: @<Initialize the output routines@>;
	@y
	start_of_TEX:
	@<Preload the default format file@>;
	@<Initialize the output routines@>;
	@z

[1332]
@x
final_end: ready_already:=0;
@y
final_end:
if want_edit then exec_editor; {user typed `\.{E}' \marke F}
fpc_halt(history);
  {pass |history| as the exit value to the system\marke u}
@z

[1333] print last end-of-line marker if needed
@x
If |final_cleanup| is bypassed, this program doesn't bother to close
the input files that may still be open.
@y
If |final_cleanup| is bypassed, this program doesn't bother to close
the input files that may still be open.
\marke u
Terminate the last line on the terminal.
@z

[1333] print last end-of-line marker if needed
@x
    slow_print(log_name); print_char(".");
@y
    slow_print(log_name); print_char("."); print_ln;
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
  read(term_in,m);
@y
  if eof(term_in) then return; {\marke P never |read| at |eof|}
  read(term_in,m);
@z

[1338] return if eof
@x
  else  begin read(term_in,n);
@y
  else  begin if eof(term_in) then return; {\marke P never |read| at |eof|}
  read(term_in,n);
@z

[1339] return if eof
@x
13: begin read(term_in,l); print_cmd_chr(n,l);
@y
13: begin if eof(term_in) then return; {\marke P never |read| at |eof| }
read(term_in,l); print_cmd_chr(n,l);
@z

[1379 and modules added for TeX-FPC]
@x
itself will get a new section number.
@^system dependencies@>
@y
itself will get a new section number.

@ \marke F If the user typed \.{E} to edit a file after confronted
with an error message, \TeX\ will clean up and then call |edit|
as its last feat.
@^Editor@>

This procedure must not print error messages, since all files are already
closed.

Beware of using any \.{WEB} strings like \.{"vi +"} since that
would change the string pool file and you'll need to rebuild all
format files with the new string pool in case you disagree which
editor is the system editor.

An overflow of |name_of_file| cannot happen, since |name_of_file|
kept the file name while the file was being opened.
/marke F
The procedure @!|exec_edit| starts \.{vi} passing line number and
file name.

\marke X
This procedure executes the Unix system editor, which is \.{ed} of course.
@^Editor@>
In case you disagree, modify all four definitions of |ed|, |de|, |vi|, |iv|
to select code that executes \.{vi} instead. This not just changes
the name of the system editor, but it adds one argument that contains the
line number to the argument vector.
The argument vector for the system editor has two entries:

\indent \.{ed file-name}

\noindent And the argument vector for the west coast editor three:

\indent\.{vi +line file-name}

The system call @!|fpc_fp_exec_vp| expects two parameters, namely
the name of the editor to be loaded and the argument vector, an
|array| of the arguments to be passed to the editor.  Unix replaces
the code of \TeX\ by the code of the editor without forking a new
process.  On success this procedure does not return.

The type @!|fpc_pchar| is a pointer to a character. An argument is
a null-terminated |packed array of char|. The \.{@@}-operator applied
to an argument evaluates to the address of the first entry, i.e
a pointer to a character.

The function |fpc_fp_exec_vp| wants the argument vector to be passed
as a pointer to a pointer to a character.  An |array|~parameter is
always passed as the address of its first entry. Therefore  we must
not apply the \.{@@}-operator to the parameters of |fpc_fp_exec_vp|.

Note that the name of the binary is passed twice, namely as the
first parameter and as the first entry of the second argument.
|fpc_fp_exec_vp| searches for the binary in the \.{PATH}.  And then
it seems to replace |argv[0]| by the full name of the editor.  At
least this is what \.{ps -f} shows and might be a bug.

The procedure |fpc_fp_exec_vp| is provided by the |unit@,unix|.
@^|unit unix|@> The command line option \.{-Faunix} links to that
unit. @^unix@>

@^FPC Pascal@>
@^system dependencies@>

@d fpc_fp_exec_vp == fp_exec_vp
@d fpc_pchar == pchar
@d edit_file == input_stack[base_ptr].name_field
@#
@d vi== {change this to `$\\{vi}\equiv\null$' when you think \.{vi}
is the system editor}
@d iv== {change this to `$\\{iv}\equiv\null$' when you think \.{vi}
is the sytem editor}
@f vi == begin
@f iv == end
@d ed==@{ {change this to `$\\{ed}\equiv\.{@@\{}$' when you think \.{vi}
is the system editor}
@d de==@} {change this to `$\\{de}\equiv\.{@@\}}$' when you think \.{vi}
is the system editor}
@f ed == begin
@f de == end

@<Last-minute...@>=
procedure exec_editor;
const arg_size = 100; {maximal size of each of the arguments}
      vi editor = 'vi'; {name of the binary to be started}
      iv
      @#
      ed editor = 'ed'; {name of the binary to be started}
      de
      @#
      editor_length = 2; {length of the name}
var i, l: integer; {index into args}
    j: pool_pointer; {index into |str_pool|}
    s: str_number; {string to hold line number}
    sel: integer; {save selector}
    editor_arg, line_arg, file_arg : array[1..arg_size] of char; {arguments}
    argv: array [0..3] of fpc_pchar; {vector of arguments}
begin
  l := editor_length;
  for j := 1 to l do editor_arg[j] := editor[j];
  editor_arg[l+1] := chr(0);@/
  sel := selector;
  selector := new_string;
  print_int(line);
  selector := sel;
  s := make_string;
  line_arg[1] := '+';
  j := str_start[s];
  l := length(s)+1;
  for i := 2 to l do begin line_arg[i] := xchr[str_pool[j]]; incr(j) end;
  line_arg[l+1] := chr(0);
  @#
  j := str_start[edit_file];
  l := length(edit_file);
  if l+1 > arg_size then begin
    write_ln('File name longer than 100 bytes! Nice try!');
    halt(100);
    end;
  for i := 1 to l do
  begin file_arg[i] := xchr[str_pool[j]]; incr(j)
  end;
  file_arg[l+1] := chr(0);
  @#
  argv[0] := @@editor_arg;
  vi
  argv[1] := @@line_arg;
  argv[2] := @@file_arg;
  argv[3] := nil;
  iv
  @#
  ed
  argv[1] := @@file_arg;
  argv[2] := nil;
  de
  @#
  fpc_fp_exec_vp(editor, argv);
  write_ln('Sorry, executing the editor failed.');
end;

@ \marke X
A signal handler is a procedure that takes one |integer| parameter.
The procedure |fpc_fp_signal| takes two parameter, an integer and
a signal handler. The integer is the number of the signal. When
the program receives a signal with the designated number, the signal
handler gets invoked.

The integer |fpc_SIGINT| is the number of the interrupt signal.
The system interrupts the program, when the user types \.{\^C}.

If |fpc_fp_get_errno| returns an integer that is not zero, an error
occurred.

The identifier |fpc_signal_handler| denotes the |type| of a
pointer to a signal handler. Since this is foreign to Pascal,
we use the type cast to |fpc_signal_handler| as a kludge.

The functions related to installing a signal handler are provided
by the |unit@,baseunix|. @^|baseunix|@>
The command line option \.{-Fabaseunix} links to that unit.
@^FPC Pascal@>
@^system dependencies@>

@d fpc_signal_handler == signal@&ha@&ndler
@d fpc_fp_signal == fp_signal
@d fpc_SIGINT == SIGINT
@d fpc_fp_get_errno ==f@&p@&g@&e@&t@&e@&r@&r@&n@&o

@<Set initial values ...@>+=

fpc_fp_signal(fpc_SIGINT, fpc_signal_handler(catch_signal));
if fpc_fp_get_errno <> 0 then
   write_ln('Could not install signal handler:', fpc_fp_get_errno);

@ \marke X The signal handler has the modifier |interrupt|.  Modifiers
are an extension of FPC Pascal. This one makes the compiler generate
code suitable for a signal handler, which must not return to the
caller, i.e. the system, but to the instruction where the program
was interrupted.

@^FPC Pascal@>
@^dirty \PASCAL@>
@^system dependencies@>

@<Error handling ...@>+=
procedure catch_signal; interrupt;
begin
  interrupt := i;
end;
@z
