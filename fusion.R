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

NR <- function(f) {con <- file(f, "r", blocking=FALSE); l <- readLines(con); close(con); length(l)}

# User messages
options(echo=TRUE)

# Manifest information
glist <- read.table(paste0("/genetics/bin/FUSION/tests/","glist-hg19"),as.is=TRUE, skip=7)
names(glist) <- c("chr","start","end","ID")

temp <- NULL
f <- paste0(prefix, tissue, "_", 6, ".dat.MHC")
if(file.exists(f))
{
  temp <- read.table(f, as.is=TRUE, header=TRUE)
  nMHC <- nrow(temp)
}
for(i in 1:22) {
  f <- paste0(prefix, tissue, "_", i, ".dat")
  if(file.exists(f)&&NR(f) >1) temp <- rbind(temp, read.table(f, as.is=TRUE, header=TRUE))
}
library(reshape)
# Annotation
if(!is.null(temp))
{
  temp <- within(temp, {MHC <- 0})
  temp[1:nMHC, "MHC"] <- 1
  annotated.data <- merge(temp, glist, by="ID")
  N <- nrow(annotated.data)
}  

# P-values, Bonferroni-corrected significant list and joint/conditional analysis
sorted.data <- annotated.data[with(annotated.data,order(TWAS.P)),]
write.csv(sorted.data, file=paste0(prefix, tissue, "-sorted.csv"), quote=FALSE, row.names=FALSE)
cat(paste0("All annotation: ", prefix, tissue, "-sorted.csv\n"))

sig.data <- subset(sorted.data, TWAS.P <= 0.05/N)
write.csv(sig.data, file=paste0(prefix, tissue, "-sortedSignificant.csv"), quote=FALSE, row.names=FALSE)
cat(paste0("Bonferroni-corrected significant list: ", prefix, tissue, "-sxortedSignificant.csv\n"))

included <- dropped <- NULL
for (i in 1:22)
{
  f <- paste0(prefix, tissue, "_", i, ".top.analysis.joint_included.dat")
  if(file.exists(f)&&NR(f)>1) included <- rbind(included, read.table(f, as.is=TRUE, header=TRUE))
  f <- paste0(prefix, tissue, "_", i, ".top.analysis.joint_dropped.dat")
  if(file.exists(f)&&NR(f)>1) dropped <- rbind(dropped, read.table(f, as.is=TRUE, header=TRUE))
}
j <- merge(included, glist, by="ID")
sorted.data <- j[with(j,order(JOINT.P)),]
write.csv(sorted.data[setdiff(names(sorted.data),"FILE")], file=paste0(prefix, tissue, "-joint_included.csv"), quote=FALSE, row.names=FALSE)
cat(paste0("Joint annotation: ", prefix, tissue, "-joint_included.csv\n"))
c <- merge(dropped, glist, by="ID")  
sorted.data <- c[with(c,order(COND.P)),]
write.csv(sorted.data[setdiff(names(sorted.data),"FILE")], file=paste0(prefix, tissue, "-joint_dropped.csv"), quote=FALSE, row.names=FALSE)
cat(paste0("Conditional annotation: ", prefix, tissue, "-joint_dropped.csv\n"))

annotated.data <- within(annotated.data, {TWAS.P.Bonferroni <- 0.05/N})
included <- included[setdiff(names(included),c("FILE","TWAS.Z","TWAS.P"))]
aj <- merge(annotated.data, included, by="ID", all=TRUE)
dropped <- dropped[setdiff(names(dropped),c("FILE","TWAS.Z","TWAS.P"))]
ajc <- merge(aj, dropped, by="ID", all=TRUE)
ajc <- ajc[with(ajc,order(CHR,start)),]
write.csv(ajc,file=paste0(prefix,tissue,"-ajc.csv"),quote=FALSE, row.names=FALSE)
cat(paste0("Association + Joint/conditional annotation: ", prefix, tissue, "-ajc.csv\n"))
cat("\nThe annotation is done.\n\n")
# rm(prefix, temp, included, dropped, anno, annotated.data, sorted.data, sig.data, j, c, aj, ajc)

cat("Further information about FUSION and annotation is available from\n
http://gusevlab.org/projects/fusion/
https://support.illumina.com/array/array_kits/infinium_humanmethylation450_beadchip_kit/downloads.html\n\n")
