source("~/R/ageing/functions/na_predict.r")
load("~/R/ageing/datasets/alzheimers/males/mvalues_5k_brain_diseased_males.r")
load("~/R/ageing/datasets/alzheimers/males/mvalues_5k_brain_controls_males.r")
load("~/R/ageing/datasets/alzheimers/males/vec_age_male_diseased.r")
load("~/R/ageing/datasets/alzheimers/males/vec_age_male_controls.r")
load("~/R/ageing/datasets/alzheimers/males/POLYNOMIALS5k.r")
load("~/R/ageing/datasets/alzheimers/males/RES5k.r")


na_fill_mvalues_male_brain_diseased <- na_predict(mvalues = mvalues_5k_brain_diseased_males, age_vec = vec_age_male_diseased, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
na_fill_mvalues_male_brain_controls <- na_predict(mvalues = mvalues_5k_brain_controls_males, age_vec = vec_age_male_controls, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
setwd("~/R/ageing/datasets/alzheimers/males")
save(na_fill_mvalues_male_brain_diseased, file = "na_fill_mvalues_male_brain_diseased.r")
save(na_fill_mvalues_male_brain_controls, file = "na_fill_mvalues_male_brain_controls.r")
