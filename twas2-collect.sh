#!/bin/bash
# 29-6-2016 MRC-Epid JHZ

src=$1

echo "SNP_name SNP_pos Ref_Allele Alt_Allele Z-Score r2pred" > $src.imp
grep -H gene $src/*/*imp | grep gene_exp | awk '!/nan/' | sed -e 's/.imp//g;s/:gene_exp//g;s\/\ \g' >> $src.imp

# alternative form
# grep -H gene $src/*/*imp | grep gene_exp | awk '!/nan/{gsub(/.imp|:gene_exp/,"",$0);print}'|sed 's\/\ \g' > $src.imp
