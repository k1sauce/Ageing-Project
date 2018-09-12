#append m_value and age_vec table

load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/blood_controls_mvalues_male.r")
appendvalues <- blood_controls_mvalues_male
load("~/R/ageing/datasets/rheumatoid_arthritis/males/blood_controls_mvalues_male.r")
appended_mvalues_blood_controls_male <- cbind(blood_controls_mvalues_male, appendvalues)
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra")
save(appended_mvalues_blood_controls_male, file="appended_mvalues_blood_controls_male.r")

sum(duplicated(colnames(appended_mvalues_blood_controls_male)))

rm(list = ls())
load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/disease_state.r")
male_controls <- subset(disease_state, disease_state[,2] =="1" & disease_state[,4] == "2")
ages_append <- male_controls[,3]
load("~/R/ageing/datasets/rheumatoid_arthritis/males/vec_age_male_blood_controls.r")
vec_age_appened <- c(vec_age_male_blood_controls, ages_append)
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra")
save(vec_age_appened, file = "vec_age_appened.r")
