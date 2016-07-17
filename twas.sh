#!/bin/bash
# 17-7-2016 MRC-Epid JHZ

if [ $# -lt 1 ] || [ "$1" == "-h" ]; then
    echo "Usage: twas.sh <input>"
    echo "where <input> is in tab-delimited format:"
    echo "SNP_name SNP_pos Ref_allele Alt_allele Beta SE"
    echo "The output is contained in <input>.imp"
    exit
fi
echo $(basename $0) $1 
echo TWAS-pipeline:
echo Step 1 - specify locations of TWAS and TWAS-pipeline
TWAS=/genetics/bin/TWAS
TWAS2=/genetics/bin/TWAS-pipeline
echo Step 2 - reformat input
rt=$1
awk ' (NR>1) {
  FS=OFS="\t"
  $2=toupper($2)
  $3=toupper($3)
  print $1, $2, $3, $4, $5/$6
}' $1 | sort -k1,1 > $1.input
echo Step 3 - make population-specific twas2.txt with cleaned Z-scores
dir=`pwd`/TWAStmp/$(basename $1)
for pop in MET NTR YFS
do
  if [ ! -d $dir/$pop ]; then
     mkdir -p $dir/$pop
  fi
  join -1 2 -2 1 $TWAS/$pop.bim $1.input | awk -f $TWAS/CLEAN_ZSCORES.awk | awk '{$2="";print}' > $dir/$pop/twas2.txt
done
echo Step 4 - perform analysis
parallel -j8 -S b01,b02,b03,b04,b05,b06 twas2.sh {1} {2} {3} {4} {5} ::: $TWAS ::: $TWAS2 ::: $dir ::: MET NTR YFS ::: $(seq 1000)
echo Step 5 - collect results
twas2-collect.sh $(basename $1)
echo Step 6 - tidy up
rm -rf $dir $1.input
