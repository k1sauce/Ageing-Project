#s_beta_values_to_m_values_male_blood_controls

setwd("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/male_controls_betas.r")

m.values = function(x){
  log2(x/(1-x))
}

tmp <- male_controls_betas
tmp <- m.values(male_controls_betas)

tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6

setwd("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra")
blood_controls_mvalues_male <- tmp
save(blood_controls_mvalues_male, file= "blood_controls_mvalues_male.r")
