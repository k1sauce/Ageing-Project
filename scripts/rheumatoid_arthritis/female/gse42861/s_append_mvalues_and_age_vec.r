#append m_value and age_vec table

load("~/R/ageing/datasets/rheumatoid_arthritis/females/blood_controls_mvalues_female.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/beta_values_fc_b.r")

merge20 <- m.values(merge20)
merge20[merge20 > 6] <-6
merge20[merge20 < -6] <- -6

mvalues_blood_controls_female <- cbind(merge20, blood_controls_mvalues_female)
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(mvalues_blood_controls_female, file="mvalues_blood_controls_female.r")


rm(list = ls())

load("~/R/ageing/datasets/rheumatoid_arthritis/females/GSE42861_ra/female_diseased_betas.r")
source("~/R/ageing/functions/m_values.r")
tmp <- m.values(female_diseased_betas)
tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6
mvalues_blood_diseased_female <- tmp
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(mvalues_blood_diseased_female, file = "mvalues_blood_diseased_female.r")
