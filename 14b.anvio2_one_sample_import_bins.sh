#!/bin/sh

#  anvio_import_bins_one.sh
#
#
#  Created by Nancy Merino on 4/4/18.
#

source activate ${anvio_activate}

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: importing metabat bins ${anvio_prefix}: getting bin list ==== \n$(tput sgr0)"

mkdir -p ${outdir_metabat}/${out_assembly_prefix}/chosen_bins

cd ${outdir_metabat}/${out_assembly_prefix}/${out_assembly_prefix}_minContig${mincontig_import}_maxP${maxp_import}_maxEdges${maxedges_import}_minS${mins_import}/${anvio_prefix}.reformat.anvio.fa.metabat-bins--unbinned

ls *fa > sample_list.txt

#change the digits to the number of bins
while read list; do
awk -v OFS='\t' '
FNR==1 { n=split(FILENAME,f,/\./); ext=f[n-1] }
sub(/^>/,""){ print $0, ext }
' ${list} 2>&1 | tee -a ${outdir_metabat}/${out_assembly_prefix}/chosen_bins/${out_assembly_prefix}_minContig${mincontig_import}_maxP${maxp_import}_maxEdges${maxedges_import}_minS${mins_import}_binningresult.txt
done < sample_list.txt

awk 'BEGIN { OFS = "\t" } { $2 = "bin_"$2 ; print }' ${outdir_metabat}/${out_assembly_prefix}/chosen_bins/${out_assembly_prefix}_minContig${mincontig_import}_maxP${maxp_import}_maxEdges${maxedges_import}_minS${mins_import}_binningresult.txt 2>&1 | tee -a ${outdir_metabat}/${out_assembly_prefix}/chosen_bins/${out_assembly_prefix}_minContig${mincontig_import}_maxP${maxp_import}_maxEdges${maxedges_import}_minS${mins_import}_binningresult_foranvio.txt

rm ${outdir_metabat}/${out_assembly_prefix}/chosen_bins/${out_assembly_prefix}_minContig${mincontig_import}_maxP${maxp_import}_maxEdges${maxedges_import}_minS${mins_import}_binningresult.txt

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: importing metabat bins ${anvio_prefix} ==== \n$(tput sgr0)"

anvi-import-collection ${outdir_metabat}/${out_assembly_prefix}/chosen_bins/${out_assembly_prefix}_minContig${mincontig_import}_maxP${maxp_import}_maxEdges${maxedges_import}_minS${mins_import}_binningresult_foranvio.txt -p ${output_profile_one}/PROFILE.db -c ${contigsdb} --collection-name "metabat" --contigs-mode 2>&1 | tee -a ${outdir_anvio}/${anvio_prefix}/log.11.anvi.import.bins.txt

source deactivate

echo -e "$(tput setaf 2)\n ==== Anvio${anvio_version}: Finished importing bins for ${sample} ==== \n$(tput sgr0)"
