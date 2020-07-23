% This is a change file of Metafont for FPC, Wolfgang Helbig, Nov. 2007
[0] to print changed sections only
@x
\def\gglob{20, 26} % this should be the next two sections of "<Global...>"
@y
\def\gglob{20, 26} % this should be the next two sections of "<Global...>"
\input webmac-fpc
\emergencystretch 0.5in % avoid overfull boxes

\let\maybe=\iffalse % print changed modules only.

\def\name{\MF}

\N0\*.  \[0] About \namefpc.

This is an adaption of Donald~E. Knuth's \MF, version 2.7182815
from January 2014, to Unix. It is based on GNU~Pascal, version 2.1.

The features added include treating the command line as the first
input line and invoking a system editor, in this case \.{vi}, to
let the user correct the input file.
On exit, \namefpc\ passes its `history' to the operating system.

\hint

Comments and questions are welcome!

\bigskip
\address
\fi
@z

[2] Change the banner line
@x
@d banner=='This is METAFONT, Version 2.7182818' {printed when \MF\ starts}
@y
@d banner=='This is METAFONT-FPC' {printed when \MF\ starts}
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

Since @x, @y, and @z only define a change block when they begin a
line, you deactivate a block by indenting it (shift right) and 
activate it by unindenting it (shift left).  With vi set the   
cursor to the @x line and enter >} or <} to (un)indent a paragraph.

[7] shift left to turn debugging on, right to turn it off
@x
@d debug==@{ {change this to `$\\{debug}\equiv\null$' when debugging}
@d gubed==@t@>@} {change this to `$\\{gubed}\equiv\null$' when debugging}
@y
@d debug== {change this to `$\\{debug}\equiv\.{@@\{}$' when not debugging}
@d gubed== {change this to `$\\{gubed}\equiv\.{@@\}}$' when not debugging}
@z

[7] shift left to turn on statistics, shift rigth to turn off statistics
@x
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
@{@&$I-@} {no I/O checking}
@{@&$M@&O@&D@&E I@&S@&O@}
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
@x
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
begin reset(f,name_of_file,'/O'); a_open_in:=reset_OK(f);
@y
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
@y
begin clear_io_result; fpc_assign(f,name_of_file); rewrite(f);
w_open_out:=rewrite_OK(f);
@z

[30] eoln handling
@x
@p function input_ln(var @!f:alpha_file;@!bypass_eoln:boolean):boolean;
  {inputs the next line or returns |false|}
var @!last_nonblank:0..buf_size; {|last| with trailing blanks removed}
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
@p function input_ln(var f:alpha_file;@!bypass_eoln:boolean):boolean;
  {inputs the next line or returns |false|}
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
    buffer[last]:=xord[f^]; get(f); incr(last);
    end;
  get(f); {Advance |f| to the first character of the next line}
  input_ln:=true;
  end;
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

@x
  begin write_ln(term_out,'Buffer size exceeded!'); goto final_end;
@y
  begin write_ln(term_out,'Buffer size exceeded!'); fpc_halt(3);
@z

[35] command line
@x
@d loc==cur_input.loc_field {location of first unread character in |buffer|}
@y
@d loc==cur_input.loc_field {location of first unread character in |buffer|}
@d fpc_string == r@&a@&w@&b@&y@&t@&e@&s@&t@&r@&i@&n@&g
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
loc := first; {trim leading spaces}
while buffer[loc]=" " do incr(loc);
init_terminal:=true;
exit: end;
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
@d valid_range(#)==(abs(#-4096)<4096) {is |#| strictly between 0 and 8192?}
@y
@d valid_range(#)==(abs(int(#-4096))<4096) {is |#| strictly between 0 and 8192?}
@z
[564]
	@x trap
	begin init_screen:=false;
	@y
	begin init_screen:=true;
	@z

[679] spurious empty line on terminal
@x
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
@d append_to_name(#)==begin c:=#; incr(k);
@y
@d fpc_set_length==s@&e@&t@&l@&e@&n@&g@&t@&h
@d append_to_name(#)==begin c:=#; incr(k);
@z

[774]
@x
@!j:pool_pointer; {index into |str_pool|}
@y
@!j:pool_pointer; {index into |str_pool|}
rbs: fpc_string;
@z

[774]
@x
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
@y
rbs := name_of_file;
fpc_set_length(rbs, name_length);
name_of_file := rbs;
@z

[776]
@x
MF_base_default:='MFbases:plain.base';
@y
MF_base_default:='MFbases/plain.base';
@z

[778]
@x
@!j:integer; {index into |buffer| or |MF_base_default|}
@y
@!j:integer; {index into |buffer| or |MF_base_default|}
rbs: fpc_string;
@z

[778]
@x
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
@y
rbs := name_of_file;
fpc_set_length(rbs, name_length);
name_of_file := rbs;
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

[1204] load the base file before printing the banner line
@x
start_of_MF: @<Initialize the output routines@>;
@y
start_of_MF: @<Preload the default base file@>;
@<Initialize the output routines@>;
@z

[1205] print last end-of-line marker if needed
@x
if log_opened then
  begin wlog_cr;
  a_close(log_file); selector:=selector-2;
  if selector=term_only then
    begin print_nl("Transcript written on ");
@.Transcript written...@>
    slow_print(log_name); print_char(".");
    end;
  end;
end;
@y
if log_opened then
  begin if file_offset > 0 then wlog_cr;
  a_close(log_file); selector:=selector-2;
  if selector=term_only then
    begin print_nl("Transcript written on ");
@.Transcript written...@>
    slow_print(log_name); print_char(".");
    end;
  end;
  if term_offset > 0 then wterm_cr;
end;
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

@ Try to preload the default base file. This is called even before
the first line is read from the terminal, and thus turns \.{VIRMF}
into \.{MF}, at least as seen by the user.

\indent\.{INIMF} sets |base_ident| to `\.{INIMF}' and won't load a base
file here.

@<Preload the default base file@> =
if base_ident = 0 then
  begin pack_buffered_name(base_default_length - base_ext_length, 1, 0);
  if not w_open_in(base_file) then
    begin
    wterm_ln('I can''t find the base file ', name_of_file);
    goto final_end
    end;
  if not load_base_file then
    begin w_close(base_file); goto final_end
    end;
  w_close(base_file);
  end

@ 
@z
