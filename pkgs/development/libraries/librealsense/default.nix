{ stdenv, fetchFromGitHub, cmake, libusb1, ninja, pkgconfig, example_deps, buildExamples, pkgs, python }:

/* It would be better to compile wrappers indepdendently but for Python wrapper
   some cmake $BACKEND problems occur (TODO)

   I couldn't make the pip packgae compile either.
*/

stdenv.mkDerivation rec {
  pname = "librealsense";
  version = "2.36.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "IntelRealSense";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dfkhnybnd8qnljf3y3hjyamaqzw733hb3swy4hjcsdm9dh0wpay";
  };

  enableParalellBuilding = true;

  buildInputs = [
    libusb1
  ] ++ pkgs.lib.optionals buildExamples (builtins.attrValues example_deps);

  nativeBuildInputs = [
    cmake
    ninja
    pkgconfig
  ];

  cmakeFlags = [ 
''-DBUILD_EXAMPLES=${if buildExamples then "true" else "false"}''
] ++ pkgs.lib.optionals (python != null) [
''-DBUILD_PYTHON_BINDINGS=bool:true''
''-DPYTHON_EXECUTABLE=${python}/bin/python''
];

  # copy udev rules to $out
  # fix executable paths in udev rules and copy them to $udev_bins_path
  postInstall = ''
  cd ..
  mkdir -p $out/lib/udev/rules.d
  udev_bins_path=$out/udev-bins
  mkdir -p $udev_bins_path
  cp -ra config/{usb-R200-in,usb-R200-in_udev} $udev_bins_path
  sed -i 's@/bin/bash@/bin/sh@' $udev_bins_path/*
  chmod +x $udev_bins_path/*
  cp config/99-realsense-libusb.rules $out/lib/udev/rules.d/99-realsense-libusb.rules
  sed -i -e "s@/usr/local/bin/\\(usb-R200-in_udev\\|usb-R200-in\\)@$udev_bins_path/\\1@" -e "s@/bin/sh@$(type -p sh)@" $udev_bins_path/* $out/lib/udev/rules.d/99-realsense-libusb.rules

  ${pkgs.lib.optionalString (python != null) ''

  sp=$out/lib/${python.libPrefix}/site-packages
  mkdir -p $sp

  cp -ra wrappers/python/pyrealsense2 $sp/
  cp -ra build/wrappers/python/*.so.* $sp/pyrealsense2
  for i in $out/lib/*.so; do
    ln -s $i $sp/pyrealsense2 || true
  done

  mkdir -p $out/examples
  cp -ra wrappers/python/examples $out/examples/python
  ''}
  '';

  meta = with stdenv.lib; {
    description = "A cross-platform library for Intel® RealSense™ depth cameras (D400 series and the SR300)";
    homepage = "https://github.com/IntelRealSense/librealsense";
    license = licenses.asl20;
    maintainers = with maintainers; [ brian-dawn ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
