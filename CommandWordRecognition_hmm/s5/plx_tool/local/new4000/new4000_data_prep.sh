#!/bin/bash

# Copyright 2017 Xingyu Na
# Apache 2.0

. ./path.sh || exit 1;

if [ $# != 2 ]; then
  echo "Usage: $0 <audio-path> <text-path>"
  echo " $0 /export/a05/xna/data/data_aishell/wav /export/a05/xna/data/data_aishell/transcript"
  exit 1;
fi

audio_dir=$1
text=$2

train_dir=data/local/train_new4000

mkdir -p $train_dir

# data directory check
if [ ! -d $audio_dir ] || [ ! -f $text ]; then
  echo "Error: $0 requires two directory arguments"
  #exit 1;
fi

# find wav audio file for train, dev and test resp.
find $audio_dir -iname "*.wav" |sort -u > $train_dir/wav.flist
n=`cat $train_dir/wav.flist | wc -l`
m=`cat $text |wc -l`
echo `total wav number is $n`
echo `total text number is $n` 

cp $text $train_dir

# Transcriptions preparation

for dir in $train_dir; do
  echo Preparing $dir transcriptions
  sed -e 's/\.wav//' $dir/wav.flist | awk -F '/' '{print $NF}' | sed 's/ZF_ASR_zh_//g' > $dir/utt.list
  cat $dir/utt.list  >$dir/spk.list
  paste -d ' ' $dir/utt.list $dir/spk.list >$dir/utt2spk_all
  paste -d ' ' $dir/utt.list $dir/wav.flist > $dir/wav.scp_all
  #utils/filter_scp.pl -f 1 $dir/utt.list $aishell_text > $dir/transcripts.txt
  sed -e 's/\.wav//' $dir/wav_label.txt | awk '{print $1}' | awk -F '/' '{print $NF}' |sed 's/ZF_ASR_zh_//g' > $dir/utt.list
  utils/filter_scp.pl -f 1 $dir/utt.list $dir/utt2spk_all |sort -u > $dir/utt2spk
  utils/filter_scp.pl -f 1 $dir/utt.list $dir/wav.scp_all |sort -u > $dir/wav.scp
  sed -e 's/\.wav//' $dir/wav_label.txt |sed 's/wav\/ZF_ASR_zh_//g'|sort -u > $dir/text
  utils/utt2spk_to_spk2utt.pl $dir/utt2spk > $dir/spk2utt
done

mkdir -p data/train_new4000 

for f in spk2utt utt2spk wav.scp text; do
  cp $train_dir/$f data/train_new4000/$f || exit 1;
done

echo "$0: new4000 data preparation succeeded"
exit 0;
