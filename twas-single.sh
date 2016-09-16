#!/bin/bash
# 16-9-2016 MRC-Epid JHZ

if [ $# -lt 1 ] || [ "$1" == "-h" ]; then
    echo "Usage: twas-single.sh <input>"
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
awk ' (NR>1) {
  FS=OFS="\t"
  $3=toupper($3)
  $4=toupper($4)
  print $1, $2, $3, $4, $5/$6
}' $1 | sort -k1,1 > $(basename $1).input
echo Step 3 - make population-specific twas2.txt with cleaned Z-scores
dir=`pwd`/$(basename $1).tmp
for pop in MET NTR YFS
do
  if [ ! -d $dir/$pop ]; then
     mkdir -p $dir/$pop
  fi
  join -1 2 -2 1 $TWAS/$pop.bim $(basename $1).input | awk -f $TWAS/CLEAN_ZSCORES.awk | awk '{$2="";print}' > $dir/$pop/twas2.txt
done
echo Step 4 - perform analysis
parallel -j8 twas2.sh {1} {2} {3} {4} {5} ::: $TWAS ::: $TWAS2 ::: $dir ::: MET NTR YFS ::: $(seq 1000)
echo Step 5 - collect results
twas2-collect.sh $(basename $1).tmp
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
  if(NR==1) print $0 " p"
  else {
    print $0 " "  cPhi($3)
#   printf $0 " ";system(sprintf("pnorm %lf",$3))
  }
}' $(basename $1).tmp.imp | awk '{t=$5;$5=$4;$4=t;print}' > $(basename $1).imp
rm -rf $dir $(basename $1).input $(basename $1).tmp.imp
