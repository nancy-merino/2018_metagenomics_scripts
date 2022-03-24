#!/bin/bash
#  prefs.conf
#
#
#  Version 1. Created by Nancy Merino.
#

export email=<input your email>
export sample=<sample identifier>
export raw_fastq_name_R1=${sample}_1 #match to your raw fastq filename
export raw_fastq_name_R2=${sample}_2 #match to your raw fastq filename
export np=20 #number of threads you want to use
export mem=24 #the memory you selected for your node
export scripts=<path to where the scripts are located>

# FOLDER SETTINGS (no need to change anything here) ##################
export outdir_rawfiles=${WORKDIR}/rawfiles
export outdir_fastqc=${WORKDIR}/fastqc
export outdir_trim=${WORKDIR}/01.trimmomatic
export outdir_bbnorm=${WORKDIR}/02.normalize_bbnorm
export outdir_spades=${WORKDIR}/03.assemble_metaspades
export outdir_mega=${WORKDIR}/04.assemble_megahit
export outdir_quast=${WORKDIR}/05.check_assembly_quast
export outdir_bowtie=${WORKDIR}/06.mapping_bowtie2
export outdir_metabat=${WORKDIR}/07.binning_metabat
export outdir_checkm=${WORKDIR}/08.check_bins_checkm
export outdir_anvio=${WORKDIR}/09.vizualize_analyze_anvio

# TRIMMOMATIC SETTINGS (pay attention to adapter) ##################
export trimmomatic_version=v0.36
export leading=3
export trailing=3
export slidingwindow_left=4
export slidingwindow_right=15
export minlen=36
export seed_mismatches=2
export palindrome_clip_threshold=30
export simple_clip_threshold=10
export min_adapter_length=8
export keep_both_reads=false
export ADAPTER=<path to TruSeq3-PE.fa>
#e.g. TruSeq3-PE.fa ; If you need to change the adapter file, you can copy and paste the original adapter file into your own file system. Change the adapter file as needed (e.g. if you see some sequences you want to remove in previous fastqc files, then add to this adapter file). Please rename file if you modify.
#Other adapter files available by Trimmomatic: NexteraPE-PE.fa, TruSeq2-SE.fa, TruSeq3-PE.fa, TruSeq2-PE.fa, TruSeq3-PE-2.fa, TruSeq3-SE.fa

# BBNORM SETTINGS (optional) ##################
export bbnorm_sh=<path to bbnorm>
export bbnorm_version=37.95
export target=100
export min=5

# GENERAL ASSEMBLY SETTINGS (change these if doing co-assembly) ##################
export assemblysamples=<input sample identifier> # comma separated list if you are doing co-assembly (e.g. sample1,sample2). Must be same as you put for "export sample" !!
export assembly_raw_fastq_name_R1=${sample}_1 # comma separated list if you are doing co-assembly (e.g. sample1_1,sample2_1). Must be same as you put for "export raw_fastq_name_R1" (unless did BBnorm)!!
export assembly_raw_fastq_name_R2=${sample}_2 # comma separated list if you are doing co-assembly (e.g. sample1_2,sample2_2). Must be same as you put for "export raw_fastq_name_R2" (unless did BBnorm)!!
export out_assembly_prefix=<input unique sample prefix> #must be unique prefix each time.

# METASPADES SETTINGS ##################
export spades_link=<path to spades.py>
export spades_version=v3.10.1

# MEGAHIT SETTINGS ##################
export megahit_version=v1.1.1
export mincontig=1000

#QUAST SETTINGS ##################
#default run options are --fragmented --debug
export quast_version=v4.5
export max_ref_number=100
export blast_db=<path to blast db file: silva.128.nsq>

#BOWTIE2 SETTINGS (change kmer & best_assembly) ##################
#default run options are --very-sensitive-local --local --dovetail. See 08.bowtie2.sh for changing these parameters.
export bowtie_version=v2.3.2
export kmer=k55 #choose your best kmer 
export best_assembly=<path to best assembly> #choose your best assembly
export bowtie_settings=verysensitive.local.dovetail 

#METABAT SETTINGS##################
#default settings will run through parameters mincontig (500,1500,2500), maxp (95,75,55), maxedges (200,350,500), and mins (60,75,90). See 09.metabat.sh for changing these parameters.
export metabat_version=v2.11.1

#CHECKM SETTINGS##################
export checkm_version=v1.0.11
export min_align=0.90
export min_qc=15
export ext=fa

#ANVIO SETTINGS (pay attention to anvio_prefix) ##################
export anvio_version=v4
export anvio_activate=anvio4
export contiglength=2500
export anvio_prefix=<input sample identifier> #modify this if your sample name contains other characters Anvi'o may not like. Generally, underscore (_) is the best option as a separator. Other characters may give problems.
export outdir_anvio_01=${outdir_anvio}/${anvio_prefix}/01.anvi_script_reformat_fasta
export outdir_anvio_02=${outdir_anvio}/${anvio_prefix}/02.contig_database
export outdir_anvio_03=${outdir_anvio}/${anvio_prefix}/03.gene_sequences
export outdir_anvio_04=${outdir_anvio}/${anvio_prefix}/04.kaiju_taxonomy
export outdir_anvio_05=${outdir_anvio}/${anvio_prefix}/05.interproscan_gene_annotation
export outdir_anvio_05b=${outdir_anvio}/${anvio_prefix}/05b.eggnog_mapper_gene_annotation
export outdir_anvio_06=${outdir_anvio}/${anvio_prefix}/06.anvi_profile
export outdir_anvio_06b=${outdir_anvio}/${anvio_prefix}/06b.anvi_merge
export output_anvi_simplify_names_fasta=${outdir_anvio_01}/${anvio_prefix}.reformat.anvio.fa
export contigsdb=${outdir_anvio_02}/${anvio_prefix}.db
export output_dna_gene=${outdir_anvio_03}/${anvio_prefix}.dna.gene.sequences.fna
export output_aa_gene=${outdir_anvio_03}/${anvio_prefix}.aa.gene.sequences.faa
export output_interpro=${outdir_anvio_05}/${anvio_prefix}.interpro.output.tsv
export output_profile_one=${outdir_anvio_06}/${anvio_prefix}-PROFILE

#multiples sample - profile settings (pay attention to anvio_multiple_sample and merge_name)
export anvio_multiple_sample=SRR3656745_sub_coassemble_0_1,SRR3656745_sub_coassemble_0_05 #comma separated list with only underscore (_) as separator. The order of the list should match the same order used for the assembly settings.
export merge_name=merged #can change the name of your merged profile here
export output_profile_merge=${outdir_anvio_06b}/${merge_name}/${merge_name}-PROFILE.db

#import bins settings (choose your favorite bin settings)
export mincontig_import=1500
export maxp_import=95
export maxedges_import=500
export mins_import=90

#KAIJU SETTINGS ##################
export kaijudb_wd=<path to kaiju database>
export kaiju_version=v1.5.0
export a_kaiju=greedy
export e_kaiju=5
export m_kaiju=11
export s_kaiju=75

#INTERPROSCAN SETTINGS ##################
#The default will only output TIGRFAM, PANTHER, Pfam, CDD. Other databases are available. See interproscan website.
export interproscan_version=v5.28-67.0
export interproscan_sh=<path to file: interproscan.sh>

#EGGNOG MAPPER SETTINGS ##################
export emapper_version=v0.12.6
export emapper_sh=<path to file emapper.py>
export d=bact
