#load in the beta values of the liver tissue controls for females
load("~/R/ageing/datasets/nafld/females/beta_values_female_control_liver.r")
liver_controls_complete_female <- merge5
# define the m.value function. The m.value function reduces heteroscedasticity among illumina methylation array
# beta values by converting beta values into m values. 

source("~/R/ageing/functions/m_values.r")

#This for loop creates an index which tells us which columns already contain m values.
tmp <- liver_controls_complete_female

index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}
#
#columns 47 to 49 are mvalues
#check if zeros in beta values
sum(tmp[,c(1:46,50:57)] < 0, na.rm = T)
#Here I change the beta values into m values
tmp[,c(1:46,50:57)] <- m.values(tmp[,c(1:46,50:57)])
# I cap all m values within the range of 6 to -6 as m values range to infinity. 
tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6
# Save the modified dataset in ~/r/ageing/datasets as liver_controls_mvalues_female.r
setwd("~/R/ageing/datasets/nafld/females")
liver_controls_mvalues_female <- tmp
save(liver_controls_mvalues_female, file= "liver_controls_mvalues_female.r")

