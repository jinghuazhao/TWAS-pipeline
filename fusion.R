#!/usr/local/bin/Rscript --vanilla

args <- commandArgs(trailingOnly=TRUE)
prefix <- args[1]
prefix <- ifelse(substring(prefix,nchar(prefix)) != "/", paste0(prefix, "/"), prefix)
tissue <- args[2]
if(is.na(prefix)) {
  cat("\n")
  cat("Usage: fusion.R <directory.name> <tissue name>\n")
  cat("where directory.name contains results from g(t)e(x)-fusion.sh\n\n")
  quit("yes")
}

# User messages
options(echo=FALSE)

# Manifest information
glist <- read.table(paste0("/genetics/bin/FUSION/tests/","glist-hg19"),as.is=TRUE, skip=7)
names(glist) <- c("chr","start","end","ID")

paste0(prefix, tissue, "_", 6, ".dat.MHC")
temp <- read.table(paste0(prefix, tissue, "_", 6, ".dat.MHC"), as.is=TRUE, header=TRUE)
nMHC <- nrow(temp)
for(i in 1:22) temp <- rbind(temp, read.table(paste0(prefix, tissue, "_", i, ".dat"), as.is=TRUE, header=TRUE))
library(reshape)
# Annotation
temp <- within(temp, {MHC <- 0})
temp[1:nMHC, "MHC"] <- 1
annotated.data <- merge(temp, glist, by="ID")
N <- nrow(annotated.data)

# P-values, Bonferroni-corrected significant list and joint/conditional analysis
sorted.data <- annotated.data[with(annotated.data,order(TWAS.P)),]
write.csv(sorted.data, file=paste0(prefix, "annotatedSorted.csv"), quote=FALSE, row.names=FALSE)
cat(paste0("All annotation: ", prefix, "annotatedSorted.csv\n"))

sig.data <- subset(sorted.data, TWAS.P <= 0.05/N)
write.csv(sig.data, file=paste0(prefix, "annotatedSortedSignificant.csv"), quote=FALSE, row.names=FALSE)
cat(paste0("Bonferroni-corrected significant list: ", prefix, "annotatedSortedSignificant.csv\n"))

included <- dropped <- NULL
for (i in 1:22)
{
  included <- rbind(included, read.table(paste0(prefix, tissue, "_", i, ".top.analysis.joint_included.dat"), as.is=TRUE, header=TRUE))
  dropped <- rbind(dropped, read.table(paste0(prefix, tissue, "_", i, ".top.analysis.joint_dropped.dat"), as.is=TRUE, header=TRUE))
}
included <- rename(included, c("ID"="Name"))
j <- merge(included, anno, by="Name")
sorted.data <- j[with(j,order(JOINT.P)),]
write.csv(sorted.data[setdiff(names(sorted.data),"FILE")], file=paste0(prefix, "annotatedJoint_included.csv"), quote=FALSE, row.names=FALSE)
cat(paste0("Joint annotation: ", prefix, "annotatedJoint_included.csv\n"))
dropped <- rename(dropped, c("ID"="Name"))
c <- merge(dropped, anno, by="Name")  
sorted.data <- c[with(c,order(COND.P)),]
write.csv(sorted.data[setdiff(names(sorted.data),"FILE")], file=paste0(prefix, "annotatedJoint_dropped.csv"), quote=FALSE, row.names=FALSE)
cat(paste0("Conditional annotation: ", prefix, "annotatedJoint_dropped.csv\n"))

annotated.data <- within(annotated.data, {TWAS.P.Bonferroni <- 0.05/N})
included <- included[setdiff(names(included),c("FILE","TWAS.Z","TWAS.P"))]
aj <- merge(annotated.data, included, by="Name", all=TRUE)
dropped <- dropped[setdiff(names(dropped),c("FILE","TWAS.Z","TWAS.P"))]
ajc <- merge(aj, dropped, by="Name", all=TRUE)
ajc <- ajc[with(ajc,order(CHR,MAPINFO)),]
write.csv(ajc,file=paste0(prefix,"ajc.csv"),quote=FALSE, row.names=FALSE)
cat(paste0("Association + Joint/conditional annotation: ", prefix, "ajc.csv\n"))
cat("\nThe annotation is done.\n\n")
rm(prefix, temp, included, dropped, anno, annotated.data, sorted.data, sig.data, j, c, aj, ajc)

cat("Further information about FUSION and annotation is available from\n
http://gusevlab.org/projects/fusion/
https://support.illumina.com/array/array_kits/infinium_humanmethylation450_beadchip_kit/downloads.html\n\n")
