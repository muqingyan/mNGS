# mNGS_mysql

### Introduction
A suite of scripts to update the mNGS database in the MySql DB.
The pipeline is managed by SnakeMake
### Steps
#### Step 1：prepare staxid_list 
This list should include all the desired species taxid
#### Step 2：modify the configure file (conf_mysql.ini)
 [version] version
 [input] staxid_list 
 [output] rep_micro_dir 
 [ncbi_summary_file] 
 [oldmysql] old_assm_select
Make other modifications accordingly
#### Step 3: test run
a.snakemake -s mNGS_pipeline_mysql_update.snakemake -np command, run the following rules：
	1. rule staxid_update 
	2. rule assm_select_part1 
b. check logs_DIR:staxid_update.{version}.err.log and assm_select_part1_{version}.err.log 
#### Step 4: formal run
 snakemake -s mNGS_pipeline_mysql_update.py -p
