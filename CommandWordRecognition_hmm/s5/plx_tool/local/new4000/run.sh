#!/bin/bash

. ./cmd.sh
. ./path.sh

data=/home/panlixin/share/20190208_new_asr_data/sample
# Data Preparation,
./new4000_data_prep.sh $data/wav $data/wav_label.txt || exit 1;

# Now make features.

./new4000_feats_extract.sh || exit 1;

