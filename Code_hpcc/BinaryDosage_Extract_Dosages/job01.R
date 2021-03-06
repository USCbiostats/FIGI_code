#========================================================#
# obtain allele dosage from FIGI BDose files
# using index position
#========================================================#
library(BinaryDosage)
args <- commandArgs(trailingOnly=T)
chr <- args[1]
vcfids <- args[2]
snplist <- args[3]

setwd("/auto/pmd-02/figi/HRC_BDose")

snpsToRead <- readRDS(paste0("/staging/dvc/andreeki/Extract_BD/", snplist, ".rds"))
samplesToRead <- readRDS(paste0("/staging/dvc/andreeki/Extract_BD/", vcfids, ".rds"))
bdose <- readRDS(paste0("FIGI_chr", chr, ".rds"))

snpsbd <- GetSNPValues(bdose, snpsToRead, samplesToRead, geneProb = F)

saveRDS(snpsbd, file = paste0("/staging/dvc/andreeki/Extract_BD/", snplist, "_out.rds"))
