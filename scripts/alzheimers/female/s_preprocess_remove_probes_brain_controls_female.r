#remove the confounding probes before regresion analysis
load("~/R/ageing/datasets/alzheimers/females/brain_controls_mvalues_female.r")
load("~/R/ageing/datasets/alzheimers/probestoremove.r")
load("~/R/ageing/datasets/alzheimers/female_removechrYprobes.r")

#select probe names that begin with only "c"
tmp <- brain_controls_mvalues_female[grep("^c",rownames(brain_controls_mvalues_female)),]
#remove unwanted probes
mts <- as.vector(match(probestoremove,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]

mts <- as.vector(match(female_removechrYprobes,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]

brain_controls_mvalues_female_preprocessed <- tmp
setwd("~/R/ageing/datasets/alzheimers/females")
save(brain_controls_mvalues_female_preprocessed, file= "brain_controls_mvalues_female_probes_removed.r")
