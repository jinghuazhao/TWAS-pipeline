#!/bin/bash
# 27-6-2016 MRC-Epid JHZ

mkdir -p bmi
cd bmi
wget http://www.broadinstitute.org/collaboration/giant/images/1/15/SNP_gwas_mc_merge_nogc.tbl.uniq.gz
wget http://www.broadinstitute.org/collaboration/giant/images/f/f0/All_ancestries_SNP_gwas_mc_merge_nogc.tbl.uniq.gz
ln -sf SNP_gwas_mc_merge_nogc.tbl.uniq.gz BMI-EUR.gz
ln -sf All_ancestries_SNP_gwas_mc_merge_nogc.tbl.uniq.gz BMI-ALL.gz
rt=`pwd`
for dir in EUR ALL
do
    cd $rt/$dir
    gunzip -c $rt/bmi/BMI-$dir.gz | awk '(NR>1){FS=OFS="\t";print $1, $2, $3, $5/$6}' | sort -t$'\t' -k1,1 > bmi.txt
    for pop in MET NTR YFS
    do
        if [ ! -d $dir/$pop ]; then
           mkdir -p $dir/$pop
           cd $pop
           ln -sf ../bmi.txt twas2.txt
        fi
    done
done
cd $rt

# running the two sets of summary statistics using eight cores on each of the nodes b01-b08
parallel -j8 -S b01,b02,b03,b04,b05,b06,b07,b08 twas2.sh {1} {2} {3} {4} {5} ::: $TWAS ::: $TWAS2 ::: $rt/ALL $rt/EUR ::: MET NTR YFS ::: $(seq 1000) 

# The following adds SNP positions
# gunzip -c BMI-EUR.gz | awk '(NR>1)' | sort -t$'\t' -k1,1 > t.txt
# awk '(NR>1)' /gen_omics/data/3-2012/legend.txt | sort -t$'\t' -k1,1 | awk '($1!=".")'> snp.txt
# join -j 1 -t$'\t' snp.txt t.txt | sort -t$'\t' -n -k2,2n -k3,3n > BMI-EUR.txt
