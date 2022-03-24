#!/bin/sh

#  16.emapper_annotation.sh
#
#
#  Created by Nancy Merino on 4/4/18.
#

perl -p -e "s/^>/>eggnog_/g" ${output_aa_gene} > ${outdir_anvio_03}/${anvio_prefix}.aa.gene.sequences.eggnog.faa

cd ${outdir_anvio_03}

echo -e "$(tput setaf 2)\n ==== Now running eggnogmapper ${emapper_version}: ${anvio_prefix} ==== \n$(tput sgr0)"
${emapper_sh} --output ${anvio_prefix}_eggnog -i ${outdir_anvio_03}/${anvio_prefix}.aa.gene.sequences.eggnog.faa --cpu ${np} -d bact --output_dir ${outdir_anvio_05b} --override

echo -e "$(tput setaf 2)\n ==== Eggnog mapper ${emapper_version} completed for ${anvio_prefix} ==== \n$(tput sgr0)"


