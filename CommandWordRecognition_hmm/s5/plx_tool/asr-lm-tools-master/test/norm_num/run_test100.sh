# 1. number normalization
# 2. english text: full width to half width
cat test_100 | iconv -f utf-8 -t gbk | perl ../../src/normalize_number/mapper.pl | ../../src/normalize_number/reducer  | iconv -f gbk -t utf-8 > test_100.normed
