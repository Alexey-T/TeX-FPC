% This is a change file of METAPOST for FPC, Wolfgang Helbig, Nov. 2020 
% See tex.ch and mf.ch from tex-fpc
[0] to print changed sections only
@x
\def\gglob{20, 26} % this should be the next two sections of "<Global...>"
@y
\def\gglob{20, 26} % this should be the next two sections of "<Global...>"
\input webmac-fpc
\emergencystretch 0.5in % avoid overfull boxes

\let\maybe=\iffalse % uncomment to print changed modules only.

\def\name{\MP}

\N0\*.  \[0] About \namefpc.

This is an adaption of John Hobby's \MP, version 0.641,
to the Free Pascal Compiler. It is to be built and runs in
any Unix environment.

The features added include treating the command line as the first
input line and invoking a system editor, in this case \.{vi}, to
let the user correct the input file.  On exit, \namefpc\ passes its
`history' to the operating system.

\hint

Comments and questions are welcome!

\bigskip
\address
\fi
@z

[2] Change the banner line
@x
@d banner=='This is MetaPost, Version 0.641' {printed when \MP\ starts}
@y
@d banner=='This is MetaPost-FPC' {printed when \MP\ starts}
@z

[4] terminal output and input
@x
@d mtype==t@&y@&p@&e {this is a \.{WEB} coding trick:}
@y
@d term_in==i@&n@&p@&u@&t
@d term_out==o@&u@&t@&p@&u@&t
@d mtype==t@&y@&p@&e {this is a \.{WEB} coding trick:}
@z

[4] terminal output and input
@x
program MP; {all file names are defined dynamically}
@y
program MP(@!term_in,@!term_out);
@z

[4] forward reference for signal handler
@x
procedure initialize; {this procedure gets things started properly}
@y
procedure catch_signal(i: integer); interrupt@, forward;@t\2@>
procedure initialize; {this procedure gets things started properly}
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

[8] shift left to build MP and right it to build INIMP.
	@x inimp
	@d init== {change this to `$\\{init}\equiv\.{@@\{}$' in the production version}
	@d tini== {change this to `$\\{tini}\equiv\.{@@\}}$' in the production version}
	@y
	@d init==@{
	@d tini==@}
	@z

[9] compiler directives
@x
@{@&$C-,A+,D-@} {no range check, catch arithmetic overflow, no debug overhead}
@!debug @{@&$C+,D+@}@+ gubed {but turn everything on when debugging}
@y
@{$MODE@,ISO@} {turn on mode ISO}
@{$Q+@} {turn on overflow checking}
@{$R+@} {turn on range checking}
@!debug
@{@&$Q-@}@,
@{@&$R-@}@+
gubed {turn off all checks when debugging}
@z

[10] default case branch
@x
@d othercases == others: {default for cases not listed explicitly}
@y
@d othercases == @+ else {default for cases not listed explicitly}
@z

[11] location of pool file
@x
@!pool_name='MPlib:MP.POOL                         ';
  {string of length |file_name_size|; tells where the string pool appears}
@.MPlib@>
@!ps_tab_name='MPlib:PSFONTS.MAP                     ';
  {string of length |file_name_size|; locates font name translation table}
@y
@!pool_name='MPlib/mp.pool';
  {string of length |file_name_size|; tells where the string pool appears}
@.MPlib@>
@!ps_tab_name='MPlib/psfonts.map';
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
@!alpha_file=packed file of text_char; {files that contain textual data}
@y
@!alpha_file=t@&e@&x@&t; {coding trick is needed since |text| is a macro}
@z

[26] dynamic io
@x
@d reset_OK(#)==erstat(#)=0
@d rewrite_OK(#)==erstat(#)=0
@y
@d fpc_io_result==i @& o @& r @& e @& s @& u @& l @& t
@d fpc_assign==a @& s @& s @& i @& g @& n
@d reset_OK(#)==fpc_io_result=0
@d rewrite_OK(#)==fpc_io_result=0
@d clear_io_result==@+if fpc_io_result=0 then do_nothing
@z

[26] (reset and rewrite for each of three file types) alpha
@x
@p function a_open_in(var @!f:alpha_file):boolean;
  {open a text file for input}
begin reset(f,name_of_file,'/O'); a_open_in:=reset_OK(f);
@y
@p
@{$I-@} {no i/o checking}
@#
function a_open_in(var @!f:alpha_file):boolean;
  {open a text file for input}
begin clear_io_result; fpc_assign(f,name_of_file); reset(f);
a_open_in:=reset_OK(f);
@z

[26] alpha rewrite
@x
begin rewrite(f,name_of_file,'/O'); a_open_out:=rewrite_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); rewrite(f);
a_open_out:=rewrite_OK(f);
@z

[26] byte reset
@x
begin reset(f,name_of_file,'/O'); b_open_in:=reset_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); reset(f);
b_open_in:=reset_OK(f);
@z

[26] byte rewrite
@x
begin rewrite(f,name_of_file,'/O'); b_open_out:=rewrite_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); rewrite(f);
b_open_out:=reset_OK(f);
@z

[26] word reset
@x
begin reset(f,name_of_file,'/O'); w_open_in:=reset_OK(f);
@y
begin clear_io_result; fpc_assign(f,name_of_file); reset(f);
 w_open_in:=reset_OK(f);
@z

[26] word rewrite
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

[30] eoln handling
@x
begin if bypass_eoln then if not eof(f) then get(f);
@y
begin
@z

[30] bypass eoln
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
@!term_in:alpha_file; {the terminal as an input file}
@!term_out:alpha_file; {the terminal as an output file}
@y
@z

[32] no reset(input) and rewrite(output)
@x
@d t_open_in==reset(term_in,'TTY:','/O/I') {open the terminal for text input}
@d t_open_out==rewrite(term_out,'TTY:','/O') {open the terminal for text output}
@y
@d t_open_in==do_nothing {open the terminal for text input}
@d t_open_out==do_nothing {open the terminal for text output}
@z

[33] no flushing, clearing on standard i/o
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
    buffer[last] := xord[arg[cc]]; incr(last); incr(cc)
    end;
  if (argc <= fpc_param_count) then begin
    buffer[last] := " "; incr(last) {insert a space between arguments}
    end
  end
end;
@z

[36] init terminal
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
loc := first;
if loc<last then
   begin init_terminal:=true; return; {first line is the command line}
   end;
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
  write_ln(term_out,'Please type the name of your input file.');@/
  end;
exit: end;
@z

[76] print banner line on terminal
@x
@<Initialize the output...@>=
update_terminal;
@y
@<Initialize the output...@>=
wterm(banner);
if mem_ident=0 then wterm_ln(' (no mem preloaded)')
else  begin print(mem_ident); print_ln;
  end;
update_terminal;
@z

[89] start editor
@x
@!use_err_help:boolean; {should the |err_help| string be shown?}
@y
@^Editor@>
@!use_err_help:boolean; {should the |err_help| list be shown?}
@!start_edit: boolean; {start \.{vi}?}
@z

[90] initial values for start editor
@x
help_ptr:=0; use_err_help:=false; err_help:=0;
@y
help_ptr:=0; use_err_help:=false; err_help:=0; start_edit :=false;
@z

[94] start editor
@x
  begin print_nl("You want to edit file ");
@.You want to edit file x@>
  print(input_stack[file_ptr].name_field);
  print(" at line "); print_int(true_line);@/
  interaction:=scroll_mode; jump_out;
  end;
@y
@^Editor@>
  begin {start \.{vi}}
  start_edit := true;
  interaction:=scroll_mode; goto final_end;
  end;
@z

	[106] interrupt is predefined and not implemented in GNU~Pascal
	@x
	@d check_interrupt==begin if interrupt<>0 then pause_for_instructions;
	@y
	@d interrupt==buginterrupt
	@f interrupt==true
	@d check_interrupt==begin if interrupt<>0 then pause_for_instructions;
	@z

	[171] pack subranges
	@x
	@!quarterword = min_quarterword..max_quarterword; {1/4 of a word}
	@!halfword=min_halfword..max_halfword; {1/2 of a word}
	@y
	@!quarterword = packed min_quarterword..max_quarterword; {1/4 of a word}
	@!halfword=packed min_halfword..max_halfword; {1/2 of a word}
	@z

[212] time and date
@x
@p procedure fix_date_and_time;
begin internal[time]:=12*60*unity; {minutes since midnight}
internal[day]:=4*unity; {fourth day of the month}
internal[month]:=7*unity; {seventh month of the year}
internal[year]:=1776*unity; {Anno Domini}
end;
@y
The functions |now|,  |decodedate|, and |decodetime| are provided
by the unit |sysutils|. The command line \.{fpc~-Fasysutils~tex.p}
links that unit.
@^system dependencies@>
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
internal[day] := dd*unity;
internal[month] := mm*unity;
internal[year] := yy*unity;@/
fpc_decode_time(fpc_now,hh,mm,ss,ms); {current time}
internal[time] := (hh*60+mm)*unity; {minutes since midnight}
end;
@z

[217] character class for tab and lf
@x
for k:=127 to 255 do char_class[k]:=invalid_class;
@y
for k:=127 to 255 do char_class[k]:=invalid_class;
char_class[@'11] := space_class;
char_class[@'14] := space_class;
@z

[640] spurious empty line on terminal
@x
    print_ln; first:=start;
    prompt_input("*"); {input on-line into |buffer|}
@y
    print_nl("");
    first:=start; {avoid empty lines on terminal and log file}
    prompt_input("*"); {input on-line into |buffer|}
@z

[746] Path separator in Unix
@x
@d MP_area=="MPinputs:"
@.MPinputs@>
@d MF_area=="MFinputs:"
@.MFinputs@>
@d MP_font_area=="TeXfonts:"
@.TeXfonts@>
@y
@d MP_area=="MPinputs/"
@.MPinputs@>
@d MF_area=="MFinputs/"
@.MFinputs@>
@d MP_font_area=="TeXfonts/"
@.TeXfonts@>
@z

[748] Path separator in Unix
@x
else  begin if (c=">")or(c=":") then
@y
else  begin if c="/" then
@z

[751] file name handling: pack file name
@x
@d append_to_name(#)==begin c:=#; incr(k);
@y
@d fpc_set_length==s@&e@&t@&l@&e@&n@&g@&t@&h
@d append_to_name(#)==begin c:=#; incr(k);
@z

[751] pack file name
@x
@!j:pool_pointer; {index into |str_pool|}
@y
@!j:pool_pointer; {index into |str_pool|}
@!s: fpc_string;
@z

[751] pack file name
@x
if k<=file_name_size then name_length:=k@+else name_length:=file_name_size;
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
end;
@y
if k<=file_name_size then name_length:=k@+else name_length:=file_name_size;
s := name_of_file;
fpc_set_length(s, name_length);
name_of_file := s;
end;
@z

[753] file name of plain.mem
@x
MP_mem_default:='MPlib:plain.mem';
@y
MP_mem_default:='MPlib/plain.mem';
@z

[755] packed buffered name
@x
@!j:integer; {index into |buffer| or |MP_mem_default|}
@y
@^FPC Pascal@>
@!j:integer; {index into |buffer| or |TEX_format_default|}
s: fpc_string;
@z

[755] packed buffered name continued
@x
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
@y
s := name_of_file; fpc_set_length(s, name_length); name_of_file := s;
@z


[771] (don't) flush file name. Might be needed for vi
@x
flush_string(name); name:=cur_name; cur_name:=0
@y
@z



[1293] FPC-BUG eof one too early
@x
undump_int(x);@+if (x<>69073)or eof(mem_file) then goto off_base
@y
undump_int(x);@+if (x<>69073)then goto off_base
@z

[1298] define FPC procedure halt
@x
@p begin @!{|start_here|}
@y
@d fpc_halt == h@&a@&l@&t

@p begin @!{|start_here|}
@z

[1298] load the mem file before printing the banner line
@x
start_of_MP: @<Initialize the output routines@>;
@y
start_of_MP: @<Preload the default mem file@>;
@<Initialize the output routines@>;
@z

[1298] start editor and pass history
@x
final_end: ready_already:=0;
@y
final_end:
if start_edit then edit; {user typed `\.{E}'}
fpc_halt(history);
  {pass |history| as the exit value to the system}
@z

[1299] print last end-of-line marker if needed
@x
if log_opened then
  begin wlog_cr;
  a_close(log_file); selector:=selector-2;
  if selector=term_only then
    begin print_nl("Transcript written on ");
@.Transcript written...@>
    print(log_name); print_char(".");
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
    print(log_name); print_char(".");
    end;
  end;
  if term_offset > 0 then wterm_cr;
end;
@z

[1307] return if eof 
@x
  read(term_in,m);
@y
  if eof(term_in) then return;
  {don't try to read past end of file}
  read(term_in,m);
@z

[1307] return if eof
@x
  else  begin read(term_in,n);
@y
  else  begin if eof(term_in) then return;
  {don't try to read past end of file}
  read(term_in,n);
@z

[1308] return eof
@x
13: begin read(term_in,l); print_cmd_mod(n,l);
@y
13: begin if eof(term_in) then return;
  {don't try to read past end of file}
read(term_in,l); print_cmd_mod(n,l);
@z

[1309 and modules added for METAPOST-FPC]
@x
itself will get a new section number.
@^system dependencies@>
@y
itself will get a new section number.
@^system dependencies@>

@ Try to preload the default mem file. This is called even before
the first line is read from the terminal, and thus turns \.{VIRMP}
into \.{MP}, at least as seen by the user.

\indent\.{INIMP} sets |mem_ident| to `\.{INIMP}' and won't load a mem
file here.

@<Preload the default mem file@> =
if mem_ident = 0 then
  begin pack_buffered_name(mem_default_length - mem_ext_length, 1, 0);
  if not w_open_in(mem_file) then
    begin
    wterm_ln('I can''t find the mem file');
    goto final_end
    end;
  if not load_mem_file then
    begin w_close(mem_file); goto final_end
    end;
  w_close(mem_file);
  end

@ 
@d fpc_execute == e@&x@&e@&c@&u@&t@&e @& p @& r @& o @& c @& e @& s @& s
@d fpc_int_to_str == i @& n @& t @& t @& o @& s @& t @& r
@d edit_file == input_stack[file_ptr].name_field

@<Error hand...@>+=
procedure edit;
var i: integer; {index into |name_of_file|}
    j: pool_pointer; {index into |str_pool|}
    k: pool_pointer; {index into |str_pool|}
    s: str_number; {index into |str_start|}
    f, arg, vi, sl: fpc_string; {area to build the command line}
begin i := 1; s := edit_file;j := str_start[s]; k:= str_stop(s);
fpc_set_length(f, length(s));
while j<k do
  begin f[i] := xchr[str_pool[j]]; incr(i); incr(j)
  end;
sl := fpc_int_to_str(true_line);
if 0 <> fpc_execute('/usr/bin/vi', '+' + fpc_int_to_str(true_line) + ' ' + f)
then
  begin
  write('I could not start editor with: ', '/usr/bin/vi +', sl , '   ', f);
  print(edit_file); print_ln;
  end
end;

@

@d fpc_signal_handler == s@&i@&g@&n@&a@&l@&h@&a@&n@&d@&l@&e@&r
@d fpc_fp_signal == f@&p@&s@&i@&g@&n@&a@&l
@d fpc_fp_get_errno ==f@&p@&g@&e@&t@&e@&r@&r@&n@&o

@<Set initial values ...@>+=

fpc_fp_signal(SIGINT, fpc_signal_handler(catch_signal));
if fpc_fp_get_errno <> 0 then
   write_ln('Could not install signal handler:', fpc_fp_get_errno);

@
The signal handler has the so called modifier |interrupt|.
Modifiers are an extension of FPC Pascal. This one makes the compiler
generate code suitable for a signal handler, which must not
return to the caller but to the instruction where the program was
interrupted.

@^FPC Pascal@>
@^dirty \PASCAL@>
@^system dependencies@>

@<Error handling ...@>+=
procedure catch_signal; interrupt;
begin
  interrupt := i;
end;
@z
	@d fpc_t_signal_handler == t@&s@&i@&g@&n@&a@&l@&h@&a@&n@&d@&l@&e@&r
	@d fpc_install_signal_handler ==
	 i@&n@&s@&t@&a@&l@&l@&s@&i@&g@&n@&a@&l@&h@&a@&n@&d@&l@&e@&r
	@d fpc_sig_int == s@&i@&g@&i@&n@&t
	@d fpc_integer == integer {for later versions of FPC (3.4+) replace
	  \\{integer} by \\{cinteger}}
	  
	@<Error hand...@>=
	procedure set_interrupt(signal: fpc_integer);
	begin interrupt := 1 @+end;
	  
	@
	@<Set initial values ... @>=
	fpc_install_signal_handler(gpc_sig_int,set_interrupt,true,true,dummy_handler,
	  dummy_boolean);
	  
	@ Here are two variables that are needed to install |set_interrupt|.
	@<Local variables for initialization@> =
	dummy_handler: fpc_t_signal_handler;
	dummy_boolean: boolean;
	@z
