#add GSE42861 controls into methylation data


load("~/R/ageing/datasets/rheumatoid_arthritis/males/yx_train_gw.r")
library(GEOquery)
ra <- getGEO("GSE42861", filename = "~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_series_matrix.txt.gz")
save(ra, file = "GSE42861_ra.r")

disease_state <- cbind(ra[[2]],ra[[11]],ra[[13]],ra[[14]])
save(disease_state, file = "disease_state.r")
male_diseased <- subset(disease_state, disease_state[,2] =="2" & disease_state[,4] == "2")
male_controls <- subset(disease_state, disease_state[,2] =="1" & disease_state[,4] == "2")
female_diseased <- subset(disease_state, disease_state[,2] =="2" & disease_state[,4] == "1")
female_control <- subset(disease_state, disease_state[,2] =="2"& disease_state[,4] == "1")

era <- exprs(ra)
male_diseased_betas <- era[,male_diseased[,1]]
male_controls_betas <- era[,male_controls[,1]]
female_diseased_betas <- era[,female_diseased[,1]]
female_controls_betas <- era[,female_control[,1]]

save(male_controls_betas, file = "male_controls_betas.r")
save(male_diseased_betas, file = "male_diseased_betas.r")
save(female_controls_betas, file = "female_controls_betas.r")
save(female_diseased_betas, file = "female_diseased_betas.r")
