#remove the confounding probes before regresion analysis
load("~/R/ageing/datasets/rheumatoid_arthritis/males/blood_controls_mvalues_male.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/probestoremove.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/correlatedprobesbloodremove.r")

#select probe names that begin with only "c"
tmp <- blood_controls_mvalues_male[grep("^c",rownames(blood_controls_mvalues_male)),]
#remove unwanted probes
mts <- as.vector(match(probestoremove,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]

mts <- as.vector(match(correlatedprobesbloodremove,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]

blood_controls_mvalues_male_preprocessed <- tmp
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
save(blood_controls_mvalues_male_preprocessed, file= "blood_controls_mvalues_male_probes_removed.r")
