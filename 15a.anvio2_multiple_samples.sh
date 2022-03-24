#!/bin/sh

#  15a.anvio2_multiple_samples.sh
#
#
#  Created by Nancy Merino on 4/2/18.
#

source activate ${anvio_activate}

IFS=',' read -r -a assemblyarray <<< "$assemblysamples"
IFS=',' read -r -a assemblyarrayR1 <<< "$assembly_raw_fastq_name_R1"
IFS=',' read -r -a assemblyarrayR2 <<< "$assembly_raw_fastq_name_R2"
IFS=',' read -r -a anvio_sample_name <<< "$anvio_multiple_sample"

for i in "${!assemblyarray[@]}" ; do

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: anvi-profile ${anvio_sample_name} ==== \n$(tput sgr0)"

R1_paired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.R1.trim_paired.fq.gz
R1_unpaired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.R1.trim_unpaired.fq.gz
R2_paired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.R2.trim_paired.fq.gz
R2_unpaired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.R2.trim_unpaired.fq.gz

output_profile=${outdir_anvio_06}/${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}-PROFILE

anvi-profile --min-contig-length ${contiglength} \
--input-file ${outdir_bowtie}/${anvio_prefix}/${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings}.indexed.bam \
--contigs-db ${contigsdb}  \
--sample-name ${anvio_sample_name[$i]} \
--output-dir ${output_profile} 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.10.anvi.profile.txt

done

source deactivate

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: anvi-profile completed for ${sample} ==== \n$(tput sgr0)"
