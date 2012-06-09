addPythonPath() {
    addToSearchPathWithCustomDelimiter : PYTHONPATH $1/lib/python2.7/site-packages
}

# deprecated, use addPythonSite instead
toPythonPath() {
    echo toPythonPath is deprecated, use addPythonSite instead! # deprecated, use addPythonSite instead
    exit 1 

    # local paths="$1"
    # local result=
    # for i in $paths; do
    #     p="$i/lib/python2.7/site-packages"
    #     result="${result}${result:+:}$p"
    # done
    # echo $result
}

declare SEEN=::

addPythonSite(){
  # looks like it has python libraries ?
  g="$1/lib/python2.7"
  if [ "$SEEN" == "${SEEN/:$1:/}" ]; then
    SEEN="$SEEN:$1:" 
    export NIX_PYTHON_SITES=${NIX_PYTHON_SITES}${NIX_PYTHON_SITES:+:}$1
  fi
}

envHooks=(${envHooks[@]} addPythonSite)
