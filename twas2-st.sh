#!/bin/bash
# 27-6-2016 MRC-Epid JHZ

S=$1
dir=$2
TWAS=/genetics/bin/TWAS
TWAS2=/genetics/bin/TWAS-pipeline

parallel -j8 -S $S twas2.sh {1} {2} {3} {4} {5} ::: $TWAS ::: $TWAS2 ::: $dir ::: MET NTR YFS ::: $(seq 1000) 
