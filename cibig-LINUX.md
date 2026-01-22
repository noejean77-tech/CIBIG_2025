# LINUX PRATICE

## DAY 1

### Connect to wave cluster

```
ssh noe@160.120.108.164 : Cluster Master
lancer : srun -c 2 -p normal --pty bash -i

ne jamais travailler sur le Cluster master, 
il faut travailler sur les nodes
`

### pwd command

to know where I am on linux
```

```
$ls
Bureau         Edraw       Images           PyCharmMiscProject
DEV            gems        jalview          Rice
Documents      id_rsa      LINUX-TP.tar.gz  snap
Documents.ged  id_rsa.ppk  Modèles          Téléchargements
Downloads      id_rsa.pub  Musique          Vidéos
DRIVE_IRD      igv         Public
christine@MPLCLTPO1577:~$ 
````
```
```
## DAY2
```
pwd : connaitre l'endroit ou je suis 
cd: se depalcer d'un 
ls, ls -l, ls -lh : lister un dossier
### Connexion au serveur WAVE
```
```  
$ ssh node06
The authenticity of host 'node06 (192.168.10.6)' can't be established.
ED25519 key fingerprint is SHA256:avzUmE6zEb71pHNmZn75f45zwfKZWe8N+Y49AtCir1c.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'node06' (ED25519) to the list of known hosts.#

```

### Pratice 4 : List the files using ls command
```
#List the content of your home directory
[noe@node06 ~]$ ls
LINUX-TP  LINUX-TP.tar.gz  scripts  ssh-noe.zip

#List the content of the directory Fasta 
by using its absolute path in first then 
its relative path - ls command

chemin absolu: [noe@node06 ~]$ ls /home/noe/LINUX-TP/Fasta
C_AllContigs.fasta  contig_tgicl.fasta  enterobacteries.fasta  sequence.fasta  uniprot_sprot.fasta

chemin relatif: [noe@node06 ~]$ ls LINUX-TP/Fasta/
C_AllContigs.fasta  contig_tgicl.fasta  enterobacteries.fasta  sequence.fasta  uniprot_sprot.fasta

#List the content of the directory Data with the ls command and the option -R

[noe@node06 ~]$ ls -R /home/noe/LINUX-TP/Data/[noe@node06 ~]$ ls -R /home/noe/LINUX-TP/Data/
#List the content of the directory Bank with the ls command and the option -al or -a -l
[noe@node06 ~]$ ls -al /home/noe/LINUX-TP/Bank/
```

### Practice 5 : List the files using ls command and wildcards *
```
#List the content of the directory T-coffee. Are there only fasta files ? - ls command
[noe@node06 ~]$ ls LINUX-TP/Data/T-coffee/ -l
[noe@node06 ~]$ ls LINUX-TP/Data/T-coffee/*.fasta -l
[noe@node06 ~]$ ls LINUX-TP/Data/T-coffee/*.fasta | wc -l : compter le nombre de fichier fasta 

#List only the files starting by sample (in the directory T-coffee ) - ls command & *
[noe@node06 ~]$ ls -l LINUX-TP/Data/T-coffee/*sample_*
[noe@node06 ~]$ ls -l LINUX-TP/Data/T-coffee/sample_*

#List only the files with the fasta extension (in the directory T-coffee ) - ls command & *
[noe@node06 ~]$ ls -l LINUX-TP/Data/T-coffee/*.fasta
[noe@node06 ~]$ ls -l LINUX-TP/Data/T-coffee/*fasta
```
### Practice 6 : Moving into file system using cd and ls command
```
#Go to the directory Script and check in the prompt you have correctly changed your working directory (pwd).
List the dir content with ls.
Go to the Fasta directory using ../
Go to the Fastq directory . From this directory, and without any change in your working dir, list what's in samBam directory
List vcfdirectory using -R option. What is there in this dir ?
Come back to the home directory.
ls
cd ../
../
ls -R
ls -al
```

### Practice 7 : Manipulating Files and Directories

