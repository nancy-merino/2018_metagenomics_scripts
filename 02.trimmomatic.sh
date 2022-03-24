#!/bin/bash

#  02.trimmomatic.sh
#
#
#  Created by Nancy Merino on 7/25/17.
#

mkdir -p ${outdir_trim}/${sample}

echo -e "$(tput setaf 2)\n ==== Now running TRIMMOMATIC${trimmomatic_version} for paired-end reads (Please see manual for single-end reads) ==== \n$(tput sgr0)"

echo -e "$(tput setaf 2)\n ==== Now running TRIMMOMATIC${trimmomatic_version} on ${sample} ==== \n$(tput sgr0)"

java -jar ${TRIMMOMATIC}trimmomatic-0.36.jar PE -phred33 -threads ${np} \
${outdir_rawfiles}/${sample}/${raw_fastq_name_R1}.fastq.gz \
${outdir_rawfiles}/${sample}/${raw_fastq_name_R2}.fastq.gz \
${outdir_trim}/${sample}/${raw_fastq_name_R1}.R1.trim_paired.fq.gz \
${outdir_trim}/${sample}/${raw_fastq_name_R1}.R1.trim_unpaired.fq.gz \
${outdir_trim}/${sample}/${raw_fastq_name_R2}.R2.trim_paired.fq.gz \
${outdir_trim}/${sample}/${raw_fastq_name_R2}.R2.trim_unpaired.fq.gz \
ILLUMINACLIP:${ADAPTER}:${seed_mismatches}:${palindrome_clip_threshold}:${simple_clip_threshold}:${min_adapter_length}:${keep_both_reads} LEADING:${leading} TRAILING:${trailing} SLIDINGWINDOW:${slidingwindow_left}:${slidingwindow_right} MINLEN:${minlen} 2>&1 | tee -a ${outdir_trim}/${sample}/log.${sample}.trimmed.txt

echo -e "$(tput setaf 2)\n ==== TRIMMOMATIC${trimmomatic_version} completed for ${sample} ==== \n$(tput sgr0)"
