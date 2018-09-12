#load in the beta values of the blood tissue controls for males
load("~/R/ageing/datasets/rheumatoid_arthritis/males/blood_diseased_betavalues_male.r")

# define the m.value function. The m.value function reduces heteroscedasticity among illumina methylation array
# beta values by converting beta values into m values. 

m.values = function(x){
  log2(x/(1-x))
}

tmp <- blood_diseased_betavalues_male
tmp <- m.values(blood_diseased_betavalues_male)

tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6

setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
blood_diseased_mvalues_male <- tmp
save(blood_diseased_mvalues_male, file= "blood_diseased_mvalues_male.r")
