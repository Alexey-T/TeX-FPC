% This is a change file of Metafont, Wolfgang Helbig, Nov. 2007 - Apr.2021
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
@x
\def\gglob{20, 26} % this should be the next two sections of "<Global...>"
@y
\def\gglob{20, 26} % this should be the next two sections of "<Global...>"
\input webmac-fpc
\emergencystretch 0.5in % avoid overfull boxes

\let\maybe=\iffalse % print changed modules only.

\def\name{\MF}

\N0\*.  \[0] About \namefpc.

This is an adaption of Donald~E. Knuth's \MF, version 2.71828182
from January 2021, to Free~Pascal (FPC)  and Unix.

The features added include treating the command line as the first
input line and invoking a system editor, in this case \.{vi}, to
let the user correct the input file.
On exit, \namefpc\ passes its `history' to the operating system.

The changes needed to make \namefpc\ compile and run to my satisfaction
are very similar to those applied to  \TeXfpc. Look in tex.tex for
a thorough description of adaptions to Unix, FPC, and my taste.

\hint

Comments and questions are welcome!

\bigskip
\address
\fi
@z

[2] Change the banner line
@x
@d banner=='This is METAFONT, Version 2.71828182' {printed when \MF\ starts}
@y
@d banner=='This is METAFONT-FPC, 4th ed.' {printed when \MF\ starts}
@z

[4] terminal output and input
@x
@^system dependencies@>

@d mtype==t@&y@&p@&e {this is a \.{WEB} coding trick:}
@y
@^system dependencies@>

@d term_in==i@&n@&p@&u@&t
@d term_out==o@&u@&t@&p@&u@&t
@d mtype==t@&y@&p@&e {this is a \.{WEB} coding trick:}
@z

[4] terminal output and input
@x
program MF; {all file names are defined dynamically}
@y
program MF(@!term_in,@!term_out);
{all other file names are defined dynamically}
@z

[4] forward declaration for signal handler
@x
procedure initialize; {this procedure gets things started properly}
@y
procedure catch_signal(i: integer); interrupt; forward;
procedure initialize; {this procedure gets things started properly}
@z

Since @x, @y, and @z only define a change block when they begin a
line, you deactivate a block by indenting it (shift right) and 
activate it by unindenting it (shift left).  With vi set the   
cursor to the @x line and enter >} or <} to (un)indent a paragraph.

[7] shift left to turn debugging on, right to turn it off
	@x debug
	@d debug==@{ {change this to `$\\{debug}\equiv\null$' when debugging}
	@d gubed==@t@>@} {change this to `$\\{gubed}\equiv\null$' when debugging}
	@y
	@d debug== {change this to `$\\{debug}\equiv\.{@@\{}$' when not debugging}
	@d gubed== {change this to `$\\{gubed}\equiv\.{@@\}}$' when not debugging}
	@z

[7] shift left to turn on statistics, shift rigth to turn off statistics
@x stat
@d stat==@{ {change this to `$\\{stat}\equiv\null$' when gathering
  usage statistics}
@d tats==@t@>@} {change this to `$\\{tats}\equiv\null$' when gathering
  usage statistics}
@y
@d stat== {change this to `$\\{stat}\equiv\.{@@\{}$' to turn off statistics}
@d tats== {change this to `$\\{tats}\equiv\.{@@\}}$' to turn off statistics}
@z

	[8] shift left to build MF and right it to build INIMF.
	@x inimf
	@d init== {change this to `$\\{init}\equiv\.{@@\{}$' in the production version}
	@d tini== {change this to `$\\{tini}\equiv\.{@@\}}$' in the production version}
	@y
	@d init==@{
	@d tini==@}
	@z

[9] compiler directives, turn off I/O checking.
@x
@{@&$C-,A+,D-@} {no range check, catch arithmetic overflow, no debug overhead}
@!debug @{@&$C+,D+@}@+ gubed {but turn everything on when debugging}
@y
@{$MODE@,ISO@} {turn on mode ISO}
@{$Q+@} {turn on overflow checking}
@{$R+@} {turn on range checking}
@!debug @{Q+@}@,@{R+@}@+ gubed {turn checks off when debugging}
@z

[10] default case branch
@x
@d othercases == others: {default for cases not listed explicitly}
@y
@d othercases == @+ else {default for cases not listed explicitly}
@z

Shift left all `trap' blocks to prepare for TRAP.
Shift right all `part' blocks to prepare for TRAP.
[11]
@x part
@!mem_max=30000; {greatest index in \MF's internal |mem| array;
@y
@!mem_max=35000; {increased for ibycus4,
 greatest index in \MF's internal |mem| array;
@z

[11]
@x part
@!max_strings=2000; {maximum number of strings; must not exceed |max_halfword|}
@y
@!max_strings=6000; {maximum number of strings; increased for ibycus4}
@z

@x part
@!pool_size=32000; {maximum number of characters in strings, including all
@y
@!pool_size=60000; {increased for ibycus4,
  maximum number of characters in strings, including all
@z

[11]
	@x trap
	@!mem_max=30000; {greatest index in \MF's internal |mem| array;
	@y
	@!mem_max=3000; {greatest index in \MF's internal |mem| array;
	@z

[11]
	@x trap
	@!error_line=72; {width of context lines on terminal error messages}
	@!half_error_line=42; {width of first lines of contexts in terminal
	  error messages; should be between 30 and |error_line-15|}
	@!max_print_line=79; {width of longest text lines output; should be at least 60}
	@!screen_width=768; {number of pixels in each row of screen display}
	@!screen_depth=1024; {number of pixels in each column of screen display}
	@y
	@!error_line=64; {width of context lines on terminal error messages}
	@!half_error_line=32; {width of first lines of contexts in terminal
	  error messages; should be between 30 and |error_line-15|}
	@!max_print_line=72; {width of longest text lines output; should be at least 60}
	@!screen_width=100; {number of pixels in each row of screen display}
	@!screen_depth=200; {number of pixels in each column of screen display}
	@z

[11]
	@x trap
	@!gf_buf_size=800; {size of the output buffer, must be a multiple of 8}
	@y
	@!gf_buf_size=8; {size of the output buffer, must be a multiple of 8}
	@z

[11] location of pool file
@x
@!pool_name='MFbases:MF.POOL                         ';
@y
@!pool_name='MFbases/mf.pool';
@z


[12]
@x part
@d mem_top==30000 {largest index in the |mem| array dumped by \.{INIMF};
@y
@d mem_top==35000 {largest index in the |mem| array dumped by \.{INIMF};
@z

[12]
	@x trap
	@d mem_top==30000 {largest index in the |mem| array dumped by \.{INIMF};
	@y
	@d mem_top==3000 {largest index in the |mem| array dumped by \.{INIMF};
	@z

[12] Silvio levy' greek fonts need more opened input files.
@x part
@d max_in_open=6 {maximum number of input files and error insertions that
@y
@d max_in_open=10 {maximum number of input files and error insertions that
@z

[22] accept tab and formfeed
@x
for i:=0 to @'37 do xchr[i]:=' ';
@y
for i:=0 to @'37 do xchr[i]:=' ';
xchr[@'11] := chr(@'11); {accept horizontal tab}
xchr[@'14] := chr(@'14); {accept form feed}
@z

[24] the type of text_files is text in ISO Pascal
@x
@!eight_bits=0..255; {unsigned one-byte quantity}
@!alpha_file=packed file of text_char; {files that contain textual data}
@y
@!eight_bits=0..255; {unsigned one-byte quantity}
@!alpha_file=t@&e@&x@&t; {coding trick is needed since |text| is a macro}
@z

[26] dynamic io
@x
@d reset_OK(#)==erstat(#)=0
@d rewrite_OK(#)==erstat(#)=0
@y
@d fpc_io_result==i@&o@&r@&e@&s@&u@&l@&t
@d fpc_assign==a@&s@&s@&i@&g@&n
@d reset_OK(#)==fpc_io_result=0
@d rewrite_OK(#)==fpc_io_result=0
@d clear_io_result==@+if fpc_io_result=0 then do_nothing
@z

[26] opening for in- and output for all three file types
alpha in
@x
@p function a_open_in(var @!f:alpha_file):boolean;
  {open a text file for input}
begin reset(f,name_of_file,'/O'); a_open_in:=reset_OK(f);
@y
@p @{@&$I-@} {turn off I/O checking}
@#
function a_open_in(var @!f:alpha_file):boolean;
  {open a text file for input}
begin clear_io_result; fpc_assign(f,name_of_file);reset(f);
a_open_in:=reset_OK(f);
@z

[26]
alpha out
@x
begin rewrite(f,name_of_file,'/O'); a_open_out:=rewrite_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); rewrite(f);
a_open_out:=rewrite_OK(f);
@z

[26] byte out
@x
begin rewrite(f,name_of_file,'/O'); b_open_out:=rewrite_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); rewrite(f);
b_open_out:=rewrite_OK(f);
@z

[26] word in
@x
begin reset(f,name_of_file,'/O'); w_open_in:=reset_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); reset(f);
w_open_in:=reset_OK(f);
@z

[26] word out
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

[30] bypass_eoln
@x
begin if bypass_eoln then if not eof(f) then get(f);
@y
begin
@z

[30] bypass_eoln
@x
  last:=last_nonblank; input_ln:=true;
  end;
@y
  last:=last_nonblank; input_ln:=true;
  read_ln(f);
  end;
@z

[31] term_in and term_out are the standard pascal files
@x
is considered an output file the file variable is |term_out|.
@^system dependencies@>

@<Glob...@>=
@!term_in:alpha_file; {the terminal as an input file}
@!term_out:alpha_file; {the terminal as an output file}
@y
is considered an output file the file variable is |term_out|.
The file |term_in| is declared as \\{input} and |term_out| as
\\{output} in the program header.
@^system dependencies@>
@z

[32]
@x
@d t_open_in==reset(term_in,'TTY:','/O/I') {open the terminal for text input}
@d t_open_out==rewrite(term_out,'TTY:','/O')
 {open the terminal for text output}
@y
@d t_open_in==do_nothing {open the terminal for text input}
@d t_open_out==do_nothing {open the terminal for text output}
@z

[33]
@x
@d update_terminal == break(term_out) {empty the terminal output buffer}
@d clear_terminal == break_in(term_in,true) {clear the terminal input buffer}
@y
@d update_terminal == do_nothing {empty the terminal output buffer}
@d clear_terminal == do_nothing {clear the terminal input buffer}
@z

[35] command line
@x
@d loc==cur_input.loc_field {location of first unread character in |buffer|}
@y
@d loc==cur_input.loc_field {location of first unread character in |buffer|}
@d fpc_string == s@&h@&o@&r@&t@&s@&t@&r@&i@&n@&g
@d fpc_length==l @& e @& n @& g @& t @& h
@d fpc_param_count==p @& a @& r @& a @& m @& c @& o @& u @& n @& t
@d fpc_param_str==p @& a @& r @& a @& m @&s @& t @& r
  {FPC function returning the length of a |fpc_string|}
@d fpc_int_to_str == i @& n @& t @& t @& o @& s @& t @& r

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
    buffer[last] := " "; incr(last);
    end;
  end;
end;
@z

[36] command line
@x
@p function init_terminal:boolean; {gets the terminal input started}
label exit;
begin t_open_in;
loop@+begin wake_up_terminal; write(term_out,'**'); update_terminal;
@y
@p function init_terminal:boolean; {gets the terminal input started}
label exit;
begin t_open_in; input_command_ln;
loc := first;
if loc<last then
   begin init_terminal:=true; return; {first line is the command line}
   end;
loop@+begin wake_up_terminal; write(term_out,'**'); update_terminal;
@z

[36] For Unix, End of file on the terminal is not remarkable
@x 
    write(term_out,'! End of file on the terminal... why?');
@.End of file on the terminal@>
@y
@z

[36] control D
@x
  write_ln(term_out,'Please type the name of your input file.');
@y 
  write_ln(term_out,'Please type the name of your input file or Control-D.');
@z

[51] leave pool file open
@x
@ @d bad_pool(#)==begin wake_up_terminal; write_ln(term_out,#);
  a_close(pool_file); get_strings_started:=false; return;
  end
@y
@ @d bad_pool(#)==begin wake_up_terminal; write_ln(term_out,#);
  get_strings_started:=false; return;
  end
@z

[51] lower case name of mf.pool
@x
else  bad_pool('! I can''t read MF.POOL.')
@y
else  bad_pool('! I can''t read MFbases/mf.pool.')
@z

[53] tangle would'nt help, installation would
@x
done: if a<>@$ then bad_pool('! MF.POOL doesn''t match; TANGLE me again.');
@y
done: if a<>@$ then bad_pool('! MFbases/mf.pool doesn''t match. Not installed?');
@z


[74] start editor
@x
@!use_err_help:boolean; {should the |err_help| string be shown?}
@y
@!use_err_help:boolean; {should the |err_help| string be shown?}
@!start_edit: boolean; {start \.{vi}?}
@z

[75] initial value for edit argument
@x
help_ptr:=0; use_err_help:=false; err_help:=0;
@y
help_ptr:=0; use_err_help:=false; err_help:=0;
start_edit := false; { don't start \.{vi}}
@z

[79] set edit_cmd
@x
  interaction:=scroll_mode; jump_out;
  end;
@y
  start_edit := true;
  interaction:=scroll_mode; jump_out;
  end;
@z

[81] extra space on log file and terminate last terminal line
@x
"Q":begin print("batchmode"); decr(selector);
  end;
@y
"Q":begin print("batchmode");
  end;
@z

[81] continued
@x
print("..."); print_ln; update_terminal; return;
@y
print("..."); print_ln; update_terminal;
if c="Q" then decr(selector); return;
@z

[194] date and time
@x
@p procedure fix_date_and_time;
begin sys_time:=12*60;
sys_day:=4; sys_month:=7; sys_year:=1776;  {self-evident truths}
internal[time]:=sys_time*unity; {minutes since midnight}
internal[day]:=sys_day*unity; {day of the month}
internal[month]:=sys_month*unity; {month of the year}
internal[year]:=sys_year*unity; {Anno Domini}
end;
@y
@p procedure fix_date_and_time;
var yy,mm,dd: word;
    hh,ss,ms: word;
begin
decodedate(now,yy,mm,dd); {current date}
sys_day := dd;
sys_month := mm;
sys_year := yy;
internal[day] := sys_day*unity;
internal[month] := sys_month*unity;
internal[year] := sys_year*unity;@/
decodetime(now,hh,mm,ss,ms); {current time}
sys_time := hh*60+mm; {minutes since midnight}
internal[time] := sys_time*unity; {minutes since midnight}
end;
@z

[199] character class for tab and lf
@x
for k:=127 to 255 do char_class[k]:=invalid_class;
@y
for k:=127 to 255 do char_class[k]:=invalid_class;
char_class[@'11] := space_class;
char_class[@'14] := space_class;
@z

[326]
@x
no rows), we have |n_rover(h)=h|, and |n_pos(h)| is irrelevant.
@y
no rows), we have |n_rover(h)=h|, and |n_pos(h)| is irrelevant.

The definition of |valid_range| was changed because the Free Pascal
Compiler cannot compile expressions like |abs(a+b-4096)| when |a|
and |b| are |half_words|. It does compile however |abs(int(a+b) -
int(4096))|, and |abs(int(a+b-4096))| will throw an overflow exception.
@z

[326]
@x
@d valid_range(#)==(abs(#-4096)<4096) {is |#| strictly between 0 and 8192?}
@y
@d valid_range(#)==(abs(int(#)-int(4096))<4096) {is |#| strictly between 0 and 8192?}
@z

	[536] undo Knuth's change from mf-2008 to mf-2012, to explain the
	diffs of pointer values in the trap.logs.
	@x
	done1: if (link(p)<>null) then free_node(link(p),knot_node_size);
	link(p):=s; beta:=-y_coord(h);
	@y
	done1: link(p):=s; beta:=-y_coord(h);
	@z

[564]
	@x trap
	begin init_screen:=false;
	@y
	begin init_screen:=true;
	@z

[679] spurious empty line on terminal
@x chatty
    print_ln; first:=start;
    prompt_input("*"); {input on-line into |buffer|}
@y
@.Please type...@>
    print_nl("");
    first:=start; {avoid empty lines on terminal and log file}
    prompt_input("*"); {input on-line into |buffer|}
@z

[769] Path separator in Unix
@x
@d MF_area=="MFinputs:"
@y
@d MF_area=="MFinputs/"
@z

[771]
@x
else  begin if (c=">")or(c=":") then
@y
else  begin if c="/" then
@z

[774]
@x
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
@y
for k:=name_length+1 to file_name_size do name_of_file[k]:=chr(0);
@z

[776]
@x
MF_base_default:='MFbases:plain.base';
@y
MF_base_default:='MFbases/plain.base';
@z

[778]
@x
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
@y
for k:=name_length+1 to file_name_size do name_of_file[k]:=chr(0);
@z

[779] report the file you can't read
@x
  wterm_ln('I can''t find the PLAIN base file!');
@y
  wterm_ln('I can''t find MFbases/plain.base!');
@z

[786]
@x spaeter!
print_nl("Please type another "); print(s);
@y
print_nl("Please type another "); print(s); print(" or Control-D");
@z

[793] name might be needed to be passed to vi
@x
if name=str_ptr-1 then {conserve string pool space (but see note above)}
  begin flush_string(name); name:=cur_name;
  end;
@y
@^Editor@>
@z


	[1023] avoid blank line on terminal after mode command
	@x chatty
	mode_command: begin print_ln; interaction:=cur_mod;
	@y
	mode_command: begin print_nl(""); interaction:=cur_mod;
	@z

[1154] blockwrite for gf_buf
@x
output an array of words with one system call.
@y
output an array of words with one system call.

@d fpc_blockwrite == b @& l @& o @& c @& k @& w @& r @& i @& t @& e
@z

@x
begin for k:=a to b do write(gf_file,gf_buf[k]);
@y
begin fpc_blockwrite(gf_file,gf_buf[a],b-a+1);
@z

[1199]
@x
undump_int(x);@+if (x<>69069)or eof(base_file) then goto off_base
@y
undump_int(x);@+if (x<>69069) then goto off_base
@z

[1204]
@x
@p begin @!{|start_here|}
@y
@d fpc_halt == h@&a@&l@&t

@p begin @!{|start_here|}
@z

[1204] start editor and pass history
@x
final_end: ready_already:=0;
@y
final_end:
if start_edit then exec_editor; {user typed `\.{E}'}
fpc_halt(history);
  {pass |history| as the exit value to the system}
@z

[1205] terminate last line
@x
    slow_print(log_name); print_char(".");
@y
    slow_print(log_name); print_char("."); print_ln;
@z

[1212] return if eof 
@x
  read(term_in,m);
@y
  if eof(term_in) then return;
  {don't try to read past end of file}
  read(term_in,m);
@z

[1212] return if eof
@x
  else  begin read(term_in,n);
@y
  else  begin if eof(term_in) then return;
  {don't try to read past end of file}
  read(term_in,n);
@z

[1213] return eof
@x
13: begin read(term_in,l); print_cmd_mod(n,l);
@y
13: begin if eof(term_in) then return;
  {don't try to read past end of file}
read(term_in,l); print_cmd_mod(n,l);
@z

[1214 and modules added for METAFONT-FPC]
@x
itself will get a new section number.
@^system dependencies@>
@y
itself will get a new section number.
@^system dependencies@>
@^fpc Pascal@>

@d edit_file == input_stack[file_ptr].name_field
@d fpc_fp_exec_vp == fp_exec_vp
@d fpc_pchar == pchar
@d vi==@{ {change this to `$\\{vi}\equiv\null$' when you think \.{vi}
is the system editor}
@d iv==@t@>@} {change this to `$\\{iv}\equiv\null$' when you think \.{vi}
is the sytem editor}
@f vi == begin
@f iv == end
@d ed== {change this to `$\\{ed}\equiv\.{@@\{}$' when you think \.{vi}
is the system editor}
@d de== {change this to `$\\{de}\equiv\.{@@\}}$' when you think \.{vi}
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
    sel: integer; { save selector }
    editor_arg, line_arg, file_arg : array[1..arg_size] of char; { arguments }
    argv: array [0..3] of fpc_pchar; { vector of arguments }
begin
  l := editor_length;
  for j := 1 to l do editor_arg := editor[j];
  editor_arg[l+1] := chr(0);

  sel := selector;
  selector := new_string;
  print_int(line);
  s := make_string;
  @#
  vi
  line_arg[1] := '+';
  j := str_start[s];
  l := length(s)+1;
  for i := 2 to l do begin line_arg[i] := xchr[str_pool[j]]; incr(j) end;
  line_arg := chr(0);
  iv
  @#
  selector := sel;
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
@
A signal handler is a procedure that takes one |integer| parameter.
The procedure |fpc_fp_signal| takes two parameter, an integer and
a signal handler. The integer is the number of the signal. Whenever
the program receives a signal with the designated number, the signal handler
gets invoked.

The integer |SIGINT| is the number of the interrupt signal.  The
system sends an interrupt signal to the program, whenever the user
types \.{\^C}.

The function |fpc_fp_get_errno| returns an integer that is not zero,
whenever something went wrong.

The identifier |fpc_signal_handler| denotes the |type| of a
pointer to a signal handler. Since this is foreign to ISO~Pascal,
we use the type cast to |fpc_signal_handler| as a kludge.

@^FPC Pascal@>
@^system dependencies@>

@d fpc_signal_handler == s@&i@&g@&n@&a@&l@&h@&a@&n@&d@&l@&e@&r
@d fpc_fp_signal == f@&p@&s@&i@&g@&n@&a@&l
@d fpc_fp_get_errno ==f@&p@&g@&e@&t@&e@&r@&r@&n@&o

@<Set initial values ...@>+=

fpc_fp_signal(SIGINT, fpc_signal_handler(catch_signal));
if fpc_fp_get_errno <> 0 then
   write_ln('Could not install signal handler:', fpc_fp_get_errno);

@ The signal handler has the so called modifier |interrupt|.
Modifiers are an extension of FPC Pascal. This one makes the compiler
generate the code suitable for a signal handler, which must not
return to the caller but to the instruction where the program was
interrupted.

@^FPC Pascal@>
@^system dependencies@>

@<Error handling ...@>+=
procedure catch_signal; interrupt;
begin
  interrupt := i;
end;
@z
