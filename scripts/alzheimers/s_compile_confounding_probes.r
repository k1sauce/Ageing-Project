# remember to remove controls and snp
# to do this select probe names that begin with only "c"
# remove nonspecific probes before regression analysis, these could lead to confounded results. 
# do this by creating a vector of snp linked probes and non-specific probes based on Weksberg research
# files from http://www.sickkids.ca/Research/Weksberg-Lab/Publications/index.html
# the files contain SNPs in single base extension sites, in the probe length, and cross reactive cg and ch probes
# see "Discovery of cross-reactive probes and polymorphic CpGs in the Illumina Infinium HumanMethylation450 microarray" Y.A. Chen et al., Epigenetics, 8 (2013), pp. 203-209



nonspecificcg <- read.csv(file="~/R/ageing/datasets/rheumatoid_arthritis/nonspecificcg.csv")
nonspecificch <- read.csv(file="~/R/ageing/datasets/rheumatoid_arthritis/nonspecificch.csv")

removenonspecificcgprobes <- as.character(nonspecificcg$TargetID)
removenonspecificchprobes <- as.character(nonspecificch$TargetID)

# Polymorphic cpg sites were found to be outdated with regards to refSNP allele frequency for weksberg lab annotation
#allele frequency reported in this study is that reported by 1000 genomes project
#we need to remove alleles with a MAF > 1%, which is the definition of polymorphisms
#snpsbe <- read.csv(file="snpatsbeprobes.csv")
#snpprobe <- read.csv(file="snpwithinprobes.csv")
# Hansen lab annotation is better for this purpose, we do not care about SNP with MAF < 0.01. 
# Creates a vector of SNP linked probes based on illumina's version 1.2 annotation and dbSNP build 147
# It would be even better to do this for an up to date dbSNP build but is not necessary
# https://bioconductor.org/packages/release/data/annotation/html/IlluminaHumanMethylation450kanno.ilmn12.hg19.html
source("https://bioconductor.org/biocLite.R")
biocLite("IlluminaHumanMethylation450kanno.ilmn12.hg19")
# to view data frame use command IlluminaHumanMethylation450kanno.ilmn12.hg19::SNPs.147CommonSingle
not_a_snp <- IlluminaHumanMethylation450kanno.ilmn12.hg19::SNPs.147CommonSingle[,"Probe_rs"]
snp147 <- IlluminaHumanMethylation450kanno.ilmn12.hg19::SNPs.147CommonSingle[!is.na(not_a_snp),]
MAFabove0.01 <- snp147[snp147$Probe_maf > 0.01,]
snpdb147probes <- rownames(MAFabove0.01)
save(snpdb147probes, file = "snpdb147probes.r")

# concatenate a vector of probes to remove before regression analysis

probestoremove <- unique(c(removenonspecificcgprobes,removenonspecificchprobes, snpdb147probes))
save(probestoremove, file = "probestoremove.r")

# create vector of chr Y specific probes to remove from female samples
locations <- IlluminaHumanMethylation450kanno.ilmn12.hg19::Locations
chrY <- subset(locations, locations$chr == "chrY")
female_removechrYprobes <- rownames(chrY)
save(female_removechrYprobes, file="female_removechrYprobes.r")
