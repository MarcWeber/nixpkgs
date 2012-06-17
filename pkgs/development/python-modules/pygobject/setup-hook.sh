postInstall="
$postInstall
"'
# is run last
# adds a .pth file so that gtk-2.0/* packgaes are found.
# nowadays gtk-1.0 is no logner used thus packages like matplotlib expect
# "require gtk" to work (similar for pygnome)
for p in $out/lib/python*/site-packages/gtk-*/; do
  echo "$p" > $(dirname "$p")/sth.pth
done
'
