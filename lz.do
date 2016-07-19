// 19-7-2016 MRC-Epid JHZ

local user="genome"
local host="genome-mysql.cse.ucsc.edu"
local query="select bin, name, chrom, strand, txStart, txEnd, name2 from refGene order by chrom, name2"
!mysql --user="`user'" --host="`host'" -A -D hg19 -e "`query'" > refGene.dat
insheet using refGene.dat, case clear
split chrom, p("r")
split chrom2, p("_")
ren chrom21 chr
drop if chr=="X"|chr=="Y"|chr=="Un"
drop chrom1 chrom2 chrom3 chrom22 chrom23
do refGene
refGene
gen genelist=name2
gen LL=start
gen UL=end
local dir="/gen_omics/data/3-2012"
outsheet name2 using "`dir'/genes/lists", noname noquote replace
quietly forval j=1/22 {
  preserve
  keep if chr=="`j'"
  local totalgene=_N
  replace genelist=name2
  replace LL=start
  replace UL=end
  format %12.0g LL UL
  noisily di "working on chr`j' -- " _N " genes"
  ! awk '{FS=OFS="\t";if($2==chr) print $1, $3}' chr=`j' "`dir'"/snp_pos.txt > "`dir'"/snp_pos-`j'.txt
  forval k=1/`totalgene' {
    local gene=genelist[`k']
    local L=LL[`k']
    local U=UL[`k']
    di "`gene':" `L' "--" `U'
    local out="`dir'/genes/`gene'"
    ! touch "`out'"
    ! awk '{FS=OFS="\t";if($2>=start&&$2<=end) print}' start=`L' end=`U' "`dir'"/snp_pos-`j'.txt >> "`out'"
  }
}

// The original Bash script has duplicates:
/*
rm -f genes.txt
touch genes.txt
for chr in `seq 22`
do
  awk '(NR>1) {print $1,$3}' refFlat.txt|awk '{sub("chr","",$2);if($2==chr) print $1}' chr=$chr | sort | uniq > genes-${chr}.txt
  cat genes-${chr}.txt >> genes.txt
  awk '{FS=OFS="\t";if(NR>1&&$2==chr) print $1, $3}' chr=$chr snp_pos.txt > snp_pos-${chr}.txt
done
*/
