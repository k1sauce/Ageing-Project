#load in the beta values of the blood tissue controls for males
load("~/R/ageing/datasets/rheumatoid_arthritis/males/blood_controls_complete_male.r")

# define the m.value function. The m.value function reduces heteroscedasticity among illumina methylation array
# beta values by converting beta values into m values. 

source("~/R/ageing/functions/m_values.r")

#This is to remove the first column which containes illumina array probe names.

tmp <- blood_controls_complete_male
tmp <- tmp[,-1]

#This for loop creates an index which tells us which columns already contain m values.

index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}

#Here I change the beta values into m values
tmp[,1:1167] <- m.values(tmp[,1:1167])
tmp[,1254:2560] <- m.values(tmp[,1254:2560])
# I cap all m values within the range of 6 to -6 as m values range to infinity. 
tmp[tmp > 6] <- 6
tmp[tmp < -6] <- -6
# Save the modified dataset in ~/r/ageing/datasets as blood_controls_mvalues_male.r
setwd("~/R/ageing/datasets/rheumatoid_arthritis/males")
blood_controls_mvalues_male <- tmp
save(blood_controls_mvalues_male, file= "blood_controls_mvalues_male.r")

