{ stdenv, fetchurl, pkgconfig, yasm, zlib, bzip2
, mp3Support ? true, lame ? null
, speexSupport ? true, speex ? null
, theoraSupport ? true, libtheora ? null
, vorbisSupport ? true, libvorbis ? null
, vpxSupport ? false, libvpx ? null
, x264Support ? true, x264 ? null
, xvidSupport ? true, xvidcore ? null
, vdpauSupport ? true, libvdpau ? null
, faacSupport ? true, faac ? null
, dc1394Support ? false, libdc1394 ? null
, x11grabSupport ? true, libX11, libXext, libXfixes
, versionedDerivation, version ? "0.10"
}:

assert speexSupport -> speex != null;
assert theoraSupport -> libtheora != null;
assert vorbisSupport -> libvorbis != null;
assert vpxSupport -> libvpx != null;
assert x264Support -> x264 != null;
assert xvidSupport -> xvidcore != null;
assert vdpauSupport -> libvdpau != null;
assert faacSupport -> faac != null;

versionedDerivation "ffpmeg" version {

  "0.10" = rec {
    name = "ffmpeg-0.10";

    src = fetchurl {
      url = "http://www.ffmpeg.org/releases/${name}.tar.bz2";
      sha256 = "1ybzw6d5axr807141izvm2yf4pa0hc1zcywj89nsn3qsdnknlna3";
    };
  };

  "git" = {
    # REGION AUTO UPDATE: { name="ffmpeg"; type="git"; url="git://source.ffmpeg.org/ffmpeg.git"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/ffmpeg-git-a72bf.tar.bz2"; sha256 = "c378fe417e5a014af30190850b71b70ae4f29a17f8f8645b6e9c846bfcd77ae2"; });
    name = "ffmpeg-git-a72bf";
    # END
  };

} (rec {

  # `--enable-gpl' (as well as the `postproc' and `swscale') mean that
  # the resulting library is GPL'ed, so it can only be used in GPL'ed
  # applications.
  configureFlags = [
    "--enable-gpl"
    "--enable-postproc"
    "--enable-swscale"
    "--disable-ffplay"
    "--enable-shared"
    "--enable-runtime-cpudetect"
  ]
    ++ stdenv.lib.optional mp3Support "--enable-libmp3lame"
    ++ stdenv.lib.optional speexSupport "--enable-libspeex"
    ++ stdenv.lib.optional theoraSupport "--enable-libtheora"
    ++ stdenv.lib.optional vorbisSupport "--enable-libvorbis"
    ++ stdenv.lib.optional vpxSupport "--enable-libvpx"
    ++ stdenv.lib.optional x264Support "--enable-libx264"
    ++ stdenv.lib.optional xvidSupport "--enable-libxvid"
    ++ stdenv.lib.optional vdpauSupport "--enable-vdpau"
    ++ stdenv.lib.optional faacSupport "--enable-libfaac --enable-nonfree"
    ++ stdenv.lib.optional dc1394Support "--enable-libdc1394"
    ++ stdenv.lib.optional x11grabSupport "--enable-x11grab";

  buildInputs = [ pkgconfig lame yasm zlib bzip2 ]
    ++ stdenv.lib.optional mp3Support lame
    ++ stdenv.lib.optional speexSupport speex
    ++ stdenv.lib.optional theoraSupport libtheora
    ++ stdenv.lib.optional vorbisSupport libvorbis
    ++ stdenv.lib.optional vpxSupport libvpx
    ++ stdenv.lib.optional x264Support x264
    ++ stdenv.lib.optional xvidSupport xvidcore
    ++ stdenv.lib.optional vdpauSupport libvdpau
    ++ stdenv.lib.optional faacSupport faac
    ++ stdenv.lib.optional dc1394Support libdc1394
    ++ stdenv.lib.optionals x11grabSupport [libX11 libXext libXfixes];

  enableParallelBuilding = true;
    
  crossAttrs = {
    dontSetConfigureCross = true;
    configureFlags = configureFlags ++ [
      "--cross-prefix=${stdenv.cross.config}-"
      "--enable-cross-compile"
      "--target_os=linux"
      "--arch=${stdenv.cross.arch}"
      ];
  };

  passthru = {
    inherit vdpauSupport;
  };

  meta = with stdenv.lib; {
    homepage    = http://www.ffmpeg.org/;
    description = "A complete, cross-platform solution to record, convert and stream audio and video";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
})
