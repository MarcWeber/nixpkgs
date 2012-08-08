# TODO tidy up eg The patchelf code is patching gvim even if you don't build it..
# but I have gvim with python support now :) - Marc
args@{vimNox ? false, ...}: with args;


let inherit (args.composableDerivation) composableDerivation edf; in
composableDerivation {} {

    name = "vim_configurable-7.3";

    src = if vimNox 
      then {
        # vim nox branch: client-server without X by uing sockets
        # REGION AUTO UPDATE: { name="vim-nox"; type="hg"; url="https://code.google.com/r/yukihironakadaira-vim-cmdsrv-nox/"; branch="cmdsrv-nox"; }
        src = (fetchurl { url = "http://mawercer.de/~nix/repos/vim-nox-hg-2082fc3.tar.bz2"; sha256 = "293164ca1df752b7f975fd3b44766f5a1db752de6c7385753f083499651bd13a"; });
        name = "vim-nox-hg-2082fc3";
        # END
      }.src else
        args.fetchurl {
        url = ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2;
        sha256 = "079201qk8g9yisrrb0dn52ch96z3lzw6z473dydw9fzi0xp5spaw";
      };

    configureFlags = ["--enable-gui=auto" "--with-features=${args.features}"];

    buildNativeInputs = [ncurses pkgconfig]
      ++ [ gtk libX11 libXext libSM libXpm libXt libXaw libXau libXmu glib 
           libICE ];

    # most interpreters aren't tested yet.. (see python for example how to do it)
    flags = {
        ftNix = {
          patches = [ ./ft-nix-support.patch ];
        };
      }
      // edf { name = "darwin"; } #Disable Darwin (Mac OS X) support.
      // edf { name = "xsmp"; } #Disable XSMP session management
      // edf { name = "xsmp_interact"; } #Disable XSMP interaction
      // edf { name = "mzscheme"; } #Include MzScheme interpreter.
      // edf { name = "perl"; feat = "perlinterp"; enable = { buildNativeInputs = [perl]; };} #Include Perl interpreter.
      // edf { name = "python"; feat = "pythoninterp"; enable = { buildNativeInputs = [python]; }; } #Include Python interpreter.
      // edf { name = "tcl"; enable = { buildNativeInputs = [tcl]; }; } #Include Tcl interpreter.
      // edf { name = "ruby"; feat = "rubyinterp"; enable = { buildNativeInputs = [ruby]; };} #Include Ruby interpreter.
      // edf { name = "lua" ; feat = "luainterp"; enable = { buildNativeInputs = [lua]; configureFlags = ["--with-lua-prefix=${args.lua}"];};}
      // edf { name = "cscope"; } #Include cscope interface.
      // edf { name = "workshop"; } #Include Sun Visual Workshop support.
      // edf { name = "netbeans"; } #Disable NetBeans integration support.
      // edf { name = "sniff"; feat = "sniff" ; } #Include Sniff interface.
      // edf { name = "multibyte"; } #Include multibyte editing support.
      // edf { name = "hangulinput"; feat = "hangulinput" ;} #Include Hangul input support.
      // edf { name = "xim"; } #Include XIM input support.
      // edf { name = "fontset"; } #Include X fontset output support.
      // edf { name = "acl"; } #Don't check for ACL support.
      // edf { name = "gpm"; } #Don't use gpm (Linux mouse daemon).
      // edf { name = "nls"; enable = {buildNativeInputs = [gettext];}; } #Don't support NLS (gettext()).
      ;

  cfg = {
    pythonSupport    = getConfig [ "vim" "python" ] true;
    darwinSupport    = getConfig [ "vim" "darwin" ] false;
    nlsSupport       = getConfig [ "vim" "nls" ] false;
    tclSupport       = getConfig [ "vim" "tcl" ] false;
    multibyteSupport = getConfig [ "vim" "multibyte" ] false;
    cscopeSupport    = getConfig [ "vim" "cscope" ] false;
    # add .nix filetype detection and minimal syntax highlighting support
    ftNixSupport     = getConfig [ "vim" "ftNix" ] true;
  };

  #--enable-gui=OPTS     X11 GUI default=auto OPTS=auto/no/gtk/gtk2/gnome/gnome2/motif/athena/neXtaw/photon/carbon
    /*
      // edf "gtk_check" "gtk_check" { } #If auto-select GUI, check for GTK default=yes
      // edf "gtk2_check" "gtk2_check" { } #If GTK GUI, check for GTK+ 2 default=yes
      // edf "gnome_check" "gnome_check" { } #If GTK GUI, check for GNOME default=no
      // edf "motif_check" "motif_check" { } #If auto-select GUI, check for Motif default=yes
      // edf "athena_check" "athena_check" { } #If auto-select GUI, check for Athena default=yes
      // edf "nextaw_check" "nextaw_check" { } #If auto-select GUI, check for neXtaw default=yes
      // edf "carbon_check" "carbon_check" { } #If auto-select GUI, check for Carbon default=yes
      // edf "gtktest" "gtktest" { } #Do not try to compile and run a test GTK program
    */

  postInstall = "
    rpath=`patchelf --print-rpath \$out/bin/vim`;
    for i in $\buildNativeInputs; do
      echo adding \$i/lib
      rpath=\$rpath:\$i/lib
    done
    echo \$buildNativeInputs
    echo \$rpath
    patchelf --set-rpath \$rpath \$out/bin/{vim,gvim}
  ";
  dontStrip =1;

  meta = {
    description = "The most popular clone of the VI editor";
    homepage = "www.vim.org";
  };

}
