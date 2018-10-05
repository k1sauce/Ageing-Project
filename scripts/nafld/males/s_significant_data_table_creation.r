#create tables for significant probes
# RES5k - 5000 most significant probes of RES table
# POLYNOMIALS5k - polynomial models of 5000 most significant probes
# mvalues_5k_liver_controls_males - the mvalues of male liver controls for the 5000 probes
# mvalues_5k_liver_diseased_males - the mvalues of the male liver diseased for the 5000 probes


load("~/R/ageing/datasets/nafld/males/POLYNOMIALS.r")
load("~/R/ageing/datasets/nafld/males/RES.r")

#take 5000 probes whose model has lowest RSS, and take the models
tmp <- RES[order(RES$RSS),] 
RES5k <- tmp[1:5000,]
POLYNOMIALS5k <- POLYNOMIALS[rownames(RES5k)]

setwd("~/R/ageing/datasets/nafld/males")
save(RES5k, file = "RES5k.r")
save(POLYNOMIALS5k, file = "POLYNOMIALS5k.r")

#create data table for 5000 selected probes m-values and control samples
load("~/R/ageing/datasets/nafld/males/RES5k.r")
load("~/R/ageing/datasets/nafld/males/liver_controls_mvalues_male_probes_removed.r")
mvalues_5k_liver_controls_males <- liver_controls_mvalues_male_preprocessed[rownames(RES5k),]

setwd("~/R/ageing/datasets/nafld/males")
save(mvalues_5k_liver_controls_males, file = "mvalues_5k_liver_controls_males.r")

#create data table for 5000 selected probes m-values and diseased samples
load("~/R/ageing/datasets/nafld/males/RES5k.r")
load("~/R/ageing/datasets/nafld/males/liver_diseased_mvalues_male.r")
mvalues_5k_liver_diseased_males <- liver_diseased_mvalues_male[rownames(RES5k),]

setwd("~/R/ageing/datasets/nafld/males")
save(mvalues_5k_liver_diseased_males, file = "mvalues_5k_liver_diseased_males.r")
