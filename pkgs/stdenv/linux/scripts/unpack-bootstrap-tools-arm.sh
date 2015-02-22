set -e

# Unpack the bootstrap tools tarball.
echo Unpacking the bootstrap tools...
$builder mkdir $out
< $tarball $builder unxz | $builder tar x -C $out

# Set the ELF interpreter / RPATH in the bootstrap binaries.
echo Patching the bootstrap tools...

# On x86_64, ld-linux-x86-64.so.2 barfs on patchelf'ed programs.  So
# use a copy of patchelf.
LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? $out/bin/cp $out/bin/patchelf .

for i in $out/bin/* $out/libexec/gcc/*/*/* $out/lib/librt*; do
    if test ${i%.la} != $i; then continue; fi
    if test ${i%*.so*} != $i; then continue; fi
    if ! test -f $i; then continue; fi
    if test -L $i; then continue; fi
    echo patching $i
    LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? \
        $out/bin/patchelf --set-interpreter $out/lib/ld-linux*.so.? --set-rpath $out/lib --force-rpath $i
    LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? \
        $out/bin/patchelf --set-interpreter $out/lib/ld-linux*.so.? --set-rpath $out/lib --force-rpath $i
done
for i in $out/lib/librt* $out/lib/libcloog* $out/lib/libppl* $out/lib/libgmp* $out/lib/libpcre*; do
    if ! test -f $i; then continue; fi
    if test -L $i; then continue; fi
    echo patching $i
    LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? \
        $out/bin/patchelf --set-rpath $out/lib --force-rpath $i
    LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? \
        $out/bin/patchelf --set-rpath $out/lib --force-rpath $i
done

# Fix the libc linker script.
export PATH=$out/bin
cat $out/lib/libc.so | sed "s|/nix/store/e*-[^/]*/|$out/|g" > $out/lib/libc.so.tmp
mv $out/lib/libc.so.tmp $out/lib/libc.so
cat $out/lib/libpthread.so | sed "s|/nix/store/e*-[^/]*/|$out/|g" > $out/lib/libpthread.so.tmp
mv $out/lib/libpthread.so.tmp $out/lib/libpthread.so

# Provide some additional symlinks.
ln -s bash $out/bin/sh
ln -s bzip2 $out/bin/bunzip2

# Provide a gunzip script
cat > $out/bin/gunzip <<EOF
#!$out/bin/sh
exec $out/bin/gzip -d "\$@"
EOF
chmod +x $out/bin/gunzip

# Provide fgrep/egrep.
echo "#! $out/bin/sh" > $out/bin/egrep
echo "exec $out/bin/grep -E \"\$@\"" >> $out/bin/egrep
echo "#! $out/bin/sh" > $out/bin/fgrep
echo "exec $out/bin/grep -F \"\$@\"" >> $out/bin/fgrep

# Provide xz (actually only xz -d will work).
echo "#! $out/bin/sh" > $out/bin/xz
echo "exec $builder unxz \"\$@\"" >> $out/bin/xz

chmod +x $out/bin/egrep $out/bin/fgrep $out/bin/xz
