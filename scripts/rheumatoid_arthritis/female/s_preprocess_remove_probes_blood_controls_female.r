#remove the confounding probes before regresion analysis
load("~/R/ageing/datasets/rheumatoid_arthritis/females/mvalues_blood_controls_female.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/probestoremove.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/correlatedprobesbloodremove.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/female_removechrYprobes.r")


#select probe names that begin with only "c"
tmp <- mvalues_blood_controls_female[grep("^c",rownames(mvalues_blood_controls_female)),]
#remove unwanted probes
mts <- as.vector(match(probestoremove,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]

mts <- as.vector(match(correlatedprobesbloodremove,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]

mts <- as.vector(match(female_removechrYprobes,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]


blood_controls_mvalues_female_preprocessed <- tmp
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(blood_controls_mvalues_female_preprocessed, file= "blood_controls_mvalues_female_probes_removed.r")
