source("~/R/ageing/functions/na_predict.r")
load("~/R/ageing/datasets/alzheimers/females/mvalues_5k_brain_diseased_females.r")
load("~/R/ageing/datasets/alzheimers/females/mvalues_5k_brain_controls_females.r")
load("~/R/ageing/datasets/alzheimers/females/vec_age_female_diseased.r")
load("~/R/ageing/datasets/alzheimers/females/vec_age_female_controls.r")
load("~/R/ageing/datasets/alzheimers/females/POLYNOMIALS5k.r")
load("~/R/ageing/datasets/alzheimers/females/RES5k.r")


na_fill_mvalues_female_brain_diseased <- na_predict(mvalues = mvalues_5k_brain_diseased_females, age_vec = vec_age_female_diseased, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
na_fill_mvalues_female_brain_controls <- na_predict(mvalues = mvalues_5k_brain_controls_females, age_vec = vec_age_female_controls, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
setwd("~/R/ageing/datasets/alzheimers/females")
save(na_fill_mvalues_female_brain_diseased, file = "na_fill_mvalues_female_brain_diseased.r")
save(na_fill_mvalues_female_brain_controls, file = "na_fill_mvalues_female_brain_controls.r")
