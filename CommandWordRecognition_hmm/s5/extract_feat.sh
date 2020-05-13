#!/bin/bash

# 抽取特征上层脚本

# 数据上层目录
data=kws_data
stage=0

subdata="test"  # subdata="train train_sp dev test"

# 激活cmd.sh和path.sh文件
. cmd.sh
. path.sh



# 特征提取需要wav.scp、utt2spk、spk2utt三个文件
local/kws_data_prep.sh $data/wav $data/text69.txt || exit 1;  # 注意：1.kws_data_prep.sh处理了train和test两个；2.新的数据集标签$2需要修改

# 提取pitch特征
if [ $stage -le -2 ];then
    mfccdir=mfcc79 # 特征结果存放目录
    for x in $subdata; do
        steps/make_mfcc_pitch.sh --cmd "$train_cmd" --nj 10 data/$x exp/make_mfcc/$x $mfccdir || exit 1; # 提取mfcc特征，需要修改此处
        steps/compute_cmvn_stats.sh data/$x exp/make_mfcc/$x $mfccdir || exit 1;
        utils/fix_data_dir.sh data/$x || exit 1;
    done
fi

# 提取pitch和nopitch特征
if [ $stage -le 3 ];then
    mfccdir=mfcc_perturbed_hires69
    for datadir in $subdata; do
        utils/copy_data_dir.sh data/$datadir data/${datadir}_hires
    done

    for datadir in $subdata; do
        steps/make_mfcc_pitch.sh --cmd "$train_cmd" --nj 10 --mfcc-config conf/mfcc_hires.conf \
            data/${datadir}_hires exp/make_hires/$datadir $mfccdir || exit 1;
        steps/compute_cmvn_stats.sh data/${datadir}_hires exp/make_hires/$datadir $mfccdir || exit 1;
        utils/fix_data_dir.sh data/${datadir}_hires || exit 1;
        
        # create MFCC data dir without pitch to extract iVector
        utils/data/limit_feature_dim.sh 0:39 data/${datadir}_hires data/${datadir}_hires_nopitch || exit 1;
        steps/compute_cmvn_stats.sh data/${datadir}_hires_nopitch exp/make_hires/$datadir $mfccdir || exit 1;
    done
fi
    
