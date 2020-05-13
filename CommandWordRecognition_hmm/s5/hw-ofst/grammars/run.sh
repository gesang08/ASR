#!/bin/bash

mode=$1
grm=$2
rule=$3
delgrm=${grm:0:(${#grm}-4)}

thraxmakedep $2
make

if [[ $mode -eq 0 ]];then
    thraxrewrite-tester --far=$delgrm.far --rules=$rule
else 
    cat testbyte | thraxrewrite-tester --far=$delgrm.far --rules=$rule >test
    cat test
fi

