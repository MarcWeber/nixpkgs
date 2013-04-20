make_gobject_introspection_find_gir_files() {
    # this should work, but transformer.py does not honor it:
    addToSearchPath GI_TYPELIB_PATH $1

    # but it does read XDG_DATA_DIRS, so also set that
    addToSearchPath XDG_DATA_DIRS $1/share
}

envHooks+=(make_gobject_introspection_find_gir_files)
