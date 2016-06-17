# 15-6-2016 MRC-Epid JHZ

# source (EUR, ALL)
src=$1

# grep -H gene $src/*/*imp | grep gene_exp | awk '!/nan/{gsub(/.imp|:gene_exp/,"",$0);print}'|sed 's\/\ \g' > bmi-$src.imp
grep -H gene $src/*/*imp | grep gene_exp | awk '!/nan/' | sed -e 's/.imp//g;s/:gene_exp//g;s\/\ \g' > bmi-$src.imp

