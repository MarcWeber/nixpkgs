s|apk_zip.write(os.path.join(lib_source_dir, fname), lib_dest_dir + fname)|info = zipfile.ZipInfo(lib_dest_dir + fname)\n\t\t\t\t\tinfo.compress_type = zipfile.ZIP_DEFLATED\n\t\t\t\t\tinfo.create_system = 3\n\t\t\t\t\tf = open(os.path.join(lib_source_dir, fname))\n\t\t\t\t\tapk_zip.writestr(info, f.read())\n\t\t\t\t\tf.close()|
