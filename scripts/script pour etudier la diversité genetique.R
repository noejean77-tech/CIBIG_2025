library("dplyr")
library("tidyr")
library("ggplot2")
library("adegenet")
library("ape")
library("vcfR")
getwd()
#Telechargeons données d'entrée dans R 
## creons les donnsiers d'entrée et de sortir 
dataDir<- "input" 
outDir<- "outdir"
dir.create(dataDir)
dir.create(outDir)

# Loading les données dans les dossiers 
# telechargeons les fichiers de données 
unzip(zipfile = "coding_data_CIBIG25.zip",
      exdir = dataDir, junkpaths = F)
# jetons un oeil au fichier qui ont été creer dans le fichier zip 
list.files(dataDir, recursive = T)

#Chargeons les métadonnées des souches d'algues et inspectons la données (str, class)
metadata<- read.csv("input/coding_data_CIBIG25/metadata_algae.tsv", sep = "\t", header = T, check.names = F)
str(metadata) 
View(metadata)
class(metadata)
head(metadata)

# Examination de la diversité genetique.
## Chargement des données du fichier vcf et extraction d'une matrice SNP
### Lister les fichiers de notre jeu de données à l'aide de `list.files`
list.files(dataDir,recursive = T)

###Recupérer le fichier `.vcf.gz` contenant les informations de génotype.
VCFdata<- read.vcfR("input/coding_data_CIBIG25/all_samples.vcf.gz", verbose = F )
VCFdata
str(VCFdata)
head(VCFdata)
summary(VCFdata)

# Effectuez une ACP avec les données de génotypes 
#et représentez graphiquement la diversité génétique inférée.
## extrayons les genotype "GT" dans le fichier VCFdata

gt<- extract.gt(VCFdata, element = "GT")
gt
head(gt)
View(gt)
#Convertir les génotypes en valeurs numériques (ex. : 0/0 → 0, 0/1 → 1, 1/1 → 2)
# approche courantes pour les genotypes diploides 
gt_numeric<- apply(gt,MARGIN = 2, function(x) { 
  x<- gsub("0/0", 0, x)
  x<- gsub("0/1",1,x )
  x<- gsub("1/1", 2, x)
  x<- gsub("./.", NA,x)
  as.numeric(x)
  })
gt_numeric
head(gt_numeric)
View(head(gt_numeric))
#Pour que les fonctions suivantes fonctionnent, nous devons transposer le tableau :
genotype_matrix<- t(x = gt_numeric)

head(genotype_matrix)
View(genotype_matrix)  
View(gt_numeric)
dim(genotype_matrix)

# Calculer l'ACP avec prcomp
pca_result<- prcomp(x = genotype_matrix, scale. = F)
pca_result
summary(pca_result)
pca_result$x
pca_result$sdev
# Réexamen des résultats de l'ACP avec des graphiques ggplot2
##Pour passer à ggplot2, nous devons d'abord préparer un tableau de données 
##(data frame) qui combine les coordonnées de la PCA et vos métadonnées.
## extraire les score de la PCA dans un dataframe
pca_score<- as.data.frame(pca_result$x)
pca_score
plot(pca_score$PC1,pca_score$PC3) # voir la distribution des points en fonctions des axes PC
 
### Ajoutons une colonne avec les noms des souches 
pca_score
pca_score$strain.id<- rownames(pca_score)
pca_score

### Fusionner avec les métadonnées
metadata$strainId %in% pca_score$strain.id # Verifions si les noms des souches est identique dans les deux et se correspond 
metadata$strainId
metadata$strainId<- gsub("RCC","", metadata$strainId) ## remplacons RCC par rien dans l'id de l'echantillons portant RCC 
#### effectuons la fusion 
pcaFinal<- left_join(x = pca_score, y = metadata, by =join_by("strain.id"=="strainId"))
pcaFinal
View(pcaFinal)

#graphique ggplot 
pp1 <- ggplot(data = pcaFinal, aes(x = PC1, y = PC3, colour = Sampling_site, shape = Species)) +
  geom_point(size = 5,alpha = 0.3) + # On ajoute les points sinon le graphique sera vide
  theme_classic()

pp1
pp2 <- ggplot(data = pcaFinal,
             mapping =  aes(x = PC1,
                            y= PC2,
                            shape = Species,
                            color = Sampling_site)
) +
  geom_point(size = 5, alpha = 0.3) 
pp2   

#Visualisation de la structure genetique
## Représenter la proximité génétique des souches (PC1 vs PC3).
### Ajout des étiquettes d'échantillons (labels) avec ggrepel


library(ggrepel)  # On utilise ggrepel pour utiliser geom_text pour que R pousse les noms des souches
                  # automatiquement afin qu'ils ne se cachent pas les uns les autres.
pp1<- pp1 + geom_text_repel(mapping = aes(label = strain.id),
                          force = 20,     # force = 20 : augmente la distance entre le point et le texte.
                          max.overlaps = 30) + # max.overlaps = 30 : permet d'afficher les noms même dans les zones très denses.
  labs(title = "La diversité génétique des especes d'algues en partie par site d'échantillonnage") +
  theme_light() 
