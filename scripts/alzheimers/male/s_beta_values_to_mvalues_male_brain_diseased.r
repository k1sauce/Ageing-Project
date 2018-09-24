#load in the beta values of the brain tissue diseased for males
load("~/R/ageing/datasets/alzheimers/males/md_ad_beta.r")
brain_diseased_betavalues_male <- md_ad_beta
source("~/R/ageing/functions/m_values.r")
tmp <- brain_diseased_betavalues_male

#This for loop creates an index which tells us which columns already contain m values.

index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}
index
#

tmp <- m.values(brain_diseased_betavalues_male)

tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6

setwd("~/R/ageing/datasets/alzheimers/males")
brain_diseased_mvalues_male <- tmp
save(brain_diseased_mvalues_male, file= "brain_diseased_mvalues_male.r")
