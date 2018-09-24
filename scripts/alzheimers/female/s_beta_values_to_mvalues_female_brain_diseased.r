#load in the beta values of the brain tissue controls for females
load("~/R/ageing/datasets/alzheimers/females/brain_diseased_betavalues_female.r")

# define the m.value function. The m.value function reduces heteroscedasticity among illumina methylation array
# beta values by converting beta values into m values. 

source("~/R/ageing/functions/m_values.r")

tmp <- brain_diseased_betavalues_female

#This for loop creates an index which tells us which columns already contain m values.

index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}
index
#

tmp <- m.values(brain_diseased_betavalues_female)

tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6

setwd("~/R/ageing/datasets/alzheimers/females")
brain_diseased_mvalues_female <- tmp
save(brain_diseased_mvalues_female, file= "brain_diseased_mvalues_female.r")
