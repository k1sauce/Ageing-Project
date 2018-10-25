#load in the beta values of the blood tissue controls for females
load("~/R/ageing/datasets/rheumatoid_arthritis/females/GSE42861_ra/female_diseased_betas.r")

# define the m.value function. The m.value function reduces heteroscedasticity among illumina methylation array
# beta values by converting beta values into m values. 

source("~/R/ageing/functions/m_values.r")


tmp <- female_diseased_betas
tmp <- m.values(tmp)

tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6

setwd("~/R/ageing/datasets/rheumatoid_arthritis/females")
blood_diseased_mvalues_female <- tmp
save(blood_diseased_mvalues_female, file= "blood_diseased_mvalues_female.r")
