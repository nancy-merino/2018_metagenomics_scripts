#!/bin/sh

#  06.megahit.sh
#  
#
#  Created by Nancy Merino on 4/9/18.
#

mkdir -p ${outdir_mega}/${out_assembly_prefix}/

IFS=',' read -r -a assemblyarray <<< "$assemblysamples"
IFS=',' read -r -a assemblyarrayR1 <<< "$assembly_raw_fastq_name_R1"
IFS=',' read -r -a assemblyarrayR2 <<< "$assembly_raw_fastq_name_R2"

#-----------------make sample list
for i in "${!assemblyarray[@]}" ; do

#if you used bbnorm, change the R1 and R2 paired to the file path of the normalized version
R1_paired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.R1.trim_paired.fq.gz
#R1_paired=${outdir_bbnorm}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.normalized.R1.fq.gz
R1_unpaired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.R1.trim_unpaired.fq.gz
R2_paired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.R2.trim_paired.fq.gz
#R2_paired=${outdir_bbnorm}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.normalized.R2.fq.gz
R2_unpaired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.R2.trim_unpaired.fq.gz

echo -e "${R1_paired}" >> ${outdir_mega}/${out_assembly_prefix}/${out_assembly_prefix}_read1_list.txt
echo -e "${R2_paired}" >> ${outdir_mega}/${out_assembly_prefix}/${out_assembly_prefix}_read2_list.txt
echo -e "${R1_unpaired}" >> ${outdir_mega}/${out_assembly_prefix}/${out_assembly_prefix}_unpaired1_list.txt
echo -e "${R2_unpaired}" >> ${outdir_mega}/${out_assembly_prefix}/${out_assembly_prefix}_unpaired2_list.txt

done

cd ${outdir_mega}/${out_assembly_prefix}

#make sample list into comma-separated list
for file in ${out_assembly_prefix}_read1_list.txt ${out_assembly_prefix}_read2_list.txt ${out_assembly_prefix}_unpaired1_list.txt ${out_assembly_prefix}_unpaired2_list.txt; do

awk '{print $1}' < ${file} | paste -s -d, -  2>&1 | tee -a fixed.${file}
rm ${file}

done

#run megahit
kmer_array=( "21" "21,33" "21,33,55" "21,33,55,77" "21,33,55,77,99" "21,33,55,77,99,127" )
kmer_array2=( "21" "33" "55" "77" "99" "127" )

for i in "${!kmer_array[@]}"; do

read1=$(less ${outdir_mega}/${out_assembly_prefix}/fixed.${out_assembly_prefix}_read1_list.txt)
read2=$(less ${outdir_mega}/${out_assembly_prefix}/fixed.${out_assembly_prefix}_read2_list.txt)
unpaired1=$(less ${outdir_mega}/${out_assembly_prefix}/fixed.${out_assembly_prefix}_unpaired1_list.txt)
unpaired2=$(less ${outdir_mega}/${out_assembly_prefix}/fixed.${out_assembly_prefix}_unpaired2_list.txt)

echo -e "$(tput setaf 2)\n ==== Now running assembly: megahit ${megahit_version}: assembly for ${out_assembly_prefix} & kmer ${kmer_array2[$i]} ==== \n$(tput sgr0)"

megahit --k-list ${kmer_array[$i]} --verbose --num-cpu-threads ${np} --min-contig-len ${mincontig} \
-1 ${read1} \
-2 ${read2} \
-r ${unpaired1},${unpaired2} \
--out-dir ${outdir_mega}/${out_assembly_prefix}/k${kmer_array2[$i]}/ \
--out-prefix ${out_assembly_prefix}.k${kmer_array2[$i]}

done

echo -e "$(tput setaf 2)\n ==== Megahit completed for ${sample} ==== \n$(tput sgr0)"

