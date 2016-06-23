Transcription-Wide Association Analysis Pipeline (TWAS-pipeline)

The GIANT consortiium study of BMI on Europeans led to the following tab-delimited summary statistics, as in  Locke, et al. (2015), 
http://www.broadinstitute.org/collaboration/giant/images/1/15/SNP_gwas_mc_merge_nogc.tbl.uniq.gz, 

#BEGIN_SRC

SNP	A1	A2	Freq1.Hapmap	b	se	p	N
rs1000000	G	A	0.6333	1e-04	0.0044	0.9819	231410
rs10000010	T	C	0.575	-0.0029	0.003	0.3374	322079
rs10000012	G	C	0.1917	-0.0095	0.0054	0.07853	233933
rs10000013	A	C	0.8333	-0.0095	0.0044	0.03084	233886
...
+#END_SRC

from which we generated the following z-score file /genetics/data/CGI/TWAS-pipeline/EUR/bmi.txt

rs10	C	A	-0.571429
rs1000000	G	A	0.0227273
rs10000010	T	C	-0.966667
rs10000012	G	C	-1.75926
rs10000013	A	C	-2.15909
...

We can then call twas2.sh as follows,

twas2.sh bmi.txt EUR MET 1

where MET specifies weights from METSIM population as in Gusev et al. (2016) and we start from block 1 of the gene list.

As this may be time-consuming, we resort to parallel computing,

parallel -j8 /genetics/data/CGI/TWAS-pipeline/twas2.sh {1} {2} {3} {4} ::: bmi.txt ::: EUR ::: MET NTR YFS ::: $(seq 1000) 

where we iterate through all sets of weight (MET, NTR and YFE) and all blocks of genes using 8 CPUs.

If we provide /genetics/data/CGI/TWAS-pipeline/ALL/bmi.txt based on all population results, http://www.broadinstitute.org/collaboration/giant/images/f/f0/All_ancestries_SNP_gwas_mc_merge_nogc.tbl.uniq.gz, then we simply replace EUR with EUR ALL in the call to parallel above.

The imputation resuls are available from

sh twas2-collect.sh EUR
sh twas2-collect.sh ALL

All these have been provided in the repository with prefix twas2-. In particular, imputation can also be done for a specific gene, e.g., BRCA1 and YFS:

sh twas2-1.sh menopause.txt BRCA1 YFS BRCA1

so the results are written into BRCA1/YFS/BRCA1.imp. Note that by doing so, intermediate files with extensions .join, .sort, .zscore are available for check


IN GENERAL

The weights have to be generated in general. The software TWAS contains two command files:

. TWAS_get_weights.sh, which obtains weights (.ld, .cor, .map) from PLINK map/ped pair given a particular locus. It actually wraps up a program in R.
                        
. TWAS.sh, which conducts imputatation as reported in the Gusev et al. (2016). 

Minor changes to the scripts may be required for your own data. The tasks involved are to  

. extract SNPs in a gene from 1000Gnomes imputed data into PLINK map/ped files

. obtain .ld, .cor and .map with TWAS_get_weights.sh for that gene

. select summary statistics (.zscore) for the gene

. conduct imputation with TWAS.sh into file .imp

. repeat above steps for all genes and collect restuls


The selection of SNPs should comply with 1000Genomes-imputated data, e.g., refFlat.txt and snp_pos.txt from locuszoom-1.3 (Pruim, et al. 2010, also see lz.sql), and list of SNP-genes pair from Axiom_UKB_WCSG.na34.annot.csv.zip. Their chromosome-specific counterparts as with SNPs under all genes can also be derived. I have used 1000Genomes information to obtain all autosomal genes as well as SNPs within each genes.

An example is provided on a recent study of body bone mineral density (TBBMD). The relevant filesa ll have prefix bmd- and some are listed as follows,

bmd.sh                  to generate chromosome-specific z-scores

bmd.do                  Stata program to flag non-missing individuals

bmd/TBBMD.gz            the GWAS summary statistics

bmd-twas.sh             script for TWAS by SNP

bmd-twas2.sh            region selection based on position rather than rsid

bmd-summary.sh          To put together all imputation results into bmd.imp

The automation would involve bmi-twas.sh and bmd-twas2.sh.


REFERENCES

Locke AM, et al.(2015). Genetic studies of body mass index yield new insights for obesity biology. Nature, 518, 197-206

Gusev A., et al. (2016). Integrative approaches for large-scale transcriptome-wide association studies. Nature Genetics, 48, 245-252   

Pruim RJ, et al. (2010). LocusZoom: regional visualization of genome-wide association scan results. Bioinformatics, 26,2336-2337
