 #!/bin/sh

#  14a.anvio2_one_sample.sh
#
#
#  Created by Nancy Merino on 4/2/18.
#

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: anvi-profile ${anvio_prefix} ==== \n$(tput sgr0)"
source activate ${anvio_activate}

IFS=',' read -r -a assemblyarray <<< "$assemblysamples"
IFS=',' read -r -a assemblyarrayR1 <<< "$assembly_raw_fastq_name_R1"
IFS=',' read -r -a assemblyarrayR2 <<< "$assembly_raw_fastq_name_R2"

for i in "${!assemblyarray[@]}" ; do

R1_paired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.R1.trim_paired.fq.gz
R1_unpaired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.R1.trim_unpaired.fq.gz
R2_paired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.R2.trim_paired.fq.gz
R2_unpaired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.R2.trim_unpaired.fq.gz

if [ "$i" -eq 0 ] ; then

anvi-profile --min-contig-length ${contiglength} --cluster-contigs \
--input-file ${outdir_bowtie}/${anvio_prefix}/${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings}.indexed.bam \
--contigs-db ${contigsdb}  \
--sample-name ${anvio_prefix} \
--output-dir ${output_profile_one} 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.10.anvi.profile.txt

else

echo -e "$(tput setaf 2)\n ==== This script 14a.anvio2_one_sample.sh is made for only one sample ==== \n$(tput sgr0)"
fi
done

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: anvi-profile completed for ${anvio_prefix} ==== \n$(tput sgr0)"

source deactivate
