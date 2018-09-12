#s_beta_values_to_m_values_male_blood_controls

setwd("~/R/ageing/datasets/rheumatoid_arthritis/females/GSE42861_ra")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/GSE42861_ra/female_controls_betas.r")
source("~/R/ageing/functions/m_values.r")

tmp <- m.values(female_controls_betas)

tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6

setwd("~/R/ageing/datasets/rheumatoid_arthritis/females/GSE42861_ra")
blood_controls_mvalues_female <- tmp
save(blood_controls_mvalues_female, file= "blood_controls_mvalues_female.r")
