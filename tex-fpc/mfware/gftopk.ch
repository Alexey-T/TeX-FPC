This is a change file of GFtoPK for FPC, Wolfgang Helbig, Apr. 2008
To be used with the GNU Pascal Compiler Version 2.1

[0] About GFtoPK-FPC
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\input webmac-fpc

% \let\maybe=\iffalse % uncomment to print changed modules only.

\def\name{\tt GFtoPK}

\N0\*. About \namefpc.\fi
This is an adaption of Donald~E. Knuth's \.{GFtoPK}, version 2.4
from January 2014, to Unix. \namefpc\ is based on Free~Pascal,
version 3.0.0

\namefpc\ expects the input file (\.{.gf}) and the output file
(\.{.pk}) on the command line.
To support shell scripting, it sets the exit code to one
when something was wrong with the input file.

\hint

Comments and questions are welcome!

\bigskip
\address
@z

[1] Change the banner line
@x
@d banner=='This is GFtoPK, Version 2.4' {printed when the program starts}
@y
@d banner=='This is GFtoPK-FPC'
   {printed when the program starts}
@z

[3] default case branch
@x
@d othercases == others: {default for cases not listed explicitly}
@y
@d othercases == @+else {default for cases not listed explicitly}
@z

[4] filenames from commandline
@x
@p program GFtoPK(@!gf_file,@!pk_file,@!output);
@y
@p@{@&$M@&O@&D@&E D@&E@&L@&P@&H@&I@}

 program GFtoPK(@!output);
@z

[8] pint end of line at end of line
@x
@d abort(#)==begin print(' ',#); jump_out;
@y
@d abort(#)==begin print_ln(' ',#); history := 1; jump_out;
@z

[8] cannot use nonlocal goto in DELPHI-Mode
@x
begin goto final_end;
@y
begin halt(history);
@z

[39] get gf file name from command line
@x
begin reset(gf_file);
@y
begin assign(gf_file, param_str(1)); reset(gf_file);
@z

[40] get pk file name from command line
@x
begin rewrite(pk_file);
@y
begin assign(pk_file, param_str(2)); rewrite(pk_file);
@z

[46] Random access
@x
   set_pos(gf_file, -1) ; gf_len := cur_pos(gf_file) ;
@y
   gf_len := file_size(gf_file); seek(gf_file, gf_len);
@z

@x
   set_pos(gf_file, n); gf_loc := n ;
@y
   seek(gf_file, n); gf_loc := n ;
@z

[51] check command line arguments
@x
   open_gf_file ;
@y
   if param_count <> 2 then abort('Usage: gftopk gf-file pk-file');
   open_gf_file ;
@z

[88 ff] system dependent changes
@x
itself will get a new section number.
@^system dependencies@>
@y
itself will get a new section number.
@^system dependencies@>

@<Glob...@>=
@! history : integer;

@ @<Set init...@>=
history := 0;
@z