```
#Create a subdirectory called Rice_sequencing_ONT in the directory LINUX_TP with the mkdir command.
[noe@node01 LINUX-TP]$ mkdir LINUX-TP/Rice_sequencing_ONT

#Move all the files started by Oglab_var1 into this new directory with the mv command.
(reverse-i-search)`mv': mv LINUX-TP/Oglab_var1* ~/LINUX-TP/Rice_sequencing_ONT/

#List the content of LINUX-TP and Rice_sequencing_ONT with the ls command.
[noe@node01 ~]$ ls LINUX-TP
[noe@node01 ~]$ ls LINUX-TP/Rice_sequencing_ONT/

#Create a subdirectory called BlastAnalysis in the directory /scratch/<PUT YOUR_LOGIN> with the mkdir command.
 cd /
 mkdir data/noe/BlastAnalysis
 
 #Copy all the files started by Oglab_var1 in the directory BlastAnalysis with the cp command
 cp -r /home/noe/LINUX-TP/Rice_sequencing_ONT/Oglab_var1* ~/ data/noe/BlastAnalysis/
 [tranchant@node01 BlastAnalysis]$ cp /home/tranchant/LINUX-TP/Rice_sequencing_ONT/Oglab_var1_* /data/tranchant/BlastAnalysis/
 h 34
[tranchant@node01 BlastAnalysis]$ cp /home/tranchant/LINUX-TP/Rice_sequencing_ONT/Oglab_var1_* .

 
 #List the content of the BlastAnalysis and Rice_sequencing_ONT directories. What are the differences between mv and cp?
 mv : couper coller ou deplacer un fichier , pour les fichiers de petits volumes  
 cp : copier et coller un dossier , utliser les fichiers lourds imperativement 
 
 #Remove the files Oglab_var1_cds.fna and Oglab_var1_genome_v1.fasta in the directory BlastAnalysis with the rm command.
 [noe@node01 /]$ rm data/noe/BlastAnalysis/Oglab_var1_cds.fna data/noe/BlastAnalysis/Oglab_var1_genome_v1.fasta
 tranchant@node01 BlastAnalysis]$ rm Oglab_var1_cds.fna Oglab_var1_genome_v1.fasta 
 
 #Copy the whole directory T-coffee with the name T-coffee-copyinto the directory LINUX-TP.
 [noe@node01 ~]$ cp -r LINUX-TP/Data/T-coffee ~/LINUX-TP/T-coffee-copy
 $ cp /home/tranchant/LINUX-TP/Data/T-coffee/ /home/tranchant/LINUX-TP/T-coffee-copy/ -r
[tranchant@node01 LINUX-TP]$ ls

 #After checking the content of the directory LINUX-TP, remove the directory T-coffee-copy. How to remove a directory ?
  rm -r LINUX-TP/T-coffee-copy on doir ajouter le -r lorsqu'il s'agit de supprimer de supprimer un dossier
  
  #Remove all the files into the directory T-coffee-copy with the rm * command after moving in the correct directory. BE CAREFUL !
  [noe@node01 ~]$ rm -r LINUX-TP/T-coffee-copy 
```

## DAY3
```
afficher le contenu d'un fichier
cat : utile pour les petits fichier 
more ou less: affiche le contenu d'un fichier page par page et on peut faire des filtre a partir de /
head: affiche par defaut les 10 1ere lignes
tail:
wc ; wc -l *: lister tout les fichiers qui sont dans le dossier (*)

rechercher un mot dans un fichier text 
grep "" file : toujours inserer les quotes et ne jamais utiliser sans les quotes

#Practice 8 : Searching with grep
#List the files of the zip file with the command unzip -l file_name
unzip ncbi_dataset.zip

#Display the firsts and lasts lines of the gff file - head tail
head genomic.gff
more genomic.gff

#Search for only the lines with the word gene in the gff file - grep
grep "gene" genomic.gff

