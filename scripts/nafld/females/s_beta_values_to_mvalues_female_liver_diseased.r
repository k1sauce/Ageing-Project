#load in the beta values of the liver tissue diseased for females
load("~/R/ageing/datasets/nafld/females/beta_values_female_diseased_liver.r")
liver_diseased_betavalues_female <- fd_liver
source("~/R/ageing/functions/m_values.r")
tmp <- liver_diseased_betavalues_female

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

tmp <- m.values(liver_diseased_betavalues_female)

tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6

setwd("~/R/ageing/datasets/nafld/females")
liver_diseased_mvalues_female <- tmp
save(liver_diseased_mvalues_female, file= "liver_diseased_mvalues_female.r")
