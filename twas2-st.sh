#!/bin/sh
# 27-6-2016 MRC-Epid JHZ

S=$1
zfile=$2
dir=$3

parallel -j8 -S $S /genetics/data/CGI/TWAS-pipeline/twas2.sh {1} {2} {3} {4} ::: $zfile ::: $dir ::: MET NTR YFS ::: $(seq 1000) 
