#!/bin/sh

#  09.metabat.sh
#
#
#  Created by Nancy Merino on 3/31/18.
#
IFS=',' read -r -a assemblyarray <<< "$assemblysamples"
IFS=',' read -r -a assemblyarrayR1 <<< "$assembly_raw_fastq_name_R1"
IFS=',' read -r -a assemblyarrayR2 <<< "$assembly_raw_fastq_name_R2"

mkdir -p ${outdir_metabat}/${out_assembly_prefix}/
cd ${outdir_metabat}/${out_assembly_prefix}/

#-------can change these parameters: echo {mincontig}" "{maxp}" "{maxedges}" "{mins}
echo {1500,2500}" "{95,75,55}" "{200,350,500}" "{60,75,90} | xargs -n 4 > metabat_parameter_list.txt

#-------make bam list file
for i in "${!assemblyarray[@]}" ; do

bam_file=${outdir_bowtie}/${anvio_prefix}/${assemblyarray[$i]}.${assemblyarrayR1[$i]}.${assemblyarrayR2[$i]}.${anvio_prefix}.${bowtie_settings}.indexed.bam

echo -e "${bam_file}" >> ${outdir_metabat}/${out_assembly_prefix}/${out_assembly_prefix}_bam_list.txt

done

#make sample list into comma-separated list
file=${out_assembly_prefix}_bam_list.txt
awk '{print $1}' < ${file} | paste -s -d" "  2>&1 | tee -a fixed.${file}
rm ${file}

bam_list=$(less ${outdir_metabat}/${out_assembly_prefix}/fixed.${file})

#------run metabat
while IFS=" " read -r mincontig maxp maxedges mins remainder; do

echo -e "$(tput setaf 2)\n ==== Binning for ${out_assembly_prefix}: Metabat ${metabat_version}: minContig${mincontig}_maxP${maxp}_maxEdges${maxedges}_minS${mins} ==== \n$(tput sgr0)"

mkdir -p ${outdir_metabat}/${out_assembly_prefix}/${out_assembly_prefix}_minContig${mincontig}_maxP${maxp}_maxEdges${maxedges}_minS${mins}
cd ${outdir_metabat}/${out_assembly_prefix}/${out_assembly_prefix}_minContig${mincontig}_maxP${maxp}_maxEdges${maxedges}_minS${mins}

runMetaBat.sh --minContig ${mincontig} --maxP ${maxp} --maxEdges ${maxedges} --minS ${mins} --verbose --numThreads ${np} --unbinned \
${outdir_anvio_01}/${anvio_prefix}.reformat.anvio.fa \
${bam_list} 2>&1 | tee -a ${outdir_metabat}/${out_assembly_prefix}/log.txt

done < ${outdir_metabat}/${out_assembly_prefix}/metabat_parameter_list.txt

echo -e "$(tput setaf 2)\n ==== Metabat completed for ${out_assembly_prefix} ==== \n$(tput sgr0)"

#make bin list
echo -e "$(tput setaf 2)\n ==== Making bin list for ${out_assembly_prefix} ==== \n$(tput sgr0)"

ls -d ${outdir_metabat}/${out_assembly_prefix}/*/*unbinned >> ${outdir_metabat}/${out_assembly_prefix}/${out_assembly_prefix}_bin_list.txt





#You can decrease -m (--minContig) when the qualities of both assembly and formed bins with default value are very good. (default=2500)
#mincontig_metabat: 1500, 2500

#You can decrease --maxP and --maxEdges when the qualities of both assembly and formed bins are very bad. (default maxp=95; maxedges=200)
#maxp: 95,75,55
#maxedges: 200,350,500

#You can increase --maxEdges when the completeness level is low, for many datasets we typically use 500.

#You can increase --minS when the qualities of both assembly and formed bins are very bad. (default mins=60)
#mins: 60,75,90

#Set --noAdd when added small or leftover contigs cause too much contamination.
#Set --seed positive numbers to reproduce the result exactly. Otherwise, random seed will be set each time.
