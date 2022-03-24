#!/bin/sh

#  10.checkm.sh
#
#
#  Created by Nancy Merino on 4/2/18.
#

cd ${outdir_metabat}/${out_assembly_prefix}/

while read bin_folder; do

sub_name=${bin_folder%/*}
name=${sub_name##*/}

echo -e "$(tput setaf 2)\n ==== Checking bins for ${name}: Checkm ${checkm_version} ==== \n$(tput sgr0)"

mkdir -p ${outdir_checkm}/${out_assembly_prefix}/${name}
cd ${outdir_checkm}/${out_assembly_prefix}/${name}

file=${out_assembly_prefix}_bam_list.txt
bam_list=$(less ${outdir_metabat}/${out_assembly_prefix}/fixed.${file})

checkm coverage --extension ${ext} --min_align ${min_align} --min_qc ${min_qc} --threads ${np} \
-x fa ${bin_folder} \
${outdir_checkm}/${out_assembly_prefix}/${name}/${sample}.coverage.tsv \
${bam_list} 2>&1 | tee -a ${outdir_checkm}/${out_assembly_prefix}/${name}/${out_assembly_prefix}.log.checkm.coverage.txt

checkm lineage_wf --ali --nt --tab_table --force_domain --threads ${np} --reduced_tree \
-a ${outdir_checkm}/${out_assembly_prefix}/${name}/${sample}.alignment.fna.gz \
-f ${outdir_checkm}/${out_assembly_prefix}/${name}/${sample}.lineagewf.results.txt \
-x fa ${bin_folder} \
${outdir_checkm}/${out_assembly_prefix}/${name}/${sample}_lineagewf 2>&1 | tee -a ${outdir_checkm}/${out_assembly_prefix}/${name}/${sample}.log.checkm.lineagewf.txt

mkdir -p ${outdir_checkm}/${out_assembly_prefix}/${name}/bin_qa_plot

checkm bin_qa_plot --image_type pdf \
${outdir_checkm}/${out_assembly_prefix}/${name}/${sample}_lineagewf \
-x fa ${bin_folder} \
${outdir_checkm}/${out_assembly_prefix}/${name}/bin_qa_plot 2>&1 | tee -a ${outdir_checkm}/${out_assembly_prefix}/${name}/${sample}.log.checkm.binqaplot.txt

output=${outdir_checkm}/${out_assembly_prefix}/${sample}_summary.txt
sed "s/$/\t${name}/" ${outdir_checkm}/${out_assembly_prefix}/${name}/${sample}.lineagewf.results.txt 2>&1 | tee -a ${output}


done < ${outdir_metabat}/${out_assembly_prefix}/${out_assembly_prefix}_bin_list.txt

echo -e "$(tput setaf 2)\n ==== CheckM completed for ${out_assembly_prefix}: Use command checkm bin_compare -h to compare 2 bins. Choose the best bins before moving on. You can also try other binning software (e.g. MyCC, ESOM). Anvi'o uses CONCOCT binning. ==== \n$(tput sgr0)"


