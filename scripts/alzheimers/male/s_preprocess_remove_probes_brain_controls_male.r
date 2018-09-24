#remove the confounding probes before regresion analysis
load("~/R/ageing/datasets/alzheimers/males/brain_controls_mvalues_male.r")
load("~/R/ageing/datasets/alzheimers/probestoremove.r")

#select probe names that begin with only "c"
tmp <- brain_controls_mvalues_male[grep("^c",rownames(brain_controls_mvalues_male)),]
#remove unwanted probes
mts <- as.vector(match(probestoremove,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]

brain_controls_mvalues_male_preprocessed <- tmp
setwd("~/R/ageing/datasets/alzheimers/males")
save(brain_controls_mvalues_male_preprocessed, file= "brain_controls_mvalues_male_probes_removed.r")
