#load in the beta values of the brain tissue controls for males
load("~/R/ageing/datasets/alzheimers/males/beta_values_mc_ad.r")
brain_controls_complete_male <- mcmerge5
# define the m.value function. The m.value function reduces heteroscedasticity among illumina methylation array
# beta values by converting beta values into m values. 

source("~/R/ageing/functions/m_values.r")

#This for loop creates an index which tells us which columns already contain m values.
tmp <- brain_controls_complete_male

index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}
# in this case we find GSM1198802 GSM1198805 GSM1198807 contain negative beta values
# due to normalization. I've decided to change these values to 0.
tmp[tmp < 0] <- 0
#Here I change the beta values into m values
tmp <- m.values(tmp)
# I cap all m values within the range of 6 to -6 as m values range to infinity. 
tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6
# Save the modified dataset in ~/r/ageing/datasets as brain_controls_mvalues_male.r
setwd("~/R/ageing/datasets/alzheimers/males")
brain_controls_mvalues_male <- tmp
save(brain_controls_mvalues_male, file= "brain_controls_mvalues_male.r")

