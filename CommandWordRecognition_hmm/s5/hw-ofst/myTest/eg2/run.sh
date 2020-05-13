#!/bin/bash

mode=$1
grm=$2
rule=$3
delgrm=${grm:0:(${#grm}-4)}

thraxmakedep $2
make

if [[ $mode -eq 0 ]];then
    thraxrewrite-tester --far=$delgrm.far --noutput=100 --rules=$rule
else 
    cat split_word_oov | thraxrewrite-tester --far=$delgrm.far --input_mode=words.txt --output_mode=words.txt --noutput=100 --rules=$rule >test
    cat test
fi

