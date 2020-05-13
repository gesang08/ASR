hpath='/usr/hadoop-0.20.2-cdh3u4/contrib/streaming/hadoop-streaming-0.20.2-cdh3u4.jar'
hadoop jar $hpath \
-Dmapred.job.name="convert number" \
-Ddfs.block.size=67108864 \
-input "/fengyukun/parsed/meizu_corpus" \
-output "/fengyukun/parsed/meizu_numconv" \
-numReduceTasks 100 \
-mapper "perl mapper.pl" \
-reducer "reducer" \
-file mapper.pl \
-file reducer \
-file add_vocab.txt \
-file del_vocab.txt \
-file Lemma.lex \
-file lexi \
-file SMRule.lex \
-jobconf stream.map.output.field.separator=""
