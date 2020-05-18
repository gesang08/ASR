## 概述
使用kaldi工具训练HMM-GMM模型，包括各种变换，使用chain/tdnn优化AM，使用通用LM+专用LM制作G.fst,
构建命令词识别模型及系统

## 内容列表
- 概述
- 内容列表
- 数据集
- 文件说明
- 工具

## 数据集
- speech_command_zh79：
  - 音频wav：32623个
  - 说话人：98个，文件按001-098编号
  - 命令词：79个
  - 频率：16KHz
  - train/dev/test划分：
    - train：001-079 090-098（28779个）；test：080-089（3844个）
    - train：001-069 090-098（25703个）; dev：070-079（3076个）；test：080-089（3844个）
- 755+aishell1+aishell2
  - 总体数据约1918小时
  - 该数据集用于训练通用AM
- 755测试集：
  - 2275
- 铁路场景测试集
  - 129

## 文件说明
1.s5/chinese_text_normalization
- TN：python3.x环境下，将含数字、小数点、百分号、日期等文本由数字转换成中文

    ```
    [sanghongbao@en-asr TN]$ sh run.sh
    text norm: 7 lines done in total.
    1,7c1,7
    < 这块黄金重达324.75克
    < 她出生于86年8月18日，她弟弟出生于1995年3月1日
    < 电影中梁朝伟扮演的陈永仁的编号27149
    < 现场有7/12的观众投出了赞成票
    < 随便来几个价格12块5，34.5元，20.1万
    < 明天有62％的概率降雨
    < 这是固话0421-33441122或这是手机+86 18544139121
    ---
    > 这块黄金重达三百二十四点七五克
    > 她出生于八六年八月十八日 她弟弟出生于一九九五年三月一日
    > 电影中梁朝伟扮演的陈永仁的编号二七一四九
    > 现场有十二分之七的观众投出了赞成票
    > 随便来几个价格十二块五 三十四点五元 二十点一万
    > 明天有百分之六十二的概率降雨
    > 这是固话零四二一三三四四一一二二或这是手机八六一八五四四一三九一二一
    ```
    
- ITN：invert text normalization，kaldi+thrax+python2.x环境下才能运行成功，将中文数字，百分号，日期等转成数字型
  
    ```
    [sanghongbao@en-asr grm]$ sh run.sh
    thraxcompiler --input_grammar=itn.grm --output_far=itn.far
    Evaluating rule: ITN
    Input string: Output string: 6778
    Input string: Output string: 7880
    Input string: Output string: 8889
    Input string: Output string: 9990
    Input string: Output string: 9991
    Input string: Output string: 2019年9月12日
    Input string: Output string: 2005年8月5号
    Input string: Output string: 85年2月27日
    Input string: Output string: 公元163年
    Input string: Output string: 06年1月2号
    Input string: Output string: 有62%的人认为
    ```
2.s5下conf、local、util、cmd.sh、path.sh、run.sh都是训练需要的文件
3.s5下extract_feat.sh、plx_tool是特征辅助、拆成字char等工具
4.hw-ofst thrax语法.grm示例文件与工具 来自http://cs.jhu.edu/~jason/465/hw-ofst 注意：这里面有个工具bin/far2fst是thrax编写规则后，将.far转成.fst的工具
 
## 工具
- kaldi 语音识别工具
- thrax 编写专用LM之G.fst规则工具
- python kaldi里面用的是python2.x
- tmux 终端复用工具
- bashdb shell脚本调试器 

