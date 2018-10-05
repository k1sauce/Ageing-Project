source("~/R/ageing/functions/na_predict.r")
load("~/R/ageing/datasets/nafld/males/mvalues_5k_liver_diseased_males.r")
load("~/R/ageing/datasets/nafld/males/mvalues_5k_liver_controls_males.r")
load("~/R/ageing/datasets/nafld/males/vec_age_male_diseased.r")
load("~/R/ageing/datasets/nafld/males/vec_age_male_controls.r")
load("~/R/ageing/datasets/nafld/males/POLYNOMIALS5k.r")
load("~/R/ageing/datasets/nafld/males/RES5k.r")


na_fill_mvalues_male_liver_diseased <- na_predict(mvalues = mvalues_5k_liver_diseased_males, age_vec = vec_age_male_diseased, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
na_fill_mvalues_male_liver_controls <- na_predict(mvalues = mvalues_5k_liver_controls_males, age_vec = vec_age_male_controls, POLYNOMIALS = POLYNOMIALS5k, RES = RES5k)
setwd("~/R/ageing/datasets/nafld/males")
save(na_fill_mvalues_male_liver_diseased, file = "na_fill_mvalues_male_liver_diseased.r")
save(na_fill_mvalues_male_liver_controls, file = "na_fill_mvalues_male_liver_controls.r")
