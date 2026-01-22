# MODULE OMICS 

## Day 1
### pratice 1
```
● What is the genome size ?
Genome size: 15 Mb

● How many chromosomes are there?
Number of chromosomes:19

● What are the sizes of the smallest and largest
chromosomes?
largest chromosomes 1 : 1 352 724
smallest chromosomes 19 :146 238 

● How many organelles? Which ones?
Number of organelles: 2

● How many genes are annotated?
Genes : 7 967

● What is the GC content (%) of the genome?
GC percent: 48
```
### Pratice 2 

```
[noe@node02 raw_data]$ tar xvfz SV_DATA_17.tar.gz: pour decompresser les fichier tar
 
```

## Days 2
```
#Go into the directory SHORT_READS and list the content of this directory - cd ls
[noe@node02 SHORT_READS]$ ls |wc -l : lister et compter le nombre de fichier dans un dosier 
[noe@node02 SHORT_READS]$ ls -lh : pour lister le nombre de fichier suivie de leur format 

#How many files does it contain ? What is the format ?
le fichier raw_data contient 34 fichier fastq 
```
### Download the reference genome from NCBI

```
#Using either datasets command from NCBI, or from NCBI web site https://www.ncbi.nlm.nih.gov/datasets/genome/, search for reference genome of : Bathycoccus prasinos
[noe@node02 ~]$ rsync -avz cd   -cd-progress storage:/projects/cibig25/SV_DATA/SHORT_READS/ /data/noe/OMICS/raw_data/
# on charge le module datasets
module load ncbi-datasets
puis on copie le dataset du genome pour le telecharger dans le dossier bank de OMICS 
datasets download genome accession GCF_002220235.1 --include gff3,genome,seq-report

#What are the formats of the files present in this directory ?
nous avons plusieurs fichier, 

cds_from_genomic.fna
GCF_002220235.1_ASM222023v1_genomic.fna
GCF_002220235.1_ASM222023v1_genomic.fna
genomic.gff
protein.faa
rna.fna
sequence_report.jsonl

#How many chromosomes does the reference file contain? 
[noe@node02 GCF_002220235.1]$ grep ">" GCF_002220235.1_ASM222023v1_genomic.fna | wc -l
il y 19 chromosome avec le chromosome mitochondrial et chloraplastique d'ou 21

omics/
├── banks
│   ├── GCF_002220235.1
│   │   ├── cds_from_genomic.fna
│   │   ├── GCF_002220235.1_ASM222023v1_genomic.fna
│   │   ├── genomic.gff
│   │   ├── protein.faa
│   │   ├── rna.fna
│   │   └── sequence_report.jsonl
│   └── ncbi_dataset.zip
├── logs
├── raw_data
│   ├── 1613_R1.fastq.gz
│   ├── 1613_R2.fastq.gz
│   ├── 1868_R1.fastq.gz
│   ├── 1868_R2.fastq.gz
│   ├── 4752_R1.fastq.gz
│   ├── 4752_R2.fastq.gz
│   ├── 5417_R1.fastq.gz
│   ├── 5417_R2.fastq.gz
│   ├── 685_R1.fastq.gz
│   ├── 685_R2.fastq.gz
│   ├── 716_R1.fastq.gz
│   ├── 716_R2.fastq.gz
│   ├── A1_R1.fastq.gz
│   ├── A1_R2.fastq.gz
│   ├── A8_R1.fastq.gz
│   ├── A8_R2.fastq.gz
│   ├── B1_R1.fastq.gz
│   ├── B1_R2.fastq.gz
│   ├── B8_R1.fastq.gz
│   ├── B8_R2.fastq.gz
│   ├── C218_R1.fastq.gz
│   ├── C218_R2.fastq.gz
│   ├── C2_R1.fastq.gz
│   ├── C2_R2.fastq.gz
│   ├── D119_R1.fastq.gz
│   ├── D119_R2.fastq.gz
│   ├── E2_R1.fastq.gz
│   ├── E2_R2.fastq.gz
│   ├── E318_R1.fastq.gz
│   ├── E318_R2.fastq.gz
│   ├── G11_R1.fastq.gz
│   ├── G11_R2.fastq.gz
│   ├── H44_R1.fastq.gz
│   └── H44_R2.fastq.gz
├── results
└── scripts

```
#### Quality Control of RNA-seq / DNA-seq Data with FastQC and MultiQC
```
# Fastq files checking

Go into the directory SHORT_READS and list the content of this directory - cd ls
How many files does it contain ? What is the format ?

/data/noe/OMICS/raw_data
on 34 fichier fastq

List the 10 first lines of one file - head zcat wc
[noe@node02 raw_data]$ zcat 1613_R1.fastq.gz |head -n10 

How many sequences are there in the first fastq file?
[noe@node02 raw_data]$ zcat 1613_R1.fastq.gz | grep "@M" |wc  -l
735803 sequences 

Estimate the depth coverage for this sample

coverage = nombre total de reads sequencés *(taille moyenne du read * 2 {R1,R2} / taille du genome complet
coverage = 735803 * (250 * 2) / 15000000 = 24 
 
# Running FastQC
Go into results directory and create the directory 1-FASTQC mkdir
mkdir /data/noe/OMICS/results/1-FASTQC
[noe@node02 results]$ module load MultiQC/1.9

Run FastQC on the first sample so that the output can be accessed in results/1-FASTQC directory
[noe@node02 raw_data]$ fastqc 1613_R1_fastqc.gz
1613_R1_fastqc.html
1613_R1_fastqc.zip
puis on copie les deux fichier dans le dossier /data/noe/OMICS/results/1-FASTQC

One you have checked it is running properly, run FastQC on all raw fastq files
[noe@node02 1-FASTQC]$ fastqc *fastq.gz -o /data/noe/OMICS/results/2-FASTQC/

One you have checked it is running properly, run FastQC on all raw fastq files
[noe@node02 1-FASTQC]$ multiqc . -o /data/noe/OMICS/results/1-MULTIQC/

├── multiqc_data
│   ├── multiqc_data.json
│   ├── multiqc_fastqc.txt
│   ├── multiqc_general_stats.txt
│   ├── multiqc.log
│   └── multiqc_sources.txt
└── multiqc_report.html

pour visualiser le fichier HTML il faut transferer sur l'ordinateur principal 
[noe@node02 results]$ rsync -ravz --progress /data/noe/OMICS/results/1-MULTIQC/ storage:/home/noe/

Quality Control of RNA-seq / DNA-seq Data with FastQC and MultiQC
Quality control (QC) is an essential step in the analysis of NGS data.
Two tools are commonly used:
FastQC --- individual analysis of FASTQ files
MultiQC --- aggregation and visualization of multiple QC reports (FastQC, alignment, quantification, etc.)

Go into the directory SHORT_READS and list the content of this directory - cd ls
How many files does it contain ? What is the format ?
```
```
#Comment aligner les lectures sur un génome de référence ?
## indexons le genome de reference avec la commande bwa-mem2 index
[noe@node02 banks]$ module load bwamem2/2.2.1
[noe@node02 banks]$ bwa-mem2 index ncbi_dataset/data/GCF_002220235.1/GCF_002220235.1_ASM222023v1_genomic.fna 

## faisons le mapping 
[noe@node02 2_mapping]$ bwa-mem2 mem /data/noe/OMICS_practice/banks/ncbi_dataset/data/GCF_002220235.1/GCF_002220235.1_ASM222023v1_genomic.fna /data/noe/OMICS_practice/raw_data/SHORT_READS/1613_R1.fastq.gz /data/noe/OMICS_practice/raw_data/SHORT_READS/1613_R2.fastq.gz -o ../../results/2_mapping/1613.sam 
#covertissons le fichier sam generer en bam 
samtools view -b 1630.sam > 1630.bam
# verifions les statistiques du mapping 
[noe@node02 script]$ samtools flagstat -@ 2 1613.bam >1613.tsv

recuperons les read qui ont mapper proprement 
[noe@node02 read.map]$ samtools view -b ../1613.bam -o 1613.paired.properly.bam
#Trier et indexer le fichier bam final
pour trier : 
 samtools sort 1613.paired.properly.bam -o 1613.sorted.bam
 
pour indexer : 
 samtools index 1613.sorted.bam 
 ````
## SNP CALLING 
```
# Nous testons le protocole d'appel SNP uniquement avec deux échantillons avant de l'exécuter sur tous les échantillons
1. Référence d'index avecsamtools faidx
[noe@node01 3_SNP]$ samtools faidx /data/noe/OMICS_practice/banks/ncbi_dataset/data/GCF_002220235.1/GCF_002220235.1_ASM222023v1_genomic.fna
2. Générez un fichier bcf (format BCF) en utilisant bcftools mpileup
Cette étape regarde chaque position du génome et compte combien de A, T, C, G il y a dans tes fichiers BAM.
 bcftools mpileup -f ../../banks/ncbi_dataset/data/GCF_002220235.1/GCF_002220235.1_ASM222023v1_genomic.fna ../2_read_map/mapped.only/1613.sorted.bam -Ob -o ../3_SNP/1613.bcf
3. Effectuer l'appel de SNP à l'aide debcftools call
[noe@node01 3_SNP]$ bcftools call -mv 1613.bcf -Ov -o 1613.vcf


```
## Analyse VI-SNP
```
1. Quelques statistiques sur les SNP avec bcftools et plink
Comptez le nombre de variantes avecbcftools stat
[noe@node01 3_SNP]$ more SNP.stat.txt

2. filtrons les reads de bonnes qualité 

```




```

## Day 3 : creation d'algo dans le termnal linux
```

```
