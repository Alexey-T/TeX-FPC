This is a change file of GFtype for FPC, Wolfgang Helbig, Oct. 2020
To be used with the Free Pascal Compiler

[0] About type-FPC
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\input webmac-fpc

% \let\maybe=\iftrue % uncomment to print changed modules only.

\def\name{\tt GFtype}

\N0\*. About \namefpc.\fi
This is an adaption of Donald~E. Knuth's \.{GFtype}, to Unix.
\namefpc\ is based on Free~Pascal.

\namefpc\ expects the name of the input file (\.{.gf}) as the first
and the name of the output file (\.{.typ} as the second parameter
on the command line.

\hint

Comments and questions are welcome!

\bigskip
\address
@z

[1] Change the banner line
@x
@d banner=='This is GFtype, Version 3.1' {printed when the program starts}
@y
@d banner=='This is GFtype-FPC, 3rd ed.'   {printed when the program starts}
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
@d print_nl==write_ln

@p program GF_type(@!gf_file,@!output);
@y
@d print(#)==write(typ_file, #)
@d print_ln(#)==write_ln(typ_file, #)
@d print_nl==write_ln(typ_file)

@p @{$MODE@,ISO@}
@/
@{$Q+@}
@/
@{$R+@}
@/
@{$I+@}
@#
program GF_type(@!input, @!output);
@z

[9] text file.
@x
@!text_file=packed file of text_char;
@y
@!text_file=text;
@z

[21] declare typ file
@x
@!gf_file:byte_file; {the stuff we are \.{GF}typing}
@y
@!gf_file:byte_file; {the stuff we are \.{GF}typing}
@!typ_file: text; { output file }
@z

[22] open gf file
@x
begin reset(gf_file);
@y
begin  assign(gf_file, param_str(1));
@#
@{$I-@}
@#
ioresult; reset(gf_file);
if ioresult <> 0 then begin
  write_ln('Could not open gf file: ', param_str(1));
  halt(1);
  end;
@#
@{$I+@}
@#
@z

[27] standard io files
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

[28] no break known to fpc
@x
@d update_terminal == break(term_out) {empty the terminal output buffer}
@y
@d update_terminal ==  {empty the terminal output buffer}
@z

[29] input_ln
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

[66] open typ file
@x
@p begin initialize; {get all variables initialized}
@y
@p begin
if paramcount <> 2 then begin
   write_ln('Usage: ', param_str(0), ' gf_file typ_file');
   halt(1);
   end;

assign(typ_file, param_str(2));
@#
@{$I-@}
@#
ioresult; rewrite(typ_file);
if ioresult <> 0 then begin
  write_ln('Could not open type file: ', param_str(2));
  halt(1);
  end;
@#
@{$I+@}
@#
initialize; {get all variables initialized}
@z

[66] terminate last line in typ file
@x
final_end:end.
@y
print_nl;
close(typ_file);
final_end:end.
@z

