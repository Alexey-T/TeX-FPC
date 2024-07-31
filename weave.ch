% This is a change file for WEAVE-FPC, Wolfgang Helbig, Nov. 2007 - Feb. 2021
[0] About WEAVE-FPC
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\input webmac-fpc
\def\name{\tt WEAVE}
\tracingstats=1

\let\maybe=\iffalse % print changed modules only.

\N0\*. About \namefpc.\fi
This is an adaption of Donald~E. Knuth's \.{WEAVE}, version 4.5
from January 2021, to Unix. \namefpc\ is based on FPC~Pascal,
version 3.0.0.

This program expects three file names on the command line:  A
web~file (\.{.web}), a change~file (\.{.ch}), and a \TeX~file
(\.{.tex}). If you  call \namefpc\ with the wrong number of command
line arguments, it will tell you and exit.
To support shell scripting, \namefpc\ sets the exit code to its
`\\{history}'---zero means ok, one means a warning was issued, two
an error occurred and three means \.{WEAVE} ended prematurely.

\hint

The input file \.{weave.tex} will exceed \TeX's memory. To fix,
change the constant value \.{MEMMAX} to 32000 in \.{tex.p},
recompile and run it on \.{weave.tex}.  Put \.{\\tracingstats1}
in \.{weave.tex}. The log file then shows the memory \TeX\ needed
to compile its input.
These commands will do:

{\obeylines
\indent\.{sed s/MEMMAX=30000/MEMMAX=32000/ ../tex/tex.p >tex.p}
\indent\.{fpc -Fasysutils,baseunix,unix tex.p}
}

\medskip
Comments and questions are welcome!
\bigskip
\address
@z

[1] Change the banner line
@x
@d banner=='This is WEAVE, Version 4.5'
@y
@d banner=='This is WEAVE-FPC, 3rd ed.'
@z

[2] program header
@x
program WEAVE(@!web_file,@!change_file,@!tex_file);
@y
program WEAVE(@!output);
@z

[3] shift left to turn debugging on, shift right to turn it off
	@x debug
	@d debug==@{ {change this to `$\\{debug}\equiv\null$' when debugging}
	@d gubed==@t@>@} {change this to `$\\{gubed}\equiv\null$' when debugging}
	@y
	@d debug==
	@d gubed==
	@z

	[3] turn stats on
	@x stats
	@d stat==@{ {change this to `$\\{stat}\equiv\null$'
	  when gathering usage statistics}
	@d tats==@t@>@} {change this to `$\\{tats}\equiv\null$'
	  when gathering usage statistics}
	@y
	@d stat==
	@d tats==
	@z

[4] compiler directives
@x
@{@&$C-,A+,D-@} {no range check, catch arithmetic overflow, no debug overhead}
@!debug @{@&$C+,D+@}@+ gubed {but turn everything on when debugging}
@y
@{$MO@&DE@,ISO@}
@/
@{$Q+@}
@/
@{$R+@}
@z

[7] default case branch
@x
@d othercases == others: {default for cases not listed explicitly}
@y
@d othercases == @+else  {default for cases not listed explicitly}
@z

[12] the type of text_files is text in ISO Pascal
@x
@!text_file=packed file of text_char;
@y
@!text_file=text;
@z

[20] terminal input/output
@x
@d print(#)==write(term_out,#) {`|print|' means write on the terminal}
@y
@d term_out == output
@d print(#)==write(term_out,#) {`|print|' means write on the terminal}
@z

[20] terminal output, implicitely defined in ISO Pasal
@x
@<Globals...@>=
@!term_out:text_file; {the terminal as an output file}
@y
@z

[21] terminal output, output is rewritten implicitely in ISO Pascal
@x
@<Set init...@>=
rewrite(term_out,'TTY:'); {send |term_out| output to the terminal}
@y
@z

[22] terminal output, don't need update in ISO Pascal
@x
@d update_terminal == break(term_out) {empty the terminal output buffer}
@y
@d update_terminal == do_nothing
@z

[24] open input files
@x
begin reset(web_file); reset(change_file);
end;
@y
begin
assign(web_file, param_str(1)); assign(change_file, param_str(2));
@{$I-@}
@#
ioresult; reset(web_file);
if ioresult <> 0 then begin
  write_ln('Could not open web file: ', param_str(1));
  halt(1);
  end;
ioresult; reset(change_file);
if ioresult <> 0 then begin
  write_ln('Could not open change file: ', param_str(2));
  halt(1);
  end;
@#
@{$I+@}
end;
@z

[26] get file names from command line
@x
rewrite(tex_file);
@y
if param_count <> 3 then begin
   write_ln('Usage: ', param_str(0), ' web-file change-file TeX-file');
   halt(1);
   end;
assign(tex_file, param_str(3));
@#
@{$I-@}
@#
ioresult; rewrite(tex_file);
if ioresult <> 0 then begin
  write_ln('Could not open tex_file: ', param_str(3));
  halt(1);
  end;
@#
@{$I+@}
@#
@z

[258] Don't define Pascal's standard text files 
@x
@!term_in:text_file; {the user's terminal as an input file}
@y
@z

[259] terminal input, implicitely done in ISO Pascal
@x
reset(term_in,'TTY:','/I'); {open |term_in| as the terminal, don't do a |get|}
@y
@z

[261] define fpc_close
@x
@^split procedures@>
@y
@^split procedures@>

@d fpc_close == c@&l@&o@&s@&e
@z

[261] close tex_file
@x
end_of_WEAVE:
@y
fpc_close(tex_file);
end_of_WEAVE:
@z

[263] put eol after last terminal out line
@x
fatal_message: print_nl('(That was a fatal error, my friend.)');
end {there are no other cases}
@y
fatal_message: print_nl('(That was a fatal error, my friend.)');
end; {there are no other cases}
new_line;
halt(history) {pass the history as exit code to the operating system}
@z
