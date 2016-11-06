#!/bin/sh
#6-11-2016 MRC-Epid JHZ

echo Step 1 - specify locations of TWAS and TWAS-pipeline
TWAS=/genetics/bin/TWAS
TWAS2=/genetics/bin/TWAS-pipeline
echo Step 2 - reformat input
awk ' (NR>1) {
  FS=OFS="\t"
  $3=toupper($3)
  $4=toupper($4)
  print $1, $2, $3, $4, $5/$6
}' $1 | sort -k1,1 > $(basename $1).input
echo Step 3 - make twas2.txt with cleaned Z-scores
dir=`pwd`/$(basename $1).tmp
if [ ! -d $dir ]; then
   mkdir -p $dir
fi
join -1 2 -2 1 $TWAS/GTEX_WEIGHTS.bim $(basename $1).input | awk -f $TWAS/CLEAN_ZSCORES.awk | awk '{$2="";print}' > $dir/twas2.txt
echo Step 4 - perform analysis
parallel -j15 $TWAS2/gtex.subs {1} {2} {3} {4} ::: $TWAS ::: $TWAS2 ::: $dir ::: $(seq 932)
echo Step 5 - collect results
echo "ENSG_ID tissue Z_Score p r2pred" > $(basename $1).tmp.imp
find $(basename $1).tmp -name "*.imp" | xargs -e -n1 -P8 grep -H gene | awk '!/nan/' | awk -vdir=$(basename $1).tmp/ '{sub(dir,"",$1);sub(/.imp:gene_exp/,"",$1);print $1, $5, $6}' >> $(basename $1).tmp.imp
echo Step 6 - tidy up
awk '
function abs(x)
{
  if (x<0) x=-x
  return x
}
function cPhi(x)
{
  R[0]=1.25331413731550025
  R[1]=.421369229288054473
  R[2]=.236652382913560671
  R[3]=.162377660896867462
  R[4]=.123131963257932296
  R[5]=.0990285964717319214
  R[6]=.0827662865013691773
  R[7]=.0710695805388521071
  R[8]=.0622586659950261958
  j=int(.5*(abs(x)+1));
  pwr=1;a=R[j];z=2*j;b=a*z-1;h=abs(x)-z;s=a+h*b;t=a;q=h*h;
  for(i=2;s!=t;i+=2) {a=(a+z*b)/i; b=(b+z*a)/(i+1); pwr*=q; s=(t=s)+pwr*(a+h*b);}
  s=s*exp(-.5*x*x-.91893853320467274178);
  return 2*s;
}
{
  if(NR==1) print $0
  else {
    print $0 " "  cPhi($2)
#   printf $0 " ";system(sprintf("pnorm %lf",$2))
  }
}' $(basename $1).tmp.imp | awk '{
   if(NR>1) {t=$3;$3=$4;$4=t;sub("-"," ",$1)}
   print
}' > $(basename $1).gtex
rm -rf $dir $(basename $1).input $(basename $1).tmp.imp

# cd /genetics/bin/TWAS/ftp
# grep map *list|sed 's\GTEX_WEIGHTS/\\g'|sed 's/.wgt.map//g' > ../GTEX_WEIGHTS.lst
# sort -k2,2 GTEX_WEIGHTS.bim > ../GTEX_WEIGHTS.bim
