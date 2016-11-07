#7-11-2016 MRC-Epid JHZ

TWAS=/genetics/bin/TWAS
rm -f $TWAS/GTEX_WEIGHTS.map
cd $TWAS/GTEX_WEIGHTS
touch $TWAS/GTEX_WEIGHTS.map
ls */*map | xargs -l awk -vOFS="\t" '(NR>1) {
  f=FILENAME
  sub(".wgt.map","",f)
  print $1,$2,$3,$4,$5,f
}' | sort -k1,1 >> $TWAS/GTEX_WEIGHTS.map
sort -k2,2 $TWAS/ftp/GTEX_WEIGHTS.bim | \
join -1 1 -2 2 $TWAS/GTEX_WEIGHTS.map - | \
awk -vOFS="\t" '{print $6,$1,$7,$2,$3,$4,$5}' | \
gzip -cf $TWAS/GTEX_WEIGHTS.bim.gz

rm $TWAS/GTEX_WEIGHTS.map
