#remove the confounding probes before regresion analysis
load("~/R/ageing/datasets/nafld/males/liver_controls_mvalues_male.r")
load("~/R/ageing/datasets/nafld/probestoremove.r")

#select probe names that begin with only "c"
tmp <- liver_controls_mvalues_male[grep("^c",rownames(liver_controls_mvalues_male)),]
#remove unwanted probes
mts <- as.vector(match(probestoremove,rownames(tmp)))
mts <- mts[!is.na(mts)]
tmp <- tmp[-c(mts),]

liver_controls_mvalues_male_preprocessed <- tmp
setwd("~/R/ageing/datasets/nafld/males")
save(liver_controls_mvalues_male_preprocessed, file= "liver_controls_mvalues_male_probes_removed.r")
