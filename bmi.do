// 8-6-2016 MRC-Epid JHZ

cd bmi
insheet pid omicsid fid mid sex p using /gen_omics/data/EPIC-Norfolk/plink/EPICNorfolk.fam, delim(" ")
sort omicsid
merge omicsid using /home/jhz22/mrc/projects/omics/data06062016_epicomics_dist.dta
outsheet omicsid omicsid fid mid sex p using EPICNorfolk.fam, delim(" ") noname noquote replace
drop if bmi==.
outsheet omicsid omicsid using bmi.id, noname noquote replace
