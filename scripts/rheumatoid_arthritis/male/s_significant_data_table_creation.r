#create tables for significant probes
# RES5k - 5000 most significant probes of RES table
# POLYNOMIALS5k - polynomial models of 5000 most significant probes
# mvalues_5k_blood_controls_males - the mvalues of male blood controls for the 5000 probes
# mvalues_5k_blood_diseased_males - the mvalues of the male blood diseased for the 5000 probes


load("~/R/ageing/datasets/rheumatoid_arthritis/males/POLYNOMIALS.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/RES.r")

#take 5000 probes whose model has lowest RSS, and take the models
tmp <- RES[order(RES$RSS),] 
RES5k <- tmp[1:5000,]
POLYNOMIALS5k <- POLYNOMIALS[rownames(RES5k)]

setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
save(RES5k, file = "RES5k.r")
save(POLYNOMIALS5k, file = "POLYNOMIALS5k.r")

#create data table for 5000 selected probes m-values and control samples
load("~/R/ageing/datasets/rheumatoid_arthritis/males/RES5k.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/blood_controls_mvalues_male_probes_removed.r")
mvalues_5k_blood_controls_males <- blood_controls_mvalues_male_preprocessed[rownames(RES5k),]

setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
save(mvalues_5k_blood_controls_males, file = "mvalues_5k_blood_controls_males.r")

#create data table for 5000 selected probes m-values and diseased samples
load("~/R/ageing/datasets/rheumatoid_arthritis/males/RES5k.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/blood_diseased_mvalues_male.r")
mvalues_5k_blood_diseased_males <- blood_diseased_mvalues_male[rownames(RES5k),]

setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
save(mvalues_5k_blood_diseased_males, file = "mvalues_5k_blood_diseased_males.r")
