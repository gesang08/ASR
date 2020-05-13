dataset:
    The dataset is provided by huiyan technology company.
    It can be used to kws or wake-up or command word recognition or etc.
    The dataset is used to command word recognition now.

    attr:
    command word -- 79
    speaker -- 98
    wav and label -- 32623
    file -- 001-098
    
    train/dev/test:
    1.train -- 001-079 and 090-098; test -- 080-089
    2.train -- 001-069 and 090-098; dev --070-079

recipe:
    HMM传统方法，训练出final.mdl，得到HCLG.fst
    e2e端到端方法，训练得到.h5模型

tool:
    kaldi
    thrax
    tensorfolw
    python
    tmux
    pudb
    bashdb
    anaconda
    .etc.
    

