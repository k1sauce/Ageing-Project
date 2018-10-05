#load in the beta values of the liver tissue controls for males
load("~/R/ageing/datasets/nafld/males/beta_values_male_control_liver.r")
liver_controls_complete_male <- merge5
# define the m.value function. The m.value function reduces heteroscedasticity among illumina methylation array
# beta values by converting beta values into m values. 

source("~/R/ageing/functions/m_values.r")

#This for loop creates an index which tells us which columns already contain m values.
tmp <- liver_controls_complete_male

index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}
#
#columns 1 to 60 contain beta values 61 to 64 mvalues
#check if zeros in beta values
sum(tmp[,1:60] < 0, na.rm = T)
#Here I change the beta values into m values
tmp[,1:60] <- m.values(tmp[,1:60])
# I cap all m values within the range of 6 to -6 as m values range to infinity. 
tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6
# Save the modified dataset in ~/r/ageing/datasets as liver_controls_mvalues_male.r
setwd("~/R/ageing/datasets/nafld/males")
liver_controls_mvalues_male <- tmp
save(liver_controls_mvalues_male, file= "liver_controls_mvalues_male.r")

