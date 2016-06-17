Transcription-Wide Association Analysis Pipeline (TWAS-pipeline)

The purpose of this work is to automate Transciption-Wide Association Analysis (TWAS, Gusev, et al. 2016) as implemented in the software TWAS, which contains two command files:

.   TWAS_get_weights.sh, which obtains weights (.ld, .cor, .map) from PLINK map/ped pair given a particular locus. It actually wraps up a program in R.
                        
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

As described in TWAS documentation, if one takes weights from the three population in Gusev et al. (2016) as well as summary statistics from Locke et al. (2015) then one only needs twas2.sh and twas2-collect.sh for TWAS and result collection. The scripts for this particular example all have prefix twas2-.


REFERENCES

Locke AM, et al.(2015). Genetic studies of body mass index yield new insights for obesity biology. Nature, 518, 197-206

Gusev A., et al. (2016). Integrative approaches for large-scale transcriptome-wide association studies. Nature Genetics, 48, 245-252   

Pruim RJ, et al. (2010). LocusZoom: regional visualization of genome-wide association scan results. Bioinformatics, 26,2336-2337
