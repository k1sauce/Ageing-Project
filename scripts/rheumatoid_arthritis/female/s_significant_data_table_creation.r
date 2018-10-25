#create tables for significant probes
# RES5k - 5000 most significant probes of RES table
# POLYNOMIALS5k - polynomial models of 5000 most significant probes
# mvalues_5k_blood_controls_males - the mvalues of male blood controls for the 5000 probes
# mvalues_5k_blood_diseased_males - the mvalues of the male blood diseased for the 5000 probes


load("~/R/ageing/datasets/rheumatoid_arthritis/females/POLYNOMIALS.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/RES.r")

#take 5000 probes whose model has lowest RSS, and take the models
tmp <- RES[order(RES$RSS),] 
RES5k <- tmp[1:5000,]
POLYNOMIALS5k <- POLYNOMIALS[rownames(RES5k)]

setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(RES5k, file = "RES5k.r")
save(POLYNOMIALS5k, file = "POLYNOMIALS5k.r")

#create data table for 5000 selected probes m-values and control samples
load("~/R/ageing/datasets/rheumatoid_arthritis/females/RES5k.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/blood_controls_mvalues_female_probes_removed2.r")
mvalues_5k_blood_controls_females <- blood_controls_mvalues_female_preprocessed[rownames(RES5k),]

setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(mvalues_5k_blood_controls_females, file = "mvalues_5k_blood_controls_females.r")

#create data table for 5000 selected probes m-values and diseased samples
load("~/R/ageing/datasets/rheumatoid_arthritis/females/RES5k.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/mvalues_blood_diseased_female.r")
mvalues_5k_blood_diseased_females <- mvalues_blood_diseased_female[rownames(RES5k),]

setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(mvalues_5k_blood_diseased_females, file = "mvalues_5k_blood_diseased_females.r")
