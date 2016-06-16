// 29-5-2016 MRC-Epid JHZ

cd bmd
insheet pid id fid mid sex p using /gen_omics/data/EPIC-Norfolk/plink/EPICNorfolk.fam, delim(" ")
sort id
gzmerge id using /genetics/data/gwas/18-3-16/data.dta.gz
replace p=zRes_BMD if zRes_BMD!=.
outsheet id id fid mid sex p using EPICNorfolk.fam, delim(" ") noname noquote replace
drop if zRes_BMD==.
outsheet id id using bmd.id, noname noquote replace
