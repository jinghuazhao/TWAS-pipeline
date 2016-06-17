#!/bin/sh
# 17-6-2016 MRC-Epid JHZ

# seq 22 | parallel -j12 /genetics/data/CGI/TWAS-pipeline/bmi.sh {}
# seq 22 | parallel -j12 /genetics/data/CGI/TWAS-pipeline/bmi-twas2.sh {}
# seq 25000 | parallel -j10 -S b01,b02,b03,b04,b05,b06,b07,b08 /genetics/data/CGI/TWAS-pipeline/bmi-twas2.sh
# seq 5000 | parallel -j8 -S b01,b02,b03,b04,b05,b06,b07,b08 /genetics/data/CGI/TWAS-pipeline/twas2.sh

# Example:
for pop in EUR ALL
do
    for d in MET NTR YFS
    do
        if [ ! -d /genetics/data/CGI/TWAS-pipeline/$pop/$d ]
        then
        mkdir -p /genetics/data/CGI/TWAS-pipeline/$pop/$d
        fi
    done
done
# cd /genetics/data/CGI/TWAS-pipeline/ALL
# gunzip -c $rt/bmi/BMI-ALL.gz | awk '(NR>1){FS=OFS="\t";print $1, $2, $3, $5/$6}' | sort -t$'\t' -k1,1 > bmi.txt
# cd /genetics/data/CGI/TWAS-pipeline/EUR
# gunzip -c $rt/bmi/BMI-EUR.gz | awk '(NR>1){FS=OFS="\t";print $1, $2, $3, $5/$6}' | sort -t$'\t' -k1,1 > bmi.txt
# However, if we have
# cd /genetics/data/CGI/TWAS-pipeline/BMI
# gunzip -c $rt/bmi/BMI-EUR.gz | awk '(NR>1){FS=OFS="\t";print $1, $2, $3, $5/$6}' | sort -t$'\t' -k1,1 > bmi.txt
# then BMI replaces ALL EUR below

parallel -j8 -S b01,b02,b03,b04,b05,b06,b07,b08 /genetics/data/CGI/TWAS-pipeline/twas2.sh {1} {2} {3} ::: bmi.txt ::: ALL EUR ::: MET NTR YFS ::: $(seq 1000) 
