library(neuralnet)
library(MonoPoly)
library(polynom)
source("~/R/ageing/functions/profile.r")
load("~/R/ageing/datasets/alzheimers/males/vec_age_mc_ad.r")
vec_age_male_controls <- vec_age
rm(vec_age)
load("~/R/ageing/datasets/alzheimers/males/brain_controls_mvalues_male_probes_removed.r")
setwd("~/R/ageing/datasets/alzheimers/males")
print("start profile")
profile(vec_age = vec_age_male_controls, mvalues = brain_controls_mvalues_male_preprocessed, alpha = 0.05, rss = 15)
