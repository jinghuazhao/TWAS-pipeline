#!/bin/bash
# 29-6-2016 MRC-Epid JHZ

src=$1

echo "Pop Gene Z_Score r2pred" > $src.imp
grep -H gene $src/*/*imp | grep gene_exp | awk '!/nan/' | sed -e 's/.imp//g;s/:gene_exp//g;s\/\ \g' | awk '{print $2,$3,$7,$8}'>> $src.imp

# alternative form
# grep -H gene $src/*/*imp | grep gene_exp | awk '!/nan/{gsub(/.imp|:gene_exp/,"",$0);print}'|sed 's\/\ \g' > $src.imp
