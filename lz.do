// 19-7-2016 MRC-Epid JHZ

local dir="/gen_omics/data/3-2012"
use refGene
gen genelist=name2
gen LL=start
gen UL=end
local j : env chr
quietly forval j=`j'/`j' {
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
