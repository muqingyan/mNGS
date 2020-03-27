#create Bracken DB using the Kraken DB 
kraken2="/path/to/kraken2"
Bracken="/path/to/bracken"
krakenDb="/path2DB"
python="/path2python2"
kmer_distribution="/path2the_python_script"
lineage_perl="/path2theperl_scipt"
${kraken2} --db ${krakenDB} --thread 40 *.fna --report *.report.txt  --report-zero-counts > *.kraken.counts

${Bracken} --seqid2taxid */seqid2taxid.map \
	--taxonomy /taxonomy/ --kraken *.kraken.counts \
	--output *.kraken_cnts -l 150 -t 40 -k 35 && 
	
python ${kmer_distribution} -i ×.kraken_cnts -o hs37d5.KMER150_DISTR.TXT

awk -F "\t" '{print $4"\t"$5"\t"$6}'  FBVPA.all.report.txt > FBVPA.all.taxonomy.level.txt
perl ${lineage_perl} -r FBVPA.all.report.txt > FBVPA.all.taxonomy.lineage.txt
