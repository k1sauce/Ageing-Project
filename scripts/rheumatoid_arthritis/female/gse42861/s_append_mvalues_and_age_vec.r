#append m_value and age_vec table

load("~/R/ageing/datasets/rheumatoid_arthritis/females/GSE42861_ra/blood_controls_mvalues_female.r")
load("~/R/ageing/datasets/rheumatoid_arthritis/females/beta_values_fc_b.r")

tmp <- merge20

source("~/R/ageing/functions/m_values.r")


#This for loop creates an index which tells us which columns already contain m values.

index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}

#verify mvalues
apply(tmp[,index], MARGIN = 2, FUN = min, na.rm=T)
apply(tmp[,index], MARGIN = 2, FUN = max, na.rm=T)


#Here I change the beta values into m values
tmp[,c(1:960,1067:1250,1311:2862)] <- m.values(tmp[,c(1:960,1067:1250,1311:2862)])
tmp[,c(1:960,1067:1250,1311:2862)] <- m.values(tmp[,c(1:960,1067:1250,1311:2862)])
# I cap all m values within the range of 6 to -6 as m values range to infinity and some processing is outside -6 to 6 range. 
tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6


mvalues_blood_controls_female <- cbind(tmp, blood_controls_mvalues_female)
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(mvalues_blood_controls_female, file="mvalues_blood_controls_female2.r")


rm(list = ls())

load("~/R/ageing/datasets/rheumatoid_arthritis/females/GSE42861_ra/female_diseased_betas.r")
source("~/R/ageing/functions/m_values.r")
tmp <- m.values(female_diseased_betas)
tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6
mvalues_blood_diseased_female <- tmp
setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
save(mvalues_blood_diseased_female, file = "mvalues_blood_diseased_female.r")
