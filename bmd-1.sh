#!/bin/sh
# 9-6-2016 MRC-Epid JHZ

# annotation, PLINK and working directories
ad=/gen_omics/data/3-2012
pd=/gen_omics/data/EPIC-Norfolk/plink
wd=/genetics/data/CGI/TWAS-pipeline

cd $wd/bmd
awk '($1==gene)' gene=$1 $ad/gene_pos.txt | awk -v ad=$ad -v pd=$pd -v wd=$wd '
{
    FS="\t"
    gene=$1
    chr=$2
    start=$3
    end=$4
    t=sprintf("%s/chr%d",pd,chr)
# data extraction
    system(sprintf("plink2 --bed %s.bed --bim %s.bim --fam EPICNorfolk.fam --keep bmd.id --chr %d --from-bp %ld --to-bp %ld --recode --out %s",t,t,chr,start,end,gene))
# weight generation
    system(sprintf("TWAS_get_weights.sh %s twas/%s", gene, gene))
# zscore selection
    system(sprintf("echo SNP_ID SNP_Pos Ref_Allele Alt_Allele Z-score > %s.zscore", gene))
    system(sprintf("sort -k2,2n %s/genes/%s > %s",ad,gene,gene))
    system(sprintf("join -j 2 bmd-%d.zscore %s | awk -f %s/swap.awk >> %s.zscore",chr,gene,wd,gene))
# imputation
    system(sprintf("TWAS.sh twas/%s %s.zscore twas/%s",gene,gene,gene))
}'
