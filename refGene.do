program refGene
tempfile f1
tempname out

preserve
keep name2
duplicates drop name2, force
rename name2 genename
local ng=_N
gen n=_n
save `f1', replace
restore
gen n=_n
merge 1:1 n using `f1', nogen

cap postclose `out'
postfile `out' str2 chr id double(start) double(end) str12 name str22 name2 using `f1', replace

quietly forval k=1/`ng' {
  local gene=genename[`k']
  preserve
  keep if name2=="`gene'"
  sort txStart txEnd
  count
  local n=_N
  if `n'==0 continue
     local j=1
     forval i=1/`n' {
        local t=`i'+1
        if `i'==1 {
		local ChR=chr[1]
                local p1=txStart[1]
                local p2=txEnd[1]
		local nam1=name[1]
        }

        if txStart[`t']<=`p2' {
                if `p2'<txEnd[`t'] {
                        local p2=txEnd[`t']
                }
                continue
        }
        post `out' ("`ChR'") (`j') (`p1') (`p2') ("`nam1'") ("`gene'")
        if `i'<`n' {
		local ChR=chr[`t']
                local p1=txStart[`t']
                local p2=txEnd[`t']
		local nam1=name[`t']
                local j=`j'+1
        }

     }

  restore
}
postclose `out'
use `f1', clear
format %12.0g start end
end

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
refGene
duplicates tag name2, gen(tag)
local dir="/gen_omics/data/3-2012"
outsheet name2 using "`dir'/genes/lists.", noname noquote replace
drop if tag!=0
drop tag
forval i=1/22 {
  outsheet name2 using "`dir'/genes-`i'.txt" if chr=="`i'", noname noquote replace
}
save refGene, replace
