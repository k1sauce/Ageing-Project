#load in the beta values of the liver tissue diseased for males
load("~/R/ageing/datasets/nafld/males/beta_values_male_disease_liver.r")
liver_diseased_betavalues_male <- md_liver
source("~/R/ageing/functions/m_values.r")
tmp <- liver_diseased_betavalues_male

#This for loop creates an index which tells us which columns already contain m values.

index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}
index
# check zeros
sum(tmp[tmp < 0], na.rm = T)
#

tmp <- m.values(liver_diseased_betavalues_male)

tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6

setwd("~/R/ageing/datasets/nafld/males")
liver_diseased_mvalues_male <- tmp
save(liver_diseased_mvalues_male, file= "liver_diseased_mvalues_male.r")
