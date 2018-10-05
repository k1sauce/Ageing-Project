#remove the confounding probes before regresion analysis
load("~/R/ageing/datasets/nafld/females/liver_controls_mvalues_female.r")
load("~/R/ageing/datasets/nafld/probestoremove.r")
load("~/R/ageing/datasets/nafld/female_removechrYprobes.r")


#select probe names that begin with only "c"
tmp <- liver_controls_mvalues_female[grep("^c",rownames(liver_controls_mvalues_female)),]
#remove unwanted probes
mts <- as.vector(match(probestoremove,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]

mts <- as.vector(match(female_removechrYprobes,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]

liver_controls_mvalues_female_preprocessed <- tmp
setwd("~/R/ageing/datasets/nafld/females")
save(liver_controls_mvalues_female_preprocessed, file= "liver_controls_mvalues_female_probes_removed.r")
