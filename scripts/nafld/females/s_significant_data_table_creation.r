#create tables for significant probes
# RES5k - 5000 most significant probes of RES table
# POLYNOMIALS5k - polynomial models of 5000 most significant probes
# mvalues_5k_liver_controls_females - the mvalues of female liver controls for the 5000 probes
# mvalues_5k_liver_diseased_females - the mvalues of the female liver diseased for the 5000 probes


load("~/R/ageing/datasets/nafld/females/POLYNOMIALS.r")
load("~/R/ageing/datasets/nafld/females/RES.r")

#take 5000 probes whose model has lowest RSS, and take the models
tmp <- RES[order(RES$RSS),] 
RES5k <- tmp[1:5000,]
POLYNOMIALS5k <- POLYNOMIALS[rownames(RES5k)]

setwd("~/R/ageing/datasets/nafld/females")
save(RES5k, file = "RES5k.r")
save(POLYNOMIALS5k, file = "POLYNOMIALS5k.r")

#create data table for 5000 selected probes m-values and control samples
load("~/R/ageing/datasets/nafld/females/RES5k.r")
load("~/R/ageing/datasets/nafld/females/liver_controls_mvalues_female_probes_removed.r")
mvalues_5k_liver_controls_females <- liver_controls_mvalues_female_preprocessed[rownames(RES5k),]

setwd("~/R/ageing/datasets/nafld/females")
save(mvalues_5k_liver_controls_females, file = "mvalues_5k_liver_controls_females.r")

#create data table for 5000 selected probes m-values and diseased samples
load("~/R/ageing/datasets/nafld/females/RES5k.r")
load("~/R/ageing/datasets/nafld/females/liver_diseased_mvalues_female.r")
mvalues_5k_liver_diseased_females <- liver_diseased_mvalues_female[rownames(RES5k),]

setwd("~/R/ageing/datasets/nafld/females")
save(mvalues_5k_liver_diseased_females, file = "mvalues_5k_liver_diseased_females.r")
