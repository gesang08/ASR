#!/bin/bash
. ./cmd.sh
. ./path.sh


# G compilation, check LG composition
utils/format_lm.sh data/lang data/local/lm4_mid_pr/srilm.0.92e-8.gz \
    data/local/dict/lexicon.txt data/lang_test_lm4_mid_pr || exit 1;

dir=exp/chain/tdnn_1a_sp
stage=0
if [ $stage -le 0 ]; then
  # Note: it might appear that this $lang directory is mismatched, and it is as
  # far as the 'topo' is concerned, but this script doesn't read the 'topo' from
  # the lang directory.
  #utils/mkgraph.sh --self-loop-scale 1.0 data/lang_test_teacherwang_lm5  $dir $dir/graph_lm5
  utils/mkgraph.sh --self-loop-scale 1.0 data/lang_test_lm4_mid_pr  $dir $dir/graph_lm4_mid_pr
 # utils/mkgraph.sh --self-loop-scale 1.0 data/lang_test_teacherwang_lm5_10  $dir $dir/graph_lm5_10
fi

if [ $stage -le 1 ]; then
  graph_dir=$dir/graph_lm4_mid_pr
  for test_set in test_051 test_500chonglang; do
    steps/nnet3/decode.sh --acwt 1.0 --post-decode-acwt 10.0 \
      --nj 4 --cmd "$decode_cmd" \
      --online-ivector-dir exp/nnet3/ivectors_$test_set \
      $graph_dir data/${test_set}_hires_online $dir/decode_${test_set}_lm4_mid_pr || exit 1;
  done
fi

