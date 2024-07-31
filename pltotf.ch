This is a change file of PLtoTF for TeX-FPC, Wolfgang Helbig, Oct. 2020.

[0] About PLtoTF-FPC
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\input webmac-fpc

% \let\maybe=\iftrue % uncomment to print changed modules only.

\def\name{\tt PLtoTF}

\N0\*. About \namefpc.\fi
This is an adaption of Donald~E. Knuth's \.{PLtoTF} to Unix. \namefpc\
is based on the Free~Pascal Compiler.

\namefpc\ expects the name of the input file (\.{.pl}) as the first
and the name of the output file (\.{.tf}) as the second parameter
on the command line.

\hint

Comments and questions are welcome!

\bigskip
\address
@z

[1] Change the banner line
@x
@d banner=='This is PLtoTF, Version 3.6' {printed when the program starts}
@y
@d banner=='This is PLtoTF-FPC, 2nd ed.'   {printed when the program starts}
@z


[2] compiler directives
@x
@p program PLtoTF(@!pl_file,@!tfm_file,@!output);
@y
@p@{$MODE@,ISO@}
@/
@{$Q+@}
@/
@{$R+@}
@#
program PLtoTF(@!output);
@z

[6] open pl_file
@x
reset(pl_file);
@y
assign(pl_file, param_str(1));
@#
@{$I-@}
@#
ioresult; reset(pl_file);
if ioresult <> 0 then begin
  write_ln('Could not open pl file: ', param_str(1));
  halt(1);
  end;
@#
@{$I+@}
@z


[15] violation of ISO
@x
@!tfm_file:packed file of 0..255;
@y
@!tfm_file: packed file of byte;
@z

[16] open tfm_file
@x
rewrite(tfm_file);
@y
if paramcount <> 2 then begin
   write_ln('Usage: ', param_str(0), ' pl_file tfm_file');
   halt(1);
   end;

assign(tfm_file, param_str(2));
@#
@{$I-@}
@#
ioresult; rewrite(tfm_file);
if ioresult <> 0 then begin
  write_ln('Could not open tfm file: ', param_str(2));
  halt(1);
  end;
@#
@{$I+@}
@#
@z
