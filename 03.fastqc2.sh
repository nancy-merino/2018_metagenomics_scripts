#!/bin/bash
#  03.fastqc2.sh
#
#
#  Created by Nancy Merino on 4/4/18.
#

echo -e "$(tput setaf 2)\n ==== Now running fastqc on trimmed sample ${sample} ==== \n$(tput sgr0)"

fastqc ${outdir_trim}/${sample}/*.fq.gz --outdir ${outdir_fastqc}/${sample}

echo -e "$(tput setaf 2)\n ==== Now combining fastqc files into multiqc ==== \n$(tput sgr0)"

#combine fastqc files
cd ${outdir_fastqc}/${sample}

multiqc . -f

echo -e "$(tput setaf 2)\n ==== Please check the multiqc and fastqc files in web browser before proceeding ==== \n$(tput sgr0)"
