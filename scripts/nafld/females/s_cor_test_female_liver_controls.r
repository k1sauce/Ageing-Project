library(neuralnet)
library(MonoPoly)
library(polynom)
source("~/R/ageing/functions/profile.r")
load("~/R/ageing/datasets/nafld/males/vec_age_male_control.r")
vec_age_male_controls <- vec_age
rm(vec_age)
load("~/R/ageing/datasets/nafld/males/liver_controls_mvalues_male_probes_removed.r")
setwd("~/R/ageing/datasets/nafld/males")
print("start profile")
profile(vec_age = vec_age_male_controls, mvalues = liver_controls_mvalues_male_preprocessed, alpha = 0.05, rss = 5)
