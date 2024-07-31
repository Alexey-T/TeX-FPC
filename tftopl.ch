This is a change file of TFtoPL for TeX-FPC, Wolfgang Helbig, Oct. 2020

[0] About TFtoPL-FPC
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\input webmac-fpc

% \let\maybe=\iftrue % uncomment to print changed modules only.

\def\name{\tt TFtoPL}

\N0\*. About \namefpc.\fi
This is an adaption of Donald~E. Knuth's \.{TFtoPL}, to Unix.
\namefpc\ is based on the Free~Pascal Compiler.

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
@d banner=='This is TFtoPL, Version 3.3' {printed when the program starts}
@y
@d banner=='This is TFtoPL-FPC, 2nd ed.'   {printed when the program starts}
@z


[2] filenames from commandline
@x
@p program TFtoPL(@!tfm_file,@!pl_file,@!output);
@y
@p @{$MODE@,ISO@}
@/
@{$Q+@}
@/
@{$R+@}
@#
program TFtoPL(@!output);
@z

[6] violation of ISO
@x
@!tfm_file:packed file of 0..255;
@y
@!tfm_file: packed file of byte;
@z

[7] open tfm file
@x
reset(tfm_file);
@y
if paramcount <> 2 then begin
   write_ln('Usage: ', param_str(0), ' tfm_file pl_file');
   halt(1);
   end;
assign(tfm_file, param_str(1));
@#
@{$I-@}
@#
ioresult; reset(tfm_file);
if ioresult <> 0 then begin
  write_ln('Could not open tfm file: ', param_str(1));
  halt(1);
  end;
@#
@{$I+@}
@#
@z

[17] open pl file
@x
rewrite(pl_file);
@y
assign(pl_file, param_str(2));
@#
@{$I-@}
@#
ioresult; rewrite(pl_file);
if ioresult <> 0 then begin
  write_ln('Could not open pl file: ', param_str(2));
  halt(1);
  end;
@#
@{$I+@}
@z

[20] eof off by one, FPC-BUG
@x
  begin if eof(tfm_file) then
    abort('The file has fewer bytes than it claims!');
@y
  begin
@z

[99] close pl file
@x
final_end:end.
@y
close(pl_file);
@#
final_end:end.
@z