#Count the number of genes - grep -c
[tranchant@node07 GCF_034140825.1]$ grep -v "#" genomic.gff | cut -f3 | grep "gene" | sort | uniq
gene
pseudogene
[tranchant@node07 GCF_034140825.1]$ grep -v "#" genomic.gff | cut -f3 | grep "gene" | sort | uniq -c
  37483 gene
  [tranchant@node07 GCF_034140825.1]$ grep "\sgene\s" genomic.gff  -c
```
```
#Go to the Bank directory and list its contents.
copy the uniprot_plant.fasta file from the /scratch/SHARED directory into the Bank directory
[noe@node01 BlastAnalysis]$ cp uniprot_sprot.fasta /data/noe/BlastAnalysis/

#count the number of sequences in this databank - grep
grep ">" uniprot_sprot.fasta -c

#List the content of the directory to check if the database has been indexed
avant de faire un blast il faut toujours faire une endexation de la base 
avec la commande makeblast:  makeblastdb -in uniprot_sprot.fasta -dbtype prot -parse_seqids
uniprot_sprot.fasta.pin  uniprot_sprot.fasta.pot  uniprot_sprot.fasta.pto
uniprot_sprot.fasta.pdb  uniprot_sprot.fasta.pog  uniprot_sprot.fasta.psq
uniprot_sprot.fasta.phr  uniprot_sprot.fasta.pos  uniprot_sprot.fasta.ptf
```
## DAY 4
## Module cluster
```
```
### pratice 2
```
comment visualiser toutes les analyse qui tourne sur le cluster : squeue
[noe@master ~]$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
               352    normal     bash  dansouk  R    1:03:42      1 node01
               354    normal     bash  dansouk  R    1:01:51      1 node01
               359    normal     bash  dansouk  R      42:42      1 node01
               360    normal     bash   onilee  R      23:20      1 node01
filtrer les analyses d'un utilisateur :
[noe@master ~]$ squeue -u onilee
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
               360    normal     bash   onilee  R      28:39      1 node01
si on veut s'interesser a des informations specifiques 
[noe@master ~]$ squeue -O "username,name:40,partition,nodelist,numCPUs,state,timesed,timelimit"
squeue: error: Invalid job format specification: timesed
USER                NAME                                    PARTITION           NODELIST            CPUS                STATE               TIME_LIMIT
dansouk             bash                                    normal              node01              4                   RUNNING             14-00:00:00
dansouk             bash                                    normal              node01              4                   RUNNING             14-00:00:00
dansouk             bash                                    normal              node01              4                   RUNNING             14-00:00:00
onilee              bash                                    normal              node01              4                   RUNNING             14-00:00:00

connaitre le nom du server 
[noe@master ~]$ hostname
master

comment reserver un node : 
[noe@master ~]$ hostname
master
reserver un node de la partition normale (node02)
[noe@master ~]$ srun -p short --nodelist=node02 hostname
node02

comment se connecter a un node: 
[noe@master ~]$ srun -p short -c 2 --pty bash -i
[noe@master ~]$ srun -p short -c 2 --pty bash -i
[noe@node01 ~]$

verifier le nombre de cpu et le numero de node
[noe@node01 ~]$ squeue -u noe -O "NumCPUs,nodelist"
CPUS                NODELIST
2                   node01

[noe@node01 ~]$ squeue -O "username,NumCPUs,nodelist"
USER                CPUS                NODELIST
dansouk             4                   node01
dansouk             4                   node01
onilee              4                   node01
zongo               4                   node01
ouedraogo           2                   node02
admin               2                   node01
sory                2                   node01
ky                  2                   node01
annang              2                   node01
dansouk             2                   node01
tonde               2                   node01
noe                 2                   node01
kiendrebeogo        2                   node01
abegunde            2                   node02

