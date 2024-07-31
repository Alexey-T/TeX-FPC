This is a change file of GFtoPK for FPC, Wolfgang Helbig, Oct. 2020 - Feb. 2021

[0] About GFtoPK-FPC
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=1 \advance\pageno by 1
\input webmac-fpc

% \let\maybe=\iffalse % true: print all modules, false: print changed modules

\def\name{\tt GFtoPK}

\N0\*. About \namefpc.\fi
This is an adaption of Tomas Rokicki's \.{GFtoPK} to Unix and the
Free Pascal Compiler~(FPC).

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
@d banner=='This is GFtoPK-FPC, 3rd ed.'
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
@p@{$MODE@,DELPHI@} {ISO Mode fails with random I/O}
@/
@{$Q+@}
@/
@{$R+@}

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
@p procedure open_gf_file; {prepares to read packed bytes in |gf_file|}
begin reset(gf_file);
gf_loc := 0 ;
end;
@y
@p procedure open_gf_file; {prepares to read packed bytes in |gf_file|}
begin assign(gf_file, param_str(1)); ioresult;
@{$I-@}
reset(gf_file);
@{$I+@}
if ioresult <> 0 then abort('Could not open ', param_str(1));
gf_loc := 0 ;
end;
@z

[40] get pk file name from command line
@x
@p procedure open_pk_file; {prepares to write packed bytes in |pk_file|}
begin rewrite(pk_file);
pk_loc := 0 ; pk_open := true ;
end;
@y
@p procedure open_pk_file; {prepares to write packed bytes in |pk_file|}
begin assign(pk_file, param_str(2)); ioresult;
@{$I-@}
rewrite(pk_file);
@{$I+@}
if ioresult <> 0 then
  abort('Could not open ', param_str(2));
pk_loc := 0 ; pk_open := true ;
end;
@z

[46] Random access
@x
   set_pos(gf_file, -1) ; gf_len := cur_pos(gf_file) ;
@y
   gf_len := file_size(gf_file)-1; seek(gf_file, gf_len);
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
