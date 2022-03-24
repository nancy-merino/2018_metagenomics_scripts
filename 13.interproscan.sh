#!/bin/sh

#  13.interproscan.sh
#
#
#  Created by Nancy Merino on 4/2/18.
#

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: Now running interproscan ${interproscan_version} for ${sample}. This will only output TIGRFAM, PANTHER, Pfam, CDD ==== \n$(tput sgr0)"

source activate ${anvio_activate}
anvi-get-aa-sequences-for-gene-calls -c ${contigsdb} -o ${output_aa_gene} 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.07.anvi.aa.sequences.txt

source deactivate 

#can change -appl to (No mobidb or gene3d!! There will be error):  -appl TIGRFAM,SFLD,ProDom,Hamap,SMART,CDD,ProSiteProfiles,ProSitePatterns,SUPERFAMILY,PRINTS,PANTHER,PIRSF,Pfam,Coils 

${interproscan_sh} -cpu ${np} -i ${output_aa_gene} -appl TIGRFAM,PANTHER,Pfam,CDD -f tsv -o ${output_interpro} 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.08.anvi.interproscan.txt

#count number of columns per line: awk -F'\t' '{print NF}' ${output_interpro} | sort -nu
awk -F'\t' -v OFS='\t' 'NF=11' ${output_interpro} > ${output_interpro}.tmp && mv ${output_interpro}.tmp ${output_interpro}
#make sure number of columns matches what anvio is expecting

source activate ${anvio_activate}

anvi-import-functions -c ${contigsdb} -i ${output_interpro} -p interproscan 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.09.anvi.import.functions.txt

source deactivate

echo -e "$(tput setaf 2)\n ==== Interproscan${interproscan_version} completed for ${sample} ==== \n$(tput sgr0)"
