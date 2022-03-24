#!/bin/sh

#  11.anvio1.sh
#
#
#  Created by Nancy Merino on 4/2/18.
#

source activate ${anvio_activate}

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: anvi-gen-contigs-database ${anvio_prefix} ==== \n$(tput sgr0)"
anvi-gen-contigs-database -n ${anvio_prefix} -f ${output_anvi_simplify_names_fasta} -o ${contigsdb} 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.03.anvi.gen.contigs.db.txt

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: anvi-run-hmms ${anvio_prefix} ==== \n$(tput sgr0)"
anvi-run-hmms --num-threads ${np} -c ${contigsdb} 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.04.anvi.run.hmms.txt

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: anvi-display-contigs-stats ${anvio_prefix} ==== \n$(tput sgr0)"
anvi-display-contigs-stats ${contigsdb} --report-as-text -o ${outdir_anvio_02}/${anvio_prefix}_contigs_stats.txt

echo -e "$(tput setaf 2)\n ==== Anvio part 1: anvi-gen-contigs-database & anvi-run-hmms completed for ${anvio_prefix} ==== \n$(tput sgr0)"

source deactivate
