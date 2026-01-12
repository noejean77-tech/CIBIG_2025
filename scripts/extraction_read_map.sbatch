#!/bin/bash

#SBATCH --job-name=read_samtools_noe
##SBATCH --cpus-per-task=4
#SBATCH --mail-type ALL
#SBATCH --mail-user noejean77@gmail.com
#SBATCH --partition=normal
#SBATCH --output=/data/noe/OMICS_practice/logs/samtools_%j.out
#SBATCH --error=/data/noe/OMICS_practice/logs/samtools_%j.err
##########################################

#Chargeons les modules 
module load samtools/1.19.2

# Variables 
inp_dir="/data/noe/OMICS_practice/results/2_mapping"
out_dir="/data/noe/OMICS_practice/results/2_mapping/read.map"

mkdir -p "$out_dir"
mkdir -p logs

for file in ${inp_dir}/*.bam
do 	
	name=$(basename "$file" .bam)
	echo "------traitement: de $name----------"
	# Etape 1: Filtrage des reads correctement appariés (-f 2)
	samtools view -f 2 -b "$file" -o "${out_dir}/${name}.paired.properly.bam"
	# Étape 2 : Tri par coordonnées
	samtools sort "$out_dir/${name}.paired.properly.bam" -o "${out_dir}/${name}.sorted.bam"
	# Étape 3 : Indexation
  	samtools index "${out_dir}/${name}.sorted.bam"
  echo  "finish pour : $name"
done
