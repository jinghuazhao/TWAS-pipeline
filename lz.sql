----------------------------------------
-- 19-10-2012 MRC-Epid JHZ            --
-- sqlite3 locuszoom_hg18.db < lz.sql --
----------------------------------------
.tables
.indices
.separator "\t"
.header on
.output recomb_rate.txt
select * from recomb_rate;
.output refFlat.txt
select * from refFlat;
.output refsnp_trans.txt
select * from refsnp_trans;
.output snp_pos.txt
select * from snp_pos;
.output snp_set.txt
select * from snp_set;
.output var_annot.txt
select * from var_annot;
