#!/bin/bash
# 27-6-2016 MRC-Epid JHZ

TWAS=$1
TWAS2=$2
dir=$3
pop=$4
start=$5
s=25

cd $dir/$pop
awk '(NR>=(v-1)*s+1 && NR<=v*s)' v=$start s=$s $TWAS/$pop.lst | awk -vTWAS=$TWAS -vTWAS2=$TWAS2 -vpop=$pop '
{
    gene=$1
    filename=sprintf("%s/WEIGHTS_%s/%s/%s.wgt",TWAS,pop,gene,gene)
# zscore setup
    system(sprintf("echo SNP_ID SNP_Pos Ref_Allele Alt_Allele Z-score > %s.zscore",gene))
    system(sprintf("sort -k1,1 %s.map > %s",filename,gene))
    system(sprintf("join -j 1 %s twas2.txt | sort -k2,2n | awk -f %s/twas2-swap.awk >> %s.zscore",gene,TWAS2,gene))
# imputation
    system(sprintf("TWAS.sh %s %s.zscore %s",filename,gene,gene))
    system(sprintf("rm %s %s.zscore",gene,gene))
}'
