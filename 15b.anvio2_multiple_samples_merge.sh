#!/bin/sh

#  15b.anvio2_multiple_samples_merge.sh
#
#
#  Created by Nancy Merino on 4/2/18.
#

mkdir -p ${outdir_anvio_06b}

IFS=',' read -r -a assemblyarray <<< "$assemblysamples"
IFS=',' read -r -a assemblyarrayR1 <<< "$assembly_raw_fastq_name_R1"
IFS=',' read -r -a assemblyarrayR2 <<< "$assembly_raw_fastq_name_R2"
IFS=',' read -r -a anvio_sample_name <<< "$anvio_multiple_sample"

#-------make profile list file
for i in "${!assemblyarray[@]}" ; do

output_profile=${outdir_anvio_06}/${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}-PROFILE/PROFILE.db

echo -e "${output_profile}" >> ${outdir_anvio}/${anvio_prefix}/${anvio_prefix}_profile_list.txt

done

#-------make sample list into comma-separated list
file=${anvio_prefix}_profile_list.txt
awk '{print $1}' < ${outdir_anvio}/${anvio_prefix}/${file} | paste -s -d" "  2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/fixed.${file}
rm ${outdir_anvio}/${anvio_prefix}/${file}

profile_list=$(less ${outdir_anvio}/${anvio_prefix}/fixed.${file})

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: anvi-merge ${anvio_prefix} ==== \n$(tput sgr0)"
source activate ${anvio_activate}

anvi-merge ${profile_list} -o ${outdir_anvio_06b}/${merge_name} -c ${contigsdb} 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.11.anvi.merge.txt

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: anvi-merge completed for ${anvio_prefix} ==== \n$(tput sgr0)"

source deactivate
