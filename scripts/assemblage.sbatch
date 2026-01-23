#!/bin/bash

#SBATCH --job-name=Assemblage_Reads
#SBATCH --cpus-per-task=4
#SBATCH --mail-type ALL
#SBATCH --mail-user noejean77@gmail.com
#SBATCH --partition=normal
#SBATCH --output=/data/noe/OMICS_Patho_1/logs/assemblage_%j.out
#SBATCH --error=/data/noe/OMICS_Patho_1/logs/assemblage_%j.err
##########################################




# Variable
REF="/data/noe/OMICS_Patho_1/banks/ncbi_dataset/data/GCA_002525835.2/GCA_002525835.2_ipoBat4_genomic.fna"
RAW_DATA="/data/noe/OMICS_Patho_1/RAW_DATA"
mapping_dir="/data/noe/OMICS_Patho_1/results/2_mapping"
taxo_out="/data/noe/OMICS_Patho_1/results/3_class_taxo_reads"
db="/data/noe/OMICS_Patho_1/banks/db"
assemblage_out="/data/noe/OMICS_Patho_1/results/4_assemblage"


mkdir -p "$mapping_dir"
mkdir -p "$taxo_out"
mkdir -p "$assemblage_out"

source /etc/profile.d/modules.sh
#telechargeons les modules
module load minimap2/2.17
module load samtools/1.19.2
module load kraken2/2.17.1
module load  flye/2.9.6-b1802

# Définition des commandes Singularity (car ce sont des alias)
MINIMAP2_CMD="singularity run /usr/local/bioinfo/containers/minimap2-2.2.17.sif"
FLYE_CMD="singularity run /usr/local/bioinfo/containers/flye-2.9.6.sif"

for file in "$RAW_DATA"/*fastq; do
  names=$(basename "$file" .fastq)
  echo "-----debut d'analyse de: $names"
  #suprimons le genome de reference de la patate douce(minimap)
  echo "supressions genome ref de : $names"
  $MINIMAP2_CMD -t "$SLURM_CPUS_PER_TASK" -a -x map-ont "$REF" "$file" -o "${mapping_dir}/$names.mapped.sam" #supprimer les read qui map avec le genome de reference (sam)
  #Obtentions des reads qui n'ont pas mapper
  echo "Obention reads unmapped : $names"
  samtools view -@ "$SLURM_CPUS_PER_TASK" -f 4 -b "${mapping_dir}/$names.mapped.sam" > "${mapping_dir}/$names.unmapped.bam" # on filtre de telle sorte qu'on obtiens que les reads qui n'ont pas mapper avec le genome de reference
  # convertissons le fichier des read unmapped en fastq
  echo "conversion bam -> fastq : $names"
  samtools fastq "${mapping_dir}/$names.unmapped.bam" > "${mapping_dir}/$names.unmapped.fastq"
  #classification taxonomique des reads unmapped avec kraken avec la bd k2_pluspfp_16_GB
  echo  "classification des reads unmapped de : $names"
  kraken2 --threads "$SLURM_CPUS_PER_TASK" --db "$db" "${mapping_dir}/$names.unmapped.fastq" --report "${taxo_out}/$names.report.txt" --output "${taxo_out}/$names.output.txt"
  # faisons l'assemblage de novo des reads qui n'ont pas mapper
  echo "assemblage de novo: $names"
  $FLYE_CMD --meta -t "$SLURM_CPUS_PER_TASK" --nano-raw "${mapping_dir}/$names.unmapped.fastq" -o "${assemblage_out}/$names"
  echo "fin d'assemblage de: $names"
done
