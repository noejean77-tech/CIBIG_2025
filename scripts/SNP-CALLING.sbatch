#!/bin/bash
###############SLURM CONFIGRATION #######
#SBATCH --job-name=SNP_CALLING
##SBATCH --cpus-per-task=8
#SBATCH --partition=normal
#SBATCH --output=/data/noe/OMICS_practice/logs/SNP_CALLING_%j.out
#SBATCH --error=/data/noe/OMICS_practice/logs/SNP_CALLING_%j.err
##########################################

#chargeons les modules 
module load bcftools/1.18

#=====================
#Variables
#===================
REF="/data/noe/OMICS_practice/banks/ncbi_dataset/data/GCF_002220235.1/GCF_002220235.1_ASM222023v1_genomic.fna"
bam_dir="/data/noe/OMICS_practice/results/2_read_map/mapped.only"
out_dir="/data/noe/OMICS_practice/results/3_SNP"

mkdir -p "$out_dir"

echo "Debut de l'analyse SNP"
# 1. generation du fichier bcf avec la commande bcftools mpileup
echo "generation du fichier bcf"
bcftools mpileup -f "$REF" "$bam_dir"/*.sorted.bam -Ob -o "$out_dir/all.samples.bcf"
# 2. effectuons l'appel des variants avec la commandes bcftools call
echo "generation du fichier vcf des snps a partir de notre bcf generer."
bcftools call -mv "$out_dir/all.samples.bcf" -Ov -o "$out_dir/all.samples.vcf"
# indexons le fichier VCF avec la commande bcftools view
echo "indexation dd fichier VCF"
bcftools view "$out_dir/all.samples.bcf" -Ov -o "$out_dir/all.samples.vcf.gz"
bcftools index "$out_dir/all.samples.vcf.gz"
echo "fin de l'appel SNPs"
