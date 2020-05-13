# 1. number normalization
# 2. english text: full width to half width
filename=$1
cat $filename | iconv -f utf-8 -t gbk | perl ../../src/normalize_number/mapper.pl | ../../src/normalize_number/reducer  | iconv -f gbk -t utf-8 > out
