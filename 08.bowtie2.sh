#!/bin/sh

#  bowtie2.sh
#
#
#  Created by Nancy Merino on 3/27/18.
#

#create directory
mkdir -p ${outdir_bowtie}/${anvio_prefix}

#simplify names for anvio
source activate ${anvio_activate}

echo -e "$(tput setaf 2)\n ==== Simplifying names for anvio ${anvio_version} workflow ==== \n$(tput sgr0)"
anvi-script-reformat-fasta -l 0 --simplify-names ${best_assembly} \
-o ${outdir_anvio_01}/${anvio_prefix}.reformat.anvio.fa \
--prefix ${anvio_prefix} --report-file ${outdir_anvio_01}/${anvio_prefix}.reformat.anvio.txt 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.01.anvi.script.reformat.txt

source deactivate

#run bowtie2
echo -e "$(tput setaf 2)\n ==== Bowtie2-build for ${sample} ==== \n$(tput sgr0)"

bowtie2-build ${outdir_anvio_01}/${anvio_prefix}.reformat.anvio.fa ${outdir_bowtie}/${anvio_prefix}/${anvio_prefix}.bam.anvio

#can change bowtie2 parameters in "prefs.conf" 
IFS=',' read -r -a assemblyarray <<< "$assemblysamples"
IFS=',' read -r -a assemblyarrayR1 <<< "$assembly_raw_fastq_name_R1"
IFS=',' read -r -a assemblyarrayR2 <<< "$assembly_raw_fastq_name_R2"

for i in "${!assemblyarray[@]}" ; do

R1_paired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.R1.trim_paired.fq.gz
R1_unpaired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.R1.trim_unpaired.fq.gz
R2_paired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.R2.trim_paired.fq.gz
R2_unpaired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.R2.trim_unpaired.fq.gz

echo -e "$(tput setaf 2)\n ==== Bowtie2 for ${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}. ==== \n$(tput sgr0)"

bowtie2 --threads ${np} --very-sensitive-local --local --dovetail -t  \
-x ${outdir_bowtie}/${anvio_prefix}/${anvio_prefix}.bam.anvio \
-1 ${R1_paired} \
-2 ${R2_paired} \
-U ${R1_unpaired},${R2_unpaired} \
-S ${outdir_bowtie}/${anvio_prefix}/${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings}.sam

cd ${outdir_bowtie}/${anvio_prefix}

samtools view -F 4 -bS ${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings}.sam > ${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings}.raw.bam

source activate ${anvio_activate}

echo -e "$(tput setaf 2)\n ==== Anvi-init-bam for ${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix} ==== \n$(tput sgr0)"

anvi-init-bam ${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings}.raw.bam -o ${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings}.indexed.bam 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.02.bowtie2.txt

source deactivate

rm ${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings}.sam ${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings}.raw.bam

echo -e "$(tput setaf 2)\n ==== Bowtie2 completed for ${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings} ==== \n$(tput sgr0)"

done



