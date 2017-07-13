#!/bin/bash
#13-7-2017 MRC-Epid JHZ

if [ $# -lt 1 ] || [ "$1" == "-h" ]; then
    echo "Usage: gtex-fusion.sh <input>"
    echo "where <input> is in tab-delimited format:"
    echo "SNP A1 A2 Z N"
    echo "The output is contained in <$1.GE>"
    exit
fi
dir=$(pwd)/$(basename $1).GE
if [ ! -d $dir ]; then
   mkdir -p $dir
fi
FUSION=/genetics/bin/FUSION/tests
ln -sf $FUSION/glist-hg19 $dir/glist-hg19
TWAS=/genetics/bin/TWAS-pipeline
qsub -cwd -sync y -v FUSION=$TWAS -v dir=$dir -v sumstats=$(pwd)/$1 -v GTEx=/genetics/bin/FUSION/GTEx -v TWAS=$TWAS $TWAS/ge-fusion.qsub
