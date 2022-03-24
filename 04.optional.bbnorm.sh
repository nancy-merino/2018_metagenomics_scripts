#!/bin/sh

#  04.optional.bbnorm.sh
#  
#
#  Created by Nancy Merino on 4/9/18.
#

echo -e "$(tput setaf 2)\n ==== Now running bbnorm v${bbnorm_version} for ${sample} ==== \n$(tput sgr0)"

in=${outdir_trim}/${sample}/${sample}.R1.trim_paired.fq.gz 
in2=${outdir_trim}/${sample}/${sample}.R2.trim_paired.fq.gz
out=${outdir_bbnorm}/${sample}/${sample}.normalized.R1.fq.gz
out2=${outdir_bbnorm}/${sample}/${sample}.normalized.R2.fq.gz
khist=${outdir_bbnorm}/${sample}/${sample}_khist_before.txt
khistout=${outdir_bbnorm}/${sample}/${sample}_khist_after.txt
peaks=${outdir_bbnorm}/${sample}/${sample}_peaks.txt

${bbnorm_sh} in=${in} in2=${in2} threads=${np} \
out=${out} out2=${out2} peaks=${peaks} \
prefilter=t target=${target} min=${min} prefilter ecc \
khist=${khist} khistout=${khistout}

#hashes=3            Number of times each kmer is hashed and stored.  Higher is slower. Higher is MORE accurate if there is enough memory, and LESS accurate if there is not enough memory.
#target=100          (tgt) Target normalization depth.  NOTE:  All depth parameters control kmer depth, not read depth. For kmer depth Dk, read depth Dr, read length R, and kmer size K:  Dr=Dk*(R/(R-K+1))
#mindepth=5          (min) Kmers with depth below this number will not be included when calculating the depth of a read.

echo -e "$(tput setaf 2)\n ==== BBnorm completed for ${sample} ==== \n$(tput sgr0)"

echo -e "$(tput setaf 2)\n ==== BBnorm completed for ${sample} ==== \n$(tput sgr0)" | mail -s 'BBnorm completed' ${email}
