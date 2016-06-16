#!/bin/sh
# 31-5-2016 MRC-Epid JHZ

cd /genetics/data/CGI/TWAS-pipeline/bmd
gwas_output=bmd-$1
gunzip -c TBBMD.gz | awk -v chr=$1 '
  {
     FS=OFS="\t"
     if(NR==1) print "SNP_ID", "SNP_Pos", "Ref_Allele", "Alt_Allele", "Z-score"
     else {
       if($3==chr) print $1,$4,$8,$9,$11/$12
     }
  }'  | awk '(NR>1)' | sort -k2,2 > ${gwas_output}.zscore
