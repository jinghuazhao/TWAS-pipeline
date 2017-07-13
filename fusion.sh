# 13-7-2017 MRC-Epid JHZ

TWAS=/genetics/bin/TWAS-pipeline
for i in $(cut -d ' ' -f1 $TWAS/GTEx.runlist|sed 's/GTEx\.//g'|uniq)
do
  echo $1 $i
  fusion.R $1 $i
done
for i in $(cut -d ' ' -f1 $TWAS/GE.runlist|uniq)
do
  echo $i
  fusion.R $1 $i
done
