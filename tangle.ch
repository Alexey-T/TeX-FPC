% This is a change file for TANGLE-FPC, Wolfgang Helbig, Nov. 2007 - Jan 2021

[0] About TANGLE-FPC
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=1 \advance\pageno by 1
\input webmac-fpc
\def\name{{\tt TANGLE}}

\let\maybe=\iftrue % print changed modules only.

\N0\*. About \namefpc.\fi
This is an adaption of Donald~E. Knuth's \.{TANGLE} to Unix and the
Free Pascal Compiler~(FPC).

\namefpc\ expects four file names on the command line: Two input
files, the web and change file, followed by two output files, the
Pascal and string pool file.

To support shell scripting, tangle sets the exit code to its
`\\{history}'---zero means ok, one means a warning was issued, two
an error occurred and three means \namefpc\ ended prematurely.
\hint

Comments and questions are welcome!
\bigskip
\address
@z

[1] Change the banner line
@x
@d banner=='This is TANGLE, Version 4.6'
@y
@d banner=='This is TANGLE-FPC, 3rd ed.'
@z

	[3] turn debugging on
	@x
	@d debug==@{ {change this to `$\\{debug}\equiv\null$' when debugging}
	@d gubed==@t@>@} {change this to `$\\{gubed}\equiv\null$' when debugging}
	@y
	@d debug==
	@d gubed==
	@z

[2]
@x
program TANGLE(@!web_file,@!change_file,@!Pascal_file,@!pool);
@y
program TANGLE(@!term_out);
@z

[3] shift left to turn stats on, right to turn them off.
	@x
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
@{$MODE@,ISO@}
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

[20] terminal output
@x
@d print(#)==write(term_out,#) {`|print|' means write on the terminal}
@y
@d term_out == output
@d term_in == input
@d print(#)==write(#) {`|print|' means write on the terminal}
@z

[20] terminal output, implicitely defined in ISO Pasal
@x
@<Globals...@>=
@!term_out:text_file; {the terminal as an output file}
@y
@z

[21] terminal output output is implicitely opened in Pascal
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
@p procedure open_input; {prepare to read |web_file| and |change_file|}
begin reset(web_file); reset(change_file);
end;
@y
@p procedure open_input; {prepare to read |web_file| and |change_file|}
begin
assign(web_file, param_str(1));
assign(change_file, param_str(2));
@#
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
@#
end;
@z

[26] get file names from command line arguments
@x
rewrite(Pascal_file); rewrite(pool);
@y
if paramcount <> 4 then begin
   write_ln('Usage: ', param_str(0),
         ' web_file change_file Pascal_file pool_file');
   halt(1);
   end;
assign(Pascal_file, param_str(3)); assign(pool, param_str(4));
@#
@{$I-@}
@#
ioresult; rewrite(Pascal_file);
if ioresult <> 0 then begin
  write_ln('Could not open Pascal file: ', param_str(3));
  halt(1);
  end;
ioresult; rewrite(pool);
if ioresult <> 0 then begin
  write_ln('Could not open pool file: ', param_str(4));
  halt(1);
  end;
@#
@{$I+@}
@#
@z

[38] increase token capacity to tangle mf.
@x
@d zz=3 {we multiply the token capacity by approximately this amount}
@y
@d zz=4 {we need 4 not 3 to tangle mf}
@z

[179]
@x
@!term_in:text_file; {the user's terminal as an input file}
@y
@z

[180] terminal input, implicitely done by Pascal
@x
reset(term_in,'TTY:','/I'); {open |term_in| as the terminal, don't do a |get|}
@y
@z

[182] close output files
@x
end_of_TANGLE:
if string_ptr>256 then @<Finish off the string pool file@>;
@y
if string_ptr>256 then @<Finish off the string pool file@>;
close (Pascal_file); close (pool);
end_of_TANGLE:
@z

[187] put eol after last terminal out line
@x
fatal_message: print_nl('(That was a fatal error, my friend.)');
end {there are no other cases}
@y
fatal_message: print_nl('(That was a fatal error, my friend.)');
end; {there are no other cases}
new_line;
halt(history) {pass the history as exit code to the operating system}
@z
