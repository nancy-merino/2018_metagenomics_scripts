#!/bin/sh
#  01.fastqc.sh
#
#
#  Created by Nancy Merino on 4/4/18.
#

mkdir -p ${outdir_fastqc}/${sample}

echo -e "$(tput setaf 2)\n ==== Now running fastqc on ${sample} ==== \n$(tput sgr0)"

fastqc ${outdir_rawfiles}/${sample}/*.fastq.gz --outdir ${outdir_fastqc}/${sample}

echo -e "$(tput setaf 2)\n ==== Now combining fastqc files into multiqc ==== \n$(tput sgr0)"

#combine fastqc files
cd ${outdir_fastqc}/${sample}

multiqc .
