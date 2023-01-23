#!/bin/bash

if [ -n "${V}" ]; then
	set -x
fi
set -eu

SPHINX_WRAPPER="`readlink -f "$0"`"

root="`dirname "$SPHINX_WRAPPER"`"

name=$(basename $0)

root=${root%/usr/bin}

# set the LD_LIBRARY_PATH, but preserve it's original value
if [ -n "${LD_LIBRARY_PATH+x}" ]; then
	LD_LIBRARY_PATH=${root}/usr/lib:${LD_LIBRARY_PATH}
else
	LD_LIBRARY_PATH=${root}/usr/lib
fi
export LD_LIBRARY_PATH

# Use exec so the current shell is *replaced* (same PID) by the process below.
# This way, the signals sent to this script are received by the new process.
exec ${root}/usr/bin/${name} "$@"
