# PROJECT OMICS PATHOGENE GROUP 

## controlons la qualité de notre donnée fasta  
```
module load nanoplot/1.41.3
NanoPlot -t 4 --fastq RAW_DATA/barcode01.fastq -o 1-QC/barcode01
.
├── 1-QC
│   └── barcode01
│       ├── LengthvsQualityScatterPlot_dot.html
│       ├── LengthvsQualityScatterPlot_dot.png
│       ├── LengthvsQualityScatterPlot_kde.html
│       ├── LengthvsQualityScatterPlot_kde.png
│       ├── NanoPlot_20251206_1057.log
│       ├── NanoPlot-report.html
│       ├── NanoStats.txt
│       ├── Non_weightedHistogramReadlength.html
│       ├── Non_weightedHistogramReadlength.png
│       ├── Non_weightedLogTransformed_HistogramReadlength.html
│       ├── Non_weightedLogTransformed_HistogramReadlength.png
│       ├── WeightedHistogramReadlength.html
│       ├── WeightedLogTransformed_HistogramReadlength.html
│       ├── WeightedLogTransformed_HistogramReadlength.png
│       ├── Yield_By_Length.html
│       └── Yield_By_Length.png
└── RAW_DATA
    ├── barcode01.fastq
    ├── barcode02.fastq
    ├── barcode03.fastq
    ├── barcode04.fastq
    ├── barcode05.fastq
    └── barcode06.fastq
```
## remove the host (supprimons le genome de reference)
### cleannig (netoyons notre read)
```
#telechargeons le genome de reference

datasets download genome accession GCA_002525835.2 --include genome : genome de reference 
unzip ncbi_dataset.zip  : deziper le fichier zip recu  apres telechargement du genome de reference 
minimap2 -t 4 -a -x map-ont bank/GCA_002525835.2_ipoBat4_genomic.fna RAW_DATA/barcode01.fastq -o 2-cleaning/barcode01.mapped.sam : supprimer les read qui map avec le genome de reference (sam) 

# verifiosn le pourcentage des reads qui ont mapper avec le genome de reference 
samtools flagstat 2-cleaning/barcode01.mapped.sam : verifier le pourcentage de read qui a mapper avec le genome de reference  
[noe@node02 OMICS_PROJECTS]$ samtools flagstat 2-cleaning/barcode01.mapped.sam
1081807 + 0 in total (QC-passed reads + QC-failed reads)
181316 + 0 primary
366555 + 0 secondary
533936 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
1052991 + 0 mapped (97.34% : N/A)
152500 + 0 primary mapped (84.11% : N/A)
0 + 0 paired in sequencing
0 + 0 read1
0 + 0 read2
0 + 0 properly paired (N/A : N/A)
0 + 0 with itself and mate mapped
0 + 0 singletons (N/A : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)

# Obtenons que les reads qui n'ont pas mapper 
samtools view -@ 4 -f 4 -b 2-cleaning/barcode01.mapped.sam > 2-cleaning/barcode.01.unmapped.bam : on filtre de telle sorte qu'on obtiens que les reads qui n'ont pas mapper avec le genome de reference 

# convertissons le fichier des read unmapped en fastq pour faire l'assemblage
[noe@node02 OMICS_PROJECTS]$ samtools fastq 2-cleaning/barcode.01.unmapped.bam > 2-cleaning/barcode01.unmapped.fastq
```
## Classification taxonomique des reads unmapped sur Kraken
```
# tout d'abord convertissons nos fichier unmapped.bam en fastq 
[noe@node01 2_mapping]$ samtools fastq Barcode01.unmapped.bam > Barcode01.unmapped.fastq
# classification tanonomique 
telechargons la base de données que nous allons utilisé pour l'assignement taxonomique kraken sur le site: 
https://benlangmead.github.io/aws-indexes/k2 
https://genome-idx.s3.amazonaws.com/kraken/k2_pluspfp_16_GB_20251015.tar.gz # base de donnée PlusPFP-16
[noe@node01 3_class_taxo_reads]$ kraken2 --threads 4 --db ../../banks/db ../../results/2_mapping/Barcode01.unmapped.fastq --report Barcode01_kraken_report.txt --output barcode01_kraken_output.txt

```

## Assemblage de novo (pas de reference)
```
module load flye/2.9.6-b1802
[noe@node02 OMICS_PROJECTS]$ flye --meta -t 4 --nano-raw 2_mmapping/barcode01.unmapped.fastq -o 3_assemblage/barcode01


````
