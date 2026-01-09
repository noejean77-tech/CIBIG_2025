#!/bin/bash
#
#SBATCH --job-name=mapping_bwamem2
##SBATCH --cpus-per-task=4
#SBATCH --mail-type ALL
#SBATCH --mail-user noejean77@gmail.com
#SBATCH --partition=normal
#SBATCH --output=logs/bwa_%j.out
#SBATCH --error=logs/bwa_%j.err
##########################################

#chargeons les modules 
module load  bwamem2/2.2.1
module load samtools/1.19.2

#=====================
#Variables
#===================
REF="/data/noe/OMICS_practice/banks/ncbi_dataset/data/GCF_002220235.1/GCF_002220235.1_ASM222023v1_genomic.fna"
RAW_DIR="/data/noe/OMICS_practice/raw_data/SHORT_READS"
OUT_DIR="/data/noe/OMICS_practice/results/2_mapping"

mkdir -p "$OUT_DIR"
mkdir -p logs

#==============================
#Boucle sur les echantillons 
#=============================

for file in ${RAW_DIR}/*.fastq.gz
do 
	ECH_ID=$(basename "$file" .fastq.gz | sed 's/_R[12]//')
	echo "Mapping pour $ECH_ID"
	bwa-mem2 mem -t 4 "$REF" "${RAW_DIR}/${ECH_ID}_R1.fastq.gz" "${RAW_DIR}/${ECH_ID}_R2.fastq.gz" > "${OUT_DIR}/${ECH_ID}.sam"
	samtools view "${OUT_DIR}/${ECH_ID}.sam" -b > "${OUT_DIR}/${ECH_ID}.bam"
	echo "Mapping finish ${ECH_ID}"
done
