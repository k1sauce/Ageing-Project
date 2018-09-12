source("~/R/ageing/functions/na_predict.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/mvalues_5k_blood_diseased_males.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/mvalues_5k_blood_controls_males.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/vec_age_male_blood_diseased.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/vec_age_male_blood_controls.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/POLYNOMIALS5k.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/males/RES5k.r")


na_fill_mvalues_male_blood_diseased <- na_predict(mvalues = mvalues_5k_blood_diseased_males, age_vec = vec_age_male_blood_diseased, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
na_fill_mvalues_male_blood_controls <- na_predict(mvalues = mvalues_5k_blood_controls_males, age_vec = vec_age_male_blood_controls, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
save(na_fill_mvalues_male_blood_diseased, file = "na_fill_mvalues_male_blood_diseased.r")
save(na_fill_mvalues_male_blood_controls, file = "na_fill_mvalues_male_blood_controls.r")
