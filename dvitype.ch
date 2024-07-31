This is a change file of DVItype for FPC, Wolfgang Helbig, Oct. 2020 - Jan 2021

[0] About DVItype-FPC
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\input webmac-fpc

% \let\maybe=\iftrue % uncomment to print changed modules only.

\def\name{\tt DVItype}

\N0\*. About \namefpc.\fi
This is an adaption of Donald~E. Knuth's \.{DVItype} to the Free Pascal
Compiler and Unix.

\namefpc\ expects the name of the input file (\.{.dvi}) as the first
and the name of the output file (\.{.typ} as the second parameter
on the command line.

\hint

Comments and questions are welcome!

\bigskip
\address
@z

[1] Change the banner line
@x
@d banner=='This is DVItype, Version 3.6' {printed when the program starts}
@y
@d banner=='This is DVItype-FPC, 3rd ed.'   {printed when the program starts}
@z

[2] othercases
@x
@d othercases == others: {default for cases not listed explicitly}
@y
@d othercases == @+ else {default for cases not listed explicitly}
@z

[3] filenames from commandline
@x
@d print(#)==write(#)
@d print_ln(#)==write_ln(#)

@p program DVI_type(@!dvi_file,@!output);
@y
@d print(#)==write(typ_file, #)
@d print_ln(#)==write_ln(typ_file, #)

@p @{$MODE@,ISO@}
@/
@{$Q+@}
@/
@{$R+@}
@/
@{$I+@}
@#
program DVI_type(@!input, @!output);
@z

[9] text file.
@x
@!text_file=packed file of text_char;
@y
@!text_file=text;
@z

[22] check io_result.
@x
@!dvi_file:byte_file; {the stuff we are \.{DVI}typing}
@!tfm_file:byte_file; {a font metric file}
@y
@!dvi_file:byte_file; {the stuff we are \.{DVI}typing}
@!tfm_file:byte_file; {a font metric file}
@!tfm_open:boolean;   {tfm file is open}
@!typ_file: text;     {output file}
@z

[23] open dvi file
@x
begin reset(dvi_file);
@y
begin  assign(dvi_file, param_str(1));
@#
@{$I-@}
@#
io_result; reset(dvi_file);
if io_result <> 0 then begin
  write_ln('Could not open dvi file: ', param_str(1));
  halt(1);
  end;
@#
@{$I+@}
@#
@z

[23] open tfm file
@x
procedure open_tfm_file; {prepares to read packed bytes in |tfm_file|}
begin reset(tfm_file,cur_name);
end;
@y
procedure open_tfm_file; {prepares to read packed bytes in |tfm_file|}
begin
io_result; assign(tfm_file, cur_name);
@#
@{$I-@}
@#
reset(tfm_file);
tfm_open := io_result = 0;
if not tfm_open then write_ln(cur_name, ' failed to open');
end;
@#
procedure open_typ_file;
begin
if paramcount <> 2 then begin
   write_ln('Usage: ', param_str(0), ' dvi_file typ_file');
   halt(1);
   end;
io_result; assign(typ_file, param_str(2)); rewrite(typ_file);
if io_result <> 0 then begin
  write_ln('Could not open type file: ', param_str(2));
  halt(1);
  end;
end;
@#
@{$I+@}
@#
@z

[24] cur_name is shortstring;
@x
@!cur_name:packed array[1..name_length] of char; {external name,
@y
@!cur_name: shortstring; {external name,
@z


[25] random file access
@x
@p function dvi_length:integer;
begin set_pos(dvi_file,-1); dvi_length:=cur_pos(dvi_file);
end;
@#
procedure move_to_byte(n:integer);
begin set_pos(dvi_file,n); cur_loc:=n;
end;
@y
@p function dvi_length:integer;
begin dvi_length:=file_size(dvi_file); 
end;
@#
procedure move_to_byte(n:integer);
begin seek(dvi_file,n); cur_loc:=n;
end;
@z

[43] options
	@x
	out_mode:=the_works; max_pages:=1000000; start_vals:=0; start_there[0]:=false;
	@y
	out_mode:=2; max_pages:=1000000; start_vals:=9;
	for i := 0 to 9 do start_there[i] := false;
	@z

[45] standard io files
@x
and |term_out| for terminal output.
@^system dependencies@>

@<Glob...@>=
@!buffer:array[0..terminal_line_length] of ASCII_code;
@!term_in:text_file; {the terminal, considered as an input file}
@!term_out:text_file; {the terminal, considered as an output file}
@y
and |term_out| for terminal output.
@^system dependencies@>
@d term_in == input
@d term_out == output
@<Glob...@>=
@!buffer:array[0..terminal_line_length] of ASCII_code;
@z

[46] no break known to fpc
@x
@d update_terminal == break(term_out) {empty the terminal output buffer}
@y
@d update_terminal ==  {empty the terminal output buffer}
@z

[47] input_ln
@x
@p procedure input_ln; {inputs a line from the terminal}
var k:0..terminal_line_length;
begin update_terminal; reset(term_in);
if eoln(term_in) then read_ln(term_in);
k:=0;
while (k<terminal_line_length)and not eoln(term_in) do
  begin buffer[k]:=xord[term_in^]; incr(k); get(term_in);
  end;
buffer[k]:=" ";
end;
@y
@p procedure input_ln; {inputs a line from the terminal}
var k:0..terminal_line_length;
begin
k:=0;
while (k<terminal_line_length) and not eoln do
  begin buffer[k]:=xord[input^]; incr(k); get(input);
  end;
readln;
buffer[k]:=" ";
end;
@z

[62] check if tfm file open.
@x
if eof(tfm_file) then
@y
if not tfm_open then
@z

[64] default directory
@x
@d default_directory_name=='TeXfonts:' {change this to the correct name}
@y
@d default_directory_name=='TeXfonts/' {change this to the correct name}
@z

[66] lower case letters in Unix
@x
for k:=1 to name_length do cur_name[k]:=' ';
if p=0 then
  begin for k:=1 to default_directory_name_length do
    cur_name[k]:=default_directory[k];
  r:=default_directory_name_length;
  end
else r:=0;
for k:=font_name[nf] to font_name[nf+1]-1 do
  begin incr(r);
  if r+4>name_length then
    abort('DVItype capacity exceeded (max font name length=',
      name_length:1,')!');
@.DVItype capacity exceeded...@>
  if (names[k]>="a")and(names[k]<="z") then
      cur_name[r]:=xchr[names[k]-@'40]
  else cur_name[r]:=xchr[names[k]];
  end;
cur_name[r+1]:='.'; cur_name[r+2]:='T'; cur_name[r+3]:='F'; cur_name[r+4]:='M'
@y
setlength(cur_name, 255);
if p=0 then
  begin for k:=1 to default_directory_name_length do
    cur_name[k]:=default_directory[k];
  r:=default_directory_name_length;
  end
else r:=0;
for k:=font_name[nf] to font_name[nf+1]-1 do
  begin incr(r);
  if r+4>name_length then
    abort('DVItype capacity exceeded (max font name length=',
      name_length:1,')!');
@.DVItype capacity exceeded...@>
  cur_name[r]:=xchr[names[k]];
  end;
cur_name[r+1]:='.'; cur_name[r+2]:='t'; cur_name[r+3]:='f'; cur_name[r+4]:='m'
;setlength(cur_name, r+4)
@z


[105] premature eof on tfm file
@x
while (m=223)and not eof(dvi_file) do m:=get_byte;
@y
while (m=223)and not eof(dvi_file) do m:=get_byte;
inc(cur_loc); {FPC-BUG: eof off by one}
@z
[107] open typ file
@x
@p begin initialize; {get all variables initialized}
@y
@p begin open_typ_file; {initialze prints banner on typ file}
initialize; {get all variables initialized}
@z

[107 close type file
@x
final_end:end.
@y
close(typ_file);
final_end:end.
@z

