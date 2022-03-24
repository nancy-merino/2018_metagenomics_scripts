#!/bin/sh

#  12.kaiju.sh
#
#
#  Created by Nancy Merino on 4/2/18.
#

output_kaiju=${outdir_anvio_04}/${anvio_prefix}.kaiju.out.txt
output_kaiju_report=${outdir_anvio_04}/${anvio_prefix}.kaiju.out.report.txt
output_kaiju_addtaxonnames=${outdir_anvio_04}/${anvio_prefix}.kaiju.out.addtaxonnames.txt
output_kaiju_addtaxonnames_anvio=${outdir_anvio_04}/${anvio_prefix}.kaiju.out.addtaxonnames.foranvio.txt

source activate ${anvio_activate}

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: anvi-get-dna-sequences-for-gene-calls for ${sample} ==== \n$(tput sgr0)"
anvi-get-dna-sequences-for-gene-calls -c ${contigsdb} -o ${output_dna_gene} 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.05.anvi.gene.calls.txt

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: now running kaiju ${kaiju_version} for ${sample} (please wait awhile) ==== \n$(tput sgr0)"

kaiju -t ${kaijudb_wd}/nodes.dmp \
-f ${kaijudb_wd}/kaiju_db_nr_euk.fmi \
-i ${output_dna_gene} \
-o ${output_kaiju} \
-z ${np} -v -a ${a_kaiju} -e ${e_kaiju} -m ${m_kaiju} -s ${s_kaiju}

kaijuReport -t ${kaijudb_wd}/nodes.dmp \
-n ${kaijudb_wd}/names.dmp \
-i ${output_kaiju} \
-o ${output_kaiju_report} \
-p -v -r species

addTaxonNames -t ${kaijudb_wd}/nodes.dmp \
-n ${kaijudb_wd}/names.dmp \
-i ${output_kaiju} \
-o ${output_kaiju_addtaxonnames} \
-r phylum,order,class,family,genus,species -v

#extract column 2 and 8 from kaiju
cut -f2,8 ${output_kaiju_addtaxonnames} > ${output_kaiju_addtaxonnames_anvio}

#change ; to tabs
tr ';' '\t' < ${output_kaiju_addtaxonnames_anvio} > ${output_kaiju_addtaxonnames_anvio}1.tsv

#add headers
echo $'gene_callers_id\tt_phylum\tt_class\tt_order\tt_family\tt_genus\tt_species' | cat - ${output_kaiju_addtaxonnames_anvio}1.tsv > ${output_kaiju_addtaxonnames_anvio}2.tsv

#extract only the gene_caller_id from header
awk -v "OFS=\t" '{$1=$1;sub(/\|contig.*/, "", $1); print}' ${output_kaiju_addtaxonnames_anvio}2.tsv 2>&1 | tee -a ${output_kaiju_addtaxonnames_anvio}3.tsv

#extract first 7 columns
awk 'BEGIN { OFS = "\t" }{print $1,$2,$3,$4,$5,$6,$7}' ${output_kaiju_addtaxonnames_anvio}3.tsv  2>&1 | tee -a ${output_kaiju_addtaxonnames_anvio}4.tsv

awk 'BEGIN { FS = OFS = "\t" } { for(i=1; i<=NF; i++) if($i ~ /^ *$/) $i = "NA" }; 1' ${output_kaiju_addtaxonnames_anvio}4.tsv 2>&1 | tee -a ${output_kaiju_addtaxonnames_anvio}.final.tsv

sed -i  '/^\s*$/d' ${output_kaiju_addtaxonnames_anvio}.final.tsv

cd ${outdir_anvio_04}
rm ${output_kaiju_addtaxonnames_anvio}1.tsv ${output_kaiju_addtaxonnames_anvio}2.tsv ${output_kaiju_addtaxonnames_anvio}3.tsv ${output_kaiju_addtaxonnames_anvio}4.tsv

echo -e "$(tput setaf 2)\n ==== now importing taxonomy to anvio ${sample} ==== \n$(tput sgr0)"

anvi-import-taxonomy -c ${contigsdb} -i ${output_kaiju_addtaxonnames_anvio}.final.tsv -p default_matrix 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.06.anvi.import.taxonomy.kaiju.txt

source deactivate

echo -e "$(tput setaf 2)\n ==== Kaiju ${kaiju_version} completed for ${sample} ==== \n$(tput sgr0)"
