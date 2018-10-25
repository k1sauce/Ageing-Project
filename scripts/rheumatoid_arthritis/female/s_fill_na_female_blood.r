source("~/R/ageing/functions/na_predict.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/mvalues_5k_blood_diseased_females.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/mvalues_5k_blood_controls_females.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/vec_age_female_diseased.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/vec_age_female_controls.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/POLYNOMIALS5k.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/RES5k.r")


na_fill_mvalues_female_blood_diseased <- na_predict(mvalues = mvalues_5k_blood_diseased_females, age_vec = vec_age_female_diseased, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
na_fill_mvalues_female_blood_controls <- na_predict(mvalues = mvalues_5k_blood_controls_females, age_vec = vec_age_female_controls, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(na_fill_mvalues_female_blood_diseased, file = "na_fill_mvalues_female_blood_diseased.r")
save(na_fill_mvalues_female_blood_controls, file = "na_fill_mvalues_female_blood_controls.r")
