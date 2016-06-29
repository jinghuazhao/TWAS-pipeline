#!/bin/bash
# 29-6-2016 MRC-Epid JHZ

TWAS=$1
TWAS2=$2
dir=$3
pop=$4
gs=$5

cd $dir/$pop
awk -vgs=$gs '($1==gs)' $TWAS/$pop.lst | awk -vTWAS=$TWAS -vTWAS2=$TWAS2 -vpop=$pop '
{
    gene=$1
    filename=sprintf("%s/WEIGHTS_%s/%s/%s.wgt",TWAS,pop,gene,gene)
# zscore setup
    system(sprintf("echo SNP_ID SNP_Pos Ref_Allele Alt_Allele Z-score > %s.zscore",gene))
    system(sprintf("sort -k1,1 %s.map > %s",filename,gene))
    system(sprintf("join -j 1 %s tgwas2.txt > %s.join",gene,gene))
    system(sprintf("sort -k2,2n %s.join > %s.sort",gene,gene))
    system(sprintf("awk -f %s/twas2-swap.awk %s.sort >> %s.zscore",TWAS2,gene,gene))
# imputation
    system(sprintf("TWAS.sh %s %s.zscore %s",filename,gene,gene))
}'
