#!/bin/sh
# 14-6-2016 MRC-Epid JHZ

cd /genetics/data/CGI/TWAS-pipeline
mkdir -p /scratch2/tempjhz22/bmi
ln -sf /scratch2/tempjhz22/bmi
cd bmi
wget http://www.broadinstitute.org/collaboration/giant/images/1/15/SNP_gwas_mc_merge_nogc.tbl.uniq.gz
wget http://www.broadinstitute.org/collaboration/giant/images/f/f0/All_ancestries_SNP_gwas_mc_merge_nogc.tbl.uniq.gz
ln -sf SNP_gwas_mc_merge_nogc.tbl.uniq.gz BMI-EUR.gz
ln -sf All_ancestries_SNP_gwas_mc_merge_nogc.tbl.uniq.gz BMI-ALL.gz

gunzip -c BMI-EUR.gz | awk '(NR>1)' | sort -t$'\t' -k1,1 > t.txt
awk '(NR>1)' /gen_omics/data/3-2012/legend.txt | sort -t$'\t' -k1,1 | awk '($1!=".")'> snp.txt
join -j 1 -t$'\t' snp.txt t.txt | sort -t$'\t' -n -k2,2n -k3,3n > BMI-EUR.txt