```
### pratice 3
```
comment transferer nos donné entre deux machines (pc et storage)
rsync -ravz --progress source destination
rsync -ravz --progress 160.120.108.168:/path/folder_to_copy local_folder
noe@DESKTOP-2KUFPEP:~$ rsync -ravz --progress cibig_noe noe@160.120.108.168:/home/noe
The authenticity of host '160.120.108.168 (160.120.108.168)' can't be established.
ED25519 key fingerprint is SHA256:NMgAzq69R5gpep7GQ7qJSNlIQinOuI3DE6bp9RHoCaY.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '160.120.108.168' (ED25519) to the list of known hosts.
noe@160.120.108.168's password:
sending incremental file list
cibig_noe/

sent 71 bytes  received 20 bytes  6.74 bytes/sec
total size is 0  speedup is 0.00
server storage :  noe@160.120.108.168

comment transferer du storage au pc 
noe@DESKTOP-2KUFPEP:~$ rsync -ravz --progress  noe@160.120.108.168:/projects/SLURM/TP.txt /home/noe
noe@160.120.108.168's password: Inspecteur@77
receiving incremental file list
TP.txt
             30 100%   29.30kB/s    0:00:00 (xfr#1, to-chk=0/1)

sent 43 bytes  received 141 bytes  8.56 bytes/sec
total size is 30  speedup is 0.16

noe@DESKTOP-2KUFPEP:~$ nano TP.txt: connaitre le contenu du fichier

Transfert de donné entre le storage et le node
[noe@node01 SHARE]$ rsync -ravz progress storage:/projects/SLURM/SHARE .

[noe@master ~]$ srun -p short -c 2 --nodelist=node01 --pty bash -i: pour ce connecter directement sur le node qu'on a travailler 

```
### Pratice 4 : module environment

```
module whatis 
module avail
module list
module load blast/2.12.0+
[noe@node01 SHARE]$ makeblastdb -in uniprot_plant.fasta -dbtype prot -parse_seqids : pour faire l'indexage d'une base de donnée 
[noe@node01 SHARE]$ makeblastdb -in uniprot_plant.fasta -dbtype prot -parse_seqids


Building a new DB, current time: 11/28/2025 11:53:37
New DB name:   /data/noe-2025-11-28/SHARE/uniprot_plant.fasta
New DB title:  uniprot_plant.fasta
Sequence type: Protein
Keep MBits: T
Maximum file size: 1000000000B
Adding sequences from FASTA; added 23183 sequences in 0.461013 seconds.


[noe@node01 SHARE]$ ls
Oglab_var1_cds.fna             uniprot_plant.fasta.pdb  uniprot_plant.fasta.pos  uniprot_plant.fasta.pto
Oglab_var1_cds.only1000.fasta  uniprot_plant.fasta.phr  uniprot_plant.fasta.pot
Oglab_var1_genome_v1.fasta     uniprot_plant.fasta.pin  uniprot_plant.fasta.psq
uniprot_plant.fasta            uniprot_plant.fasta.pog  uniprot_plant.fasta.ptf

faire un blastx
[noe@node01 SHARE]$ blastx -query Oglab_var1_cds.only1000.fasta -db uniprot_plant.fasta -num_threads 2 -outfmt "6 qseqid sseqid sacc stitle  pident length mismatch gapopen qstart qend sstart send evalue bitscore" -max_target_seqs 5 -out Oglab_var1_cds.VS.uniprot.blastx.csv2
1. query id
2. subject id
3. percent identity
4. alignment length
5. number of mismatche-
6. number of gap openings
7. query start
8. query end
9. subject start
10. subject end
11. expect value
12. bit score

pour transferer le resultat de notre blast dans le storage : 
[noe@node01 SHARE]$ rsync -ravz --progress Oglab_var1_cds.VS.uniprot.blastx.csv storage:/home/noe
Oglab_var1_cds.VS.uniprot.blastx.csv  uniprot_plant.fasta.pdb     uniprot_plant.fasta.pog  uniprot_plant.fasta.psq
[noe@node01 SHARE]$ rsync -ravz --progress Oglab_var1_cds.VS.uniprot.blastx.csv storage:/home/noe
sending incremental file list

sent 90 bytes  received 12 bytes  204.00 bytes/sec
total size is 1,192,794  speedup is 11,694.06
```
### creer un job sur un cluster
