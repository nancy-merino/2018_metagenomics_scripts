#!/bin/bash
#  run.sh
#  
#
#  Version 1. Created by Nancy Merino.
#

source setup.sh # this file calls all the necessary software
export WORKDIR=<input working directory path>
export run_wd=${WORKDIR}/code
export date=180602
export log_wd=${run_wd}/logs_${date}
source ${run_wd}/prefs.conf

mkdir -p ${outdir_fastqc} ${outdir_trim} ${outdir_spades} ${outdir_bbnorm} ${outdir_mega} ${outdir_quast} ${outdir_bowtie} ${outdir_metabat} ${outdir_checkm} ${outdir_anvio} ${log_wd} ${outdir_anvio_01} ${outdir_anvio_02} ${outdir_anvio_03} ${outdir_anvio_04} ${outdir_anvio_05} ${outdir_anvio_05b} ${outdir_anvio_06} ${outdir_anvio_06b} 

# Unpound lines that you want to run below

#========= PART I ================
#if your sample not in folder, you can run 01a.organize_sample.sh
#${run_wd}/01a.organize_sample.sh 

#${run_wd}/01.fastqc.sh 2>&1 | tee -a ${log_wd}/01.fastqc.txt

#${run_wd}/02.trimmomatic.sh 2>&1 | tee -a ${log_wd}/02.trimmomatic.txt

#${run_wd}/03.fastqc2.sh 2>&1 | tee -a ${log_wd}/03.fastqc2.txt

#### Make sure trimmed fasta file is ok before moving on

#========= PART II ===============

#${run_wd}/04.optional.bbnorm.sh 2>&1 | tee -a ${log_wd}/04.bbnorm.txt

#${run_wd}/05.metaspades.sh 2>&1 | tee -a ${log_wd}/05.metaspades.txt

#${run_wd}/06.megahit.sh 2>&1 | tee -a ${log_wd}/06.megahit.txt

#${run_wd}/07.quast.sh  2>&1 | tee -a ${log_wd}/07.quast.txt

####Choose the best assembly before moving on. You can also visualize assembly by using Bandage software (https://rrwick.github.io/Bandage/)

#========= PART III ===============
#${run_wd}/08.bowtie2.sh 2>&1 | tee -a ${log_wd}/08.bowtie2.txt

#${run_wd}/09.metabat.sh 2>&1 | tee -a ${log_wd}/09.metabat.txt

#checkm needs at least 64GB memory, 40 threads, 32 cores
#${run_wd}/10.checkm.sh 2>&1 | tee -a ${log_wd}/10.checkm.txt

####Choose the best bins before moving on. You can also try other binning software (e.g. MyCC, ESOM). Anvi'o uses CONCOCT binning

#========= PART IV ===============
#${run_wd}/11.anvio1.sh 2>&1 | tee -a ${log_wd}/11.anvio1.txt

#${run_wd}/12.kaiju.sh 2>&1 | tee -a ${log_wd}/12.kaiju.txt
##If Kaiju has error "32033 Killed", try to reduce the number of other jobs going on at the same time or reduce memory of the jobs. 

#${run_wd}/13.interproscan.sh 2>&1 | tee -a ${log_wd}/13.interproscan.txt

##----run these two scripts if you have only one sample
#${run_wd}/14a.anvio2_one_sample.sh 2>&1 | tee -a ${log_wd}/14a.anvio2_one_sample.txt
#${run_wd}/14b.anvio2_one_sample_import_bins.sh 2>&1 | tee -a ${log_wd}/14b.anvio2_one_sample_import_bins.txt

##----run these three scripts if you have more than one sample that you want to merge profiles together
#${run_wd}/15a.anvio2_multiple_samples.sh 2>&1 | tee -a ${log_wd}/15a.anvio2_multiple_samples.txt
##do not run until have all individual profiles made 
#${run_wd}/15b.anvio2_multiple_samples_merge.sh 2>&1 | tee -a ${log_wd}/15b.anvio2_multiple_samples_merge.txt
#${run_wd}/15c.anvio2_multiple_samples_import_bins.sh 2>&1 | tee -a ${log_wd}/15c.anvio2_multiple_samples_import_bins.txt

#${run_wd}/16.emapper_annotation.sh 2>&1 | tee -a ${log_wd}/16.emapper_annotation.txt

####PIPELINE FINISHED; type anvi- and press tab 2x to see other anvio scripts available (e.g. anvi-export-contigs)
