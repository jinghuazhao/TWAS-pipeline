#!/bin/sh
# 1-6-2016 MRC-Epid JHZ

# SNP-gene annotation, EPIC-Omics PLINK, and working directories
ad=/gen_omics/data/3-2012
pd=/gen_omics/data/EPIC-Norfolk/plink
wd=/genetics/data/CGI/TWAS-pipeline/bmd

cd $wd
# to loop over all genes for several tasks
for g in `sort $ad/genes-$1.txt | awk '{print $1}'`
do
    # to obtain SNP names from the SNP-position pair
    awk '{print $1}' $ad/genes/$g > $g
    n=`wc -l $g `
    if [[ $n != 0 ]]; then 
    # to extract genotypes for the gene into the current directory
    plink2 --bed $pd/chr$1.bed \
           --bim $pd/chr$1.bim \
           --fam $wd/EPICNorfolk.fam \
           --keep $wd/bmd.id \
           --extract $g \
           --recode \
           --out $g
    # to get weights into twas directory
    TWAS_get_weights.sh $g twas/$g
    # to select gene-specific z-scores
    echo "SNP_ID SNP_Pos Ref_Allele Alt_Allele Z-score" > $g.zscore
    sort -k2,2 $ad/genes/$g > $g
    join -j 2 bmd-$1.zscore $g | awk '{t=$1; $1=$2; $2=t; $NF=""; print}'>> $g.zscore
    fi
    # to impute using weights and summary statistics into twas
    TWAS.sh twas/$g $g.zscore twas/$g
    rm $g.bed $g.bim $g.fam 
done

# to see a vanilla code, simply employ the following command:
# awk '!/#/' twas.sh

