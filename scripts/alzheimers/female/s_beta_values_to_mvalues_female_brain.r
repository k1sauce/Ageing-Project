#load in the beta values of the brain tissue controls for females
load("~/R/ageing/datasets/alzheimers/females/beta_values_fc_ad.r")
brain_controls_complete_female <- beta_values_fc_ad
# define the m.value function. The m.value function reduces heteroscedasticity among illumina methylation array
# beta values by converting beta values into m values. 

source("~/R/ageing/functions/m_values.r")

#This for loop creates an index which tells us which columns already contain m values.

index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}

#Here I change the beta values into m values
tmp <- m.values(tmp)
# I cap all m values within the range of 6 to -6 as m values range to infinity. 
tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6
# Save the modified dataset in ~/r/ageing/datasets as brain_controls_mvalues_female.r
setwd("~/R/ageing/datasets/alzheimers/females")
brain_controls_mvalues_female <- tmp
save(brain_controls_mvalues_female, file= "brain_controls_mvalues_female.r")

