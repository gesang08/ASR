# 1. number normalization
# 2. english text: full width to half width
for i in split_ac ; do
cat /home/asr/kaldi/egs/ASR_four/lm_text/$i | iconv -f utf-8 -t gbk | perl ../../src/normalize_number/mapper.pl | ../../src/normalize_number/reducer  | iconv -f gbk -t utf-8 > /home/asr/kaldi/egs/ASR_four/lm_text/$i.normed
done
