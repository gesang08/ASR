#!/bin/bash
if [ $# -ne 5 ];then
    echo "Usage: $0 <mode> <grm_file> <rule> <test_file> <result_file>"
    echo "e.g.: [sh | bash] $0 1 number.grm NUMBER test testRes"
    exit 1;
fi

mode=$1  # 0:单一测试,1:集中测试,2:集中测试+产生.fst图文件
grm=$2
rule=$3
test=$4
testRes=$5

prefixgrm=${grm:0:(${#grm}-4)}  # 去除.grm，例如去除byte.grm为byte

if [ -e $prefixgrm.far ];then
    rm $prefixgrm.far
    echo "delete $prefixgrm.far"
fi
if [ -e $rule.fst ];then
    rm $rule.fst
    echo "delete $rule.fst"
fi
if [ -e $rule.dot ];then
    rm $rule.dot
    echo "delete $rule.dot"
fi
if [ -e $rule.pdf ];then
    rm $rule.pdf
    echo "delete $rule.pdf"
fi

thraxmakedep $grm
make

if [[ $mode -eq 0 ]];then
    thraxrewrite-tester --far=$prefixgrm.far --input_mode=words.sym --output_mode=words.sym  --noutput=100 --rules=$rule
    #thraxrewrite-tester --far=$prefixgrm.far --input_mode="byte" --output_mode="byte" --noutput=100 --rules=$rule
else
   # 测试时，输入编码和输出编码均为符号表word.sym 
    cat $test | thraxrewrite-tester --far=$prefixgrm.far  --input_mode=words.sym --output_mode=words.sym \
        --noutput=100 --rules=$rule >res
    cut -d" " -f 1,2 res >tmp1
    cut -d" " -f 3- res >tmp2
    paste -d" " tmp1 $test tmp2 >$testRes
    rm res tmp1 tmp2
    #cat call.txt | thraxrewrite-tester --far=$prefixgrm.far --noutput=100 --rules=$rule >test
    cat $testRes
    far2fst $prefixgrm.far  # 得到rule.fst
    if [[ $mode -eq 2 ]];then
        fstdraw --isymbols=words.sym --osymbols=words.sym $rule.fst $rule.dot
        #fstdraw $rule.fst $rule.dot
        dot -Tpdf $rule.dot >$rule.pdf
        scp -r $rule.pdf panlixin@211.81.55.142:/home/2017/panlixin/gesang/
    fi
fi

