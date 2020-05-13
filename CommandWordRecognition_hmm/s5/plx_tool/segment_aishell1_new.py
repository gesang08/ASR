#!/user/bin/env python
# Usage: cat file | python segment.py

import sys
import jieba
jieba.load_userdict("aishell1.count")

for line in sys.stdin:
	seg_list = jieba.cut(line, cut_all=False, HMM=False)
	seg_list_tolist = list(seg_list)
	for word in seg_list_tolist:
		sys.stdout.write(' '+word.encode('utf-8'))
