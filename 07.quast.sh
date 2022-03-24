#!/bin/bash

#  07.quast.sh
#  
#
#  Created by Nancy Merino on 4/9/18.
#


echo -e "$(tput setaf 2)\n ==== Now running Quast ${quast_version} ==== \n$(tput sgr0)"

echo -e "$(tput setaf 2)\n ==== Now running Quast ${quast_version}: creating sample list ==== \n$(tput sgr0)"

mkdir -p ${outdir_quast}/${out_assembly_prefix}

#---sample list metaspades
for kmer in 21 33 55 77 99 127; do
echo -e "${outdir_spades}/${out_assembly_prefix}/k${kmer}/contigs.fasta" >> ${outdir_quast}/${out_assembly_prefix}/${out_assembly_prefix}_contigs_sample_list.txt
echo -e "${outdir_spades}/${out_assembly_prefix}/k${kmer}/scaffolds.fasta" >> ${outdir_quast}/${out_assembly_prefix}/${out_assembly_prefix}_scaffolds_sample_list.txt
done

#---sample list megahit
for kmer in 21 33 55 77 99 127; do
echo -e "${outdir_mega}/${out_assembly_prefix}/k${kmer}/${out_assembly_prefix}.k${kmer}.contigs.fa" >> ${outdir_quast}/${out_assembly_prefix}/${out_assembly_prefix}_contigs_sample_list.txt
done

cd ${outdir_quast}/${out_assembly_prefix}

#---quast run
echo -e "$(tput setaf 2)\n ==== Now running Quast ${quast_version}: Quast ==== \n$(tput sgr0)"

list_contigs=$(less ${outdir_quast}/${out_assembly_prefix}/${out_assembly_prefix}_contigs_sample_list.txt)
list_scaffolds=$(less ${outdir_quast}/${out_assembly_prefix}/${out_assembly_prefix}_scaffolds_sample_list.txt)

metaquast.py -t ${np} --blast-db ${blast_db} \
${list_contigs} \
--max-ref-number ${max_ref_number} --fragmented --debug \
-o ${outdir_quast}/${out_assembly_prefix}/metaquast_contigs

metaquast.py -t ${np} --blast-db ${blast_db} \
${list_scaffolds} \
--max-ref-number ${max_ref_number} --fragmented --debug \
-o ${outdir_quast}/${out_assembly_prefix}/metaquast_contigs

quast.py -t ${np} --fragmented --debug \
${list_contigs} \
-o ${outdir_quast}/${out_assembly_prefix}/contigs

quast.py -t ${np} --fragmented --debug --scaffolds \
${list_scaffolds} \
-o ${outdir_quast}/${out_assembly_prefix}/scaffolds

echo -e "$(tput setaf 2)\n ==== Check your assembly Quast ${quast_version} file(s) before mapping. Check completed for ${sample} ==== \n$(tput sgr0)"
