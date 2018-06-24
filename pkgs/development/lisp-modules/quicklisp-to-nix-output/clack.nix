args @ { fetchurl, ... }:
rec {
  baseName = ''clack'';
  version = ''20180328-git'';

  description = ''Web application environment for Common Lisp'';

  deps = [ args."alexandria" args."bordeaux-threads" args."ironclad" args."lack" args."lack-component" args."lack-middleware-backtrace" args."lack-util" args."nibbles" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2018-03-28/clack-20180328-git.tgz'';
    sha256 = ''1appp17m7b5laxwgnidf9kral1476nl394mm10xzi1c0i18rssai'';
  };

  packageName = "clack";

  asdFilesToKeep = ["clack.asd"];
  overrides = x: x;
}
/* (SYSTEM clack DESCRIPTION Web application environment for Common Lisp SHA256
    1appp17m7b5laxwgnidf9kral1476nl394mm10xzi1c0i18rssai URL
    http://beta.quicklisp.org/archive/clack/2018-03-28/clack-20180328-git.tgz
    MD5 5cf75a5d908efcd779438dc13f917d57 NAME clack FILENAME clack DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME ironclad FILENAME ironclad) (NAME lack FILENAME lack)
     (NAME lack-component FILENAME lack-component)
     (NAME lack-middleware-backtrace FILENAME lack-middleware-backtrace)
     (NAME lack-util FILENAME lack-util) (NAME nibbles FILENAME nibbles)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria bordeaux-threads ironclad lack lack-component
     lack-middleware-backtrace lack-util nibbles uiop)
    VERSION 20180328-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-socket clack-test clack-v1-compat
     t-clack-handler-fcgi t-clack-handler-hunchentoot t-clack-handler-toot
     t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic
     clack-middleware-clsql clack-middleware-csrf clack-middleware-dbi
     clack-middleware-oauth clack-middleware-postmodern
     clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)
    PARASITES NIL) */
