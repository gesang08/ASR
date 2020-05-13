#!/bin/bash

# Copyright 2017 Xingyu Na
# Apache 2.0

. ./path.sh || exit 1;

if [ $# != 2 ]; then
  echo "Usage: $0 <audio-path> <text-path>"
  echo " $0 /export/a05/xna/data/data_aishell/wav /export/a05/xna/data/data_aishell/transcript"
  exit 1;
fi

aishell_audio_dir=$1
aishell_text=$2

train_dir=data/local/train
dev_dir=data/local/dev
test_dir=data/local/test
tmp_dir=data/local/tmp

mkdir -p $train_dir
mkdir -p $dev_dir
mkdir -p $test_dir
mkdir -p $tmp_dir

# data directory check
if [ ! -d $aishell_audio_dir ] || [ ! -f $aishell_text ]; then
  echo "Error: $0 requires two directory arguments"
  #exit 1;
fi

# find wav audio file for train, dev and test resp.
find $aishell_audio_dir -iname "*.wav" > $tmp_dir/wav.flist
n=`cat $tmp_dir/wav.flist | wc -l`
[ $n -ne 531094 ] && \
  echo Warning: expected 531094 data data files, found $n

grep -i "wav/train" $tmp_dir/wav.flist |sort > $train_dir/wav.flist || exit 1;
grep -i "wav/dev" $tmp_dir/wav.flist |sort > $dev_dir/wav.flist || exit 1;
grep -i "wav/test" $tmp_dir/wav.flist |sort > $test_dir/wav.flist || exit 1;

rm -r $tmp_dir
cp $aishell_text/train/remove_text_new $train_dir
cp $aishell_text/dev/remove_text_new $dev_dir
cp $aishell_text/test/remove_text_new $test_dir

# Transcriptions preparation

for dir in $train_dir $dev_dir $test_dir; do
  echo Preparing $dir transcriptions
  sed -e 's/\.wav//' $dir/wav.flist | awk -F '/' '{print $(NF-1)"_"$NF}' |sed 's/Speaker/speaker_/g'> $dir/utt.list
  cat $dir/utt.list | awk -F '_' '{print $1$2}'  >$dir/spk.list
  paste -d ' ' $dir/utt.list $dir/spk.list >$dir/utt2spk_all
  paste -d ' ' $dir/utt.list $dir/wav.flist > $dir/wav.scp_all
  #utils/filter_scp.pl -f 1 $dir/utt.list $aishell_text > $dir/transcripts.txt
  awk '{print $1}' $dir/remove_text_new > $dir/utt.list
  utils/filter_scp.pl -f 1 $dir/utt.list $dir/utt2spk_all |sort -u > $dir/utt2spk
  utils/filter_scp.pl -f 1 $dir/utt.list $dir/wav.scp_all |sort -u > $dir/wav.scp
  sort -u $dir/remove_text_new > $dir/text
  utils/utt2spk_to_spk2utt.pl $dir/utt2spk > $dir/spk2utt
done

mkdir -p data/train data/dev data/test

for f in spk2utt utt2spk wav.scp text; do
  cp $train_dir/$f data/train/$f || exit 1;
  cp $dev_dir/$f data/dev/$f || exit 1;
  cp $test_dir/$f data/test/$f || exit 1;
done

echo "$0: 051 data preparation succeeded"
exit 0;
