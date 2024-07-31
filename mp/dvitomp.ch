% This is a change file of DVItoMP-FPC, Wolfgang Helbig, Aug. 2008
To be used with the GNU Pascal Compiler Version 2.1

[0] About DVItoMP-FPC
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\input webmac-gpc

% \let\maybe=\iffalse % uncomment to print changed modules only.

\def\name{\tt DVItoMP}

\N0\*. About \namegpc.\fi

This is an adaption of John Hobby's \name, version 0.64, to Unix
and GNU~Pascal, version 2.1.

This program expects the input file (\.{.dvi}) and the output file,
(\.{mpx}) which is a text file, on the command line.  To support shell
scripting, \namegpc\ sets the exit code to one when something was
wrong with the input file.

\hint

Comments and questions are welcome!

\bigskip
\address
@z
[1] Change the banner line
@x
@d banner=='% Written by DVItoMP, Version 0.64'
@y
@d banner=='% Written by DVItoMP-FPC, 2nd ed.'
@z

[3] only stdio files in program header.
@x
@p program DVI_to_MP(@!dvi_file,@!mpx_file,@!output);
@y
@p
@{@&$I-@} {no I/O checking}
program DVI_to_MP(input, output);
@z

[9] check command line arguments
@x
history:=spotless;
@y
history:=spotless;
if param_count <> 2 then
  begin write_ln('Usage: dvitomp dvi_file mpx_file'); halt(1);
  end;
@z

[12] Pascal's type of text_files is text
@x
@!text_file=packed file of text_char;
@y
@!text_file=text;
@z

[14] get file name from command line
@x
begin rewrite(mpx_file);
@y
begin
rewrite(mpx_file, param_str(2));
@z

[17] use FPC extension for packing subranges.
@x
@!eight_bits=0..255; {unsigned one-byte quantity}
@y
@!eight_bits=packed 0..255; {unsigned one-byte quantity}
@z

[22] declare out_file
@x
@!tfm_file:byte_file; {a font metric file}
@y
@!tfm_file:byte_file; {a font metric file}
@!out_file:text; {the outfile}
@z

[19] open file whose name is not known at compile time
@x
has acted, these routines assume that no file named |s| is accessible.
@y
has acted, these routines assume that no file named |s| is accessible.
@d io_ok==io_result=0
@d clear_io_result==@+if io_result=0 then
@z

@x
begin reset(dvi_file);
@y
begin reset(dvi_file, param_str(1));
@z

@x
begin reset(tfm_file,cur_name);
@y
begin reset(tfm_file,trim(cur_name)); {ignore leading and trailing blanks}
@z

@x
begin reset(vf_file,cur_name);
open_vf_file:=(not eof(vf_file));
@y
begin clear_io_result; reset(vf_file,trim(cur_name));
 open_vf_file:=io_ok;
@z

	[28] no random access
	@x;
	begin set_pos(dvi_file,-1); dvi_length:=cur_pos(dvi_file);
	end;
	@#
	procedure move_to_byte(n:integer);
	begin set_pos(dvi_file,n); cur_loc:=n;
	end;
	@y;
	begin do_nothing;
	end;
	@#
	procedure move_to_byte(n:integer);
	begin do_nothing;
	end;
	@z

[47]
	@x
	is always at least one blank space in |buffer|.
	@^system dependencies@>

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
	is always at least one blank space in |buffer|.
	This is changed here: |term_in| is standard input and is not supposed
	to be opened. There is never an end-of-line marker at the beginning of
	a line but always at the end of a line.
	@^system dependencies@>

	@p procedure input_ln; {inputs a line from the terminal}
	var k:0..terminal_line_length;
	begin update_terminal;
	k:=0;
	while (k<terminal_line_length)and not eoln(term_in) do
	  begin buffer[k]:=xord[term_in^]; incr(k); get(term_in);
	  end;
	read_ln(term_in);
	buffer[k]:=" ";
	end;
	@z

	[50] don't rewrite output file, write the banner while initializing
	@x
	begin rewrite(term_out); {prepare the terminal for output}
	write_ln(term_out,banner);
	@y
	begin
	@z

[61]
@x
@d default_directory_name=='TeXfonts:' {change this to the correct name}
@y
@d default_directory_name=='TeXfonts/' {change this to the correct name}
@z

[63] lowercase filename
@x
  if (names[k]>="a")and(names[k]<="z") then
      cur_name[l]:=xchr[names[k]-@'40]
  else cur_name[l]:=xchr[names[k]];
  end;
cur_name[l+1]:='.'; cur_name[l+2]:='V'; cur_name[l+3]:='F'
@y
  cur_name[l]:=xchr[names[k]]
  end;
cur_name[l+1]:='.'; cur_name[l+2]:='v'; cur_name[l+3]:='f'
@z

[64] lowercase filename
@x
cur_name[l+2]:='T'; cur_name[l+3]:='F'; cur_name[l+4]:='M'
@y
cur_name[l+2]:='t'; cur_name[l+3]:='f'; cur_name[l+4]:='m'
@z

[107] set exit code
@x
final_end:end.
@y
final_end:halt(history) end.
@z
