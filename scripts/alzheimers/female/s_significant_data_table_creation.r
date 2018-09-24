#create tables for significant probes
# RES5k - 5000 most significant probes of RES table
# POLYNOMIALS5k - polynomial models of 5000 most significant probes
# mvalues_5k_brain_controls_males - the mvalues of male brain controls for the 5000 probes
# mvalues_5k_brain_diseased_males - the mvalues of the male brain diseased for the 5000 probes

load("~/R/ageing/datasets/alzheimers/females/POLYNOMIALS.r")
load("~/R/ageing/datasets/alzheimers/females/RES.r")

#take 5000 probes whose model has lowest RSS, and take the models
tmp <- RES[order(RES$RSS),] 
RES5k <- tmp[1:5000,]
POLYNOMIALS5k <- POLYNOMIALS[rownames(RES5k)]

setwd("~/R/ageing/datasets/alzheimers/females")
save(RES5k, file = "RES5k.r")
save(POLYNOMIALS5k, file = "POLYNOMIALS5k.r")

#create data table for 5000 selected probes m-values and control samples
load("~/R/ageing/datasets/alzheimers/females/RES5k.r")
load("~/R/ageing/datasets/alzheimers/females/brain_controls_mvalues_female_probes_removed.r")
mvalues_5k_brain_controls_females <- brain_controls_mvalues_female_preprocessed[rownames(RES5k),]

setwd("~/R/ageing/datasets/alzheimers/females")
save(mvalues_5k_brain_controls_females, file = "mvalues_5k_brain_controls_females.r")

#create data table for 5000 selected probes m-values and diseased samples
load("~/R/ageing/datasets/alzheimers/females/RES5k.r")
load("~/R/ageing/datasets/alzheimers/females/brain_diseased_mvalues_female.r")
mvalues_5k_brain_diseased_females <- brain_diseased_mvalues_female[rownames(RES5k),]

setwd("~/R/ageing/datasets/alzheimers/females")
save(mvalues_5k_brain_diseased_females, file = "mvalues_5k_brain_diseased_females.r")
