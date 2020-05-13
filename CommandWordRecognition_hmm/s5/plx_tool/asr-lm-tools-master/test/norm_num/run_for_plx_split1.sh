# 1. number normalization
# 2. english text: full width to half width
#for i in split_aa split_ab split_ac split_ad split_ae split_af split_ag; do
cat /home/asr/kaldi/egs/ASR_four/lm_text/split_aa | iconv -f utf-8 -t gbk | perl ../../src/normalize_number/mapper.pl | ../../src/normalize_number/reducer  | iconv -f gbk -t utf-8 > /home/asr/kaldi/egs/ASR_four/lm_text/split_aa.normed
#done
