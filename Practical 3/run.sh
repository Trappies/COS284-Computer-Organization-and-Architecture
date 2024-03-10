#! /bin/bash

# redirect all the compile output to stderr and stop if the compile step fails
make 1>&2 > /dev/null
compiled=$?

if [[ $compiled -ne 0 ]]; then
    echo "COMPILE FAILED"
    exit $compiled
fi

# execute the compiled binary and redirect all output to stdout

make run 2>&1
make clean  2>&1 > /dev/null