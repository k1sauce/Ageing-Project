source("~/R/ageing/functions/na_predict.r")
load("~/R/ageing/datasets/nafld/females/mvalues_5k_liver_diseased_females.r")
load("~/R/ageing/datasets/nafld/females/mvalues_5k_liver_controls_females.r")
load("~/R/ageing/datasets/nafld/females/vec_age_female_diseased.r")
load("~/R/ageing/datasets/nafld/females/vec_age_female_controls.r")
load("~/R/ageing/datasets/nafld/females/POLYNOMIALS5k.r")
load("~/R/ageing/datasets/nafld/females/RES5k.r")


na_fill_mvalues_female_liver_diseased <- na_predict(mvalues = mvalues_5k_liver_diseased_females, age_vec = vec_age_female_diseased, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
na_fill_mvalues_female_liver_controls <- na_predict(mvalues = mvalues_5k_liver_controls_females, age_vec = vec_age_female_controls, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
setwd("~/R/ageing/datasets/nafld/females")
save(na_fill_mvalues_female_liver_diseased, file = "na_fill_mvalues_female_liver_diseased.r")
save(na_fill_mvalues_female_liver_controls, file = "na_fill_mvalues_female_liver_controls.r")
