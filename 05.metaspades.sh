#!/bin/sh

#  05.metaspades.sh
#  
#
#  Created by Nancy Merino on 4/9/18.
#

echo -e "$(tput setaf 2)\n ==== Now running assembly: metaspades ${spades_version} ==== \n$(tput sgr0)"

echo -e "$(tput setaf 2)\n ==== Now running assembly: metaspades ${spades_version}: making yaml file for all samples ==== \n$(tput sgr0)"

mkdir -p ${outdir_spades}/${out_assembly_prefix}/

#---make yaml file for each sample
IFS=',' read -r -a assemblyarray <<< "$assemblysamples"
IFS=',' read -r -a assemblyarrayR1 <<< "$assembly_raw_fastq_name_R1"
IFS=',' read -r -a assemblyarrayR2 <<< "$assembly_raw_fastq_name_R2"

for i in "${!assemblyarray[@]}" ; do

#if you used bbnorm, change the R1 and R2 paired to the file path of the normalized version
R1_paired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.R1.trim_paired.fq.gz
#R1_paired=${outdir_bbnorm}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.normalized.R1.fq.gz
R1_unpaired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR1[$i]}.R1.trim_unpaired.fq.gz
R2_paired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.R2.trim_paired.fq.gz
#R2_paired=${outdir_bbnorm}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.normalized.R2.fq.gz
R2_unpaired=${outdir_trim}/${assemblyarray[$i]}/${assemblyarrayR2[$i]}.R2.trim_unpaired.fq.gz

echo -e "${R1_paired}" >> ${outdir_spades}/${out_assembly_prefix}/${out_assembly_prefix}_read1_list.txt
echo -e "${R2_paired}" >> ${outdir_spades}/${out_assembly_prefix}/${out_assembly_prefix}_read2_list.txt
echo -e "${R1_unpaired}" >> ${outdir_spades}/${out_assembly_prefix}/${out_assembly_prefix}_unpaired1_list.txt
echo -e "${R2_unpaired}" >> ${outdir_spades}/${out_assembly_prefix}/${out_assembly_prefix}_unpaired2_list.txt

done

cd ${outdir_spades}/${out_assembly_prefix}

#make sample list into comma-separated list
for file in ${out_assembly_prefix}_read1_list.txt ${out_assembly_prefix}_read2_list.txt ${out_assembly_prefix}_unpaired1_list.txt ${out_assembly_prefix}_unpaired2_list.txt; do

awk '{print $1}' < ${file} | paste -s -d, -  2>&1 | tee -a fixed.${file}
rm ${file}

done

read1=$(less ${outdir_spades}/${out_assembly_prefix}/fixed.${out_assembly_prefix}_read1_list.txt)
read2=$(less ${outdir_spades}/${out_assembly_prefix}/fixed.${out_assembly_prefix}_read2_list.txt)
unpaired1=$(less ${outdir_spades}/${out_assembly_prefix}/fixed.${out_assembly_prefix}_unpaired1_list.txt)
unpaired2=$(less ${outdir_spades}/${out_assembly_prefix}/fixed.${out_assembly_prefix}_unpaired2_list.txt)

echo "[" >> ${outdir_spades}/${out_assembly_prefix}/${out_assembly_prefix}.yaml

echo "{
orientation: "fr",
type: "paired-end",
right reads: ["${read1}"],
left reads: ["${read2}"],
single reads: ["${unpaired1},${unpaired2}"]
}," >> ${outdir_spades}/${out_assembly_prefix}/${out_assembly_prefix}.yaml

echo "]" >> ${outdir_spades}/${out_assembly_prefix}/${out_assembly_prefix}.yaml


#---run spades

yaml=${outdir_spades}/${out_assembly_prefix}/${out_assembly_prefix}.yaml

kmer_array=( "21" "21,33" "21,33,55" "21,33,55,77" "21,33,55,77,99" "21,33,55,77,99,127" )
kmer_array2=( "21" "33" "55" "77" "99" "127" )

for i in "${!kmer_array[@]}"; do

	echo -e "$(tput setaf 2)\n ==== Now running assembly: metaspades ${spades_version}: assembly for ${sample} & kmer ${kmer_array2[$i]} ==== \n$(tput sgr0)"

	if [ "$i" -eq 0 ] && [ "${kmer_array2[$i]}" -le "21" ]; then
		python2.7 ${spades_link} --meta -k ${kmer_array[$i]} --threads ${np} --memory ${mem} --dataset ${yaml} -o ${outdir_spades}/${out_assembly_prefix}/k${kmer_array2[$i]}
echo "done"

	elif [ "$i" -gt 0 ] && [ "${kmer_array2[$i]}" -le "99" ] ; then
		cp -r ${outdir_spades}/${out_assembly_prefix}/k${kmer_array2[$i-1]} ${outdir_spades}/${out_assembly_prefix}/k${kmer_array2[$i]}
		python2.7 ${spades_link} -k ${kmer_array[$i]} --threads ${np} --memory ${mem} --restart-from k${kmer_array2[$i-1]}  -o ${outdir_spades}/${out_assembly_prefix}/k${kmer_array2[$i]}
echo "done"

	elif [ "$i" -gt 0 ] && [ "${kmer_array2[-1]}" -le "127" ] ; then
		cp -r ${outdir_spades}/${out_assembly_prefix}/k${kmer_array2[$i-1]} ${outdir_spades}/${out_assembly_prefix}/k${kmer_array2[$i]}
		python2.7 ${spades_link} -k ${kmer_array[$i]} --threads ${np} --memory ${mem} --restart-from k${kmer_array2[$i-1]}  -o ${outdir_spades}/${out_assembly_prefix}/k${kmer_array2[$i]}
	fi

done

echo -e "$(tput setaf 2)\n ==== Metaspades completed for ${sample} ==== \n$(tput sgr0)"