pp1

# chargeons le graphique dans le dossier 
jpeg(filename = paste0(outDir, "/pca_plot.jpg"),width = 750, height = 750)
pp1
dev.off()

## Arbre de distance des échantillons

#En biologie, les arbres sont couramment utilisés pour représenter les relations 
#entre divers échantillons.
#À l'aide du package ape, fréquemment employé en phylogénétique et en évolution, nous allons
#construire un arbre phénétique (basé sur les distances issues de données SNP). Attention, il 
#ne s'agit pas d'une phylogénie basée sur un modèle.

### calculons la matrix de distance 
library(ape) # chargeons le package ape 

matrix_dist<- dist(x = genotype_matrix, method = "euclidean")
# Création de l'objet de type 'phylo'
tree<- nj(X = matrix_dist)

# visualisation de l'arbre 
plot(tree)
tree$tip.label

# ajoutons des couleurs a notre arbre 
## recuperons le noms des souches par ordre 
tip_names<- tree$tip.label
# Créer une correspondance avec vos métadonnées
# On suppose que 'pcaFinal' contient déjà les couleurs ou les sites
# On crée un vecteur de couleurs basé sur le Sampling_site 

library(RColorBrewer)
n_sites <- length(unique(pcaFinal$Sampling_site))
n_sites
col_palette <- setNames(brewer.pal(n_sites, "Dark2"), unique(pcaFinal$Sampling_site))
 
# assosions chaque nom a une souche de couleurs 
tip_colors <- col_palette[pcaFinal$Sampling_site[match(tip_names, pcaFinal$strain.id)]]
tip_colors

# ouvrons une fenetre graphique 

par(mar = c(2, 2, 2, 10), xpd = TRUE)

# 2. On trace l'arbre
plot(tree, 
     tip.color = tip_colors, 
     cex = 0.8, 
     font = 2,
     adj = 0.5) # Aligne le texte au début des branches

# Ajoutons une légende pour les sites

legend("topright", 
       inset = c(-0.29, 0),    # Ajuste ce chiffre selon la largeur de ton écran
       legend = names(col_palette), 
       fill = col_palette, 
       title = "Sites",
       cex = 1, 
       bty = "n")             # Supprime le cadre de la légende


#-----------------------------------------------------------------------#
#Contrôle qualité (CQ) : Charger les résultats de flagstat              #
#-----------------------------------------------------------------------#

# affichons la liste des fichiers dans le dossier algae_flastats
list.files(path = "input/coding_data_CIBIG25/algea_flagstats",recursive = T)
flagstats_dir<- "input/coding_data_CIBIG25/algea_flagstats"

# ouvrons tous les fichiers contenu dans flagstats_dir avec lapply

mes_fichier<- list.files(path ="input/coding_data_CIBIG25/algea_flagstats",
                         pattern ="_flagstat",full.names = T )
df_list<- lapply(mes_fichier,function(f) {
  x<- read.delim(f, header = F, sep = "\t")
  x$strainId<- f
  x
} )


flagstats <- do.call(rbind, df_list)
#  Reformatons les données (Nettoyage) ous allons extraire les lignes importantes (généralement la ligne 1 pour le total et la ligne
#5 pour les lectures bien alignées) et nettoyer les noms de souches.

# 1. Nettoyer le nom de la souche pour enlever le chemin et l'extension
flagstats$strainId<- basename(flagstats$strainId)
flagstats$strainId<- gsub("_flagstat.tsv","",x = flagstats$strainId)

library(tidyverse)

# 1. On filtre les lignes qui nous intéressent dans V3
qc_clean <- flagstats %>%
  filter(grepl("total|mapped", V3, ignore.case = TRUE)) %>%
  # On ne garde pas les lignes qui expriment des pourcentages (%)
  filter(!grepl("%", V3))

# 2. On renomme et on nettoie
qc_clean <- qc_clean %>%
  select(count = V1, description = V3, strainId) %>%
  mutate(
    count = as.numeric(count),
    strainId = basename(strainId),
    # On simplifie les descriptions pour le futur graphique
    description = ifelse(grepl("total", description), "Total", "Mapped")
  )

# 3. Vérification
qc_clean

# On garde uniquement le Total et le Mapped principal
qc_final <- qc_clean %>%
  group_by(strainId, description) %>%
  summarize(count = max(count), .groups = 'drop')

# On affiche le résultat
print(qc_final)


# Extraire uniquement les pourcentages de mapping
mapping_quality <- flagstats %>%
  filter(grepl("primary mapped %", V3)) %>%
  select(strainId, mapping_percent = V1) %>%
  mutate(
    mapping_percent = as.numeric(mapping_percent),
    strainId = basename(strainId)
  )

# Visualisation rapide
ggplot(mapping_quality, aes(x = reorder(strainId, -mapping_percent), y = mapping_percent)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_hline(yintercept = 70, linetype = "dashed", color = "red") + # Seuil de qualité
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Efficacité du mapping par souche (%)",
       x = "Souches",
       y = "Pourcentage de mapping")
