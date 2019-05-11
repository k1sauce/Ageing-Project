# load(file="~/R/ageing/datasets/coef_horvath.r")
# xnam <- cf$CpGmarker
# xnam <- xnam[-1]
# 
# load("~/R/ageing/datasets/rheumatoid_arthritis/males/horvath_age_betas_male_blood_controls.r")
# 
# int <- as.numeric(as.character(cf$CoefficientTraining[1]))
# vec_coef <- as.numeric(as.character(cf$CoefficientTraining[-1]))
# vec_probe_id <- xnam
# 
# meth_data <- t(meth_data)
# 
# 
# horvath_age <- c()
# for(i in 1:dim(meth_data)[2]){
#   a <- meth_data[,i]*vec_coef
#   a <- sum(a, na.rm = T)
#   a <- a + int
#   horvath_age <- c(horvath_age, a)
# }
# 
# 
# 
# inverse.F <- function(me_age){
#   if(me_age <= 0){
#     i.f <- ((10^me_age)*21) - 1
#     return(i.f)
#   } else if(me_age>0){ 
#     i.f <- 21*me_age + 20
#     return(i.f)
#   }
# }
# 
# horvath_age <- lapply(horvath_age,FUN=inverse.F)
# n <- names(horvath_age)
# horvath_age <- as.numeric(horvath_age)
# names(horvath_age) <- n
# 
# load("~/R/ageing/datasets/rheumatoid_arthritis/males/vec_age_male_blood_controls.r")
# 
# cor(y = horvath_age, x = vec_age_male_blood_controls)
# mean(abs(horvath_age - vec_age_male_blood_controls))

# This is to estimate the age of samples based on Horvath's 353 clock probes

#load in the coefficients of the 353 clock CpGs
load(file="~/R/ageing/datasets/coef_horvath.r")
xnam <- cf$CpGmarker
xnam <- xnam[-1]

# load in the samples used for age prediction validation
load("~/R/ageing/datasets/rheumatoid_arthritis/males/age_yx_test_controls.r")
ages <- as.numeric(age_yx_test_controls[1,])
gsms <- colnames(age_yx_test_controls)

# load in the betas from the original dataset
load("~/R/ageing/datasets/rheumatoid_arthritis/males/blood_controls_complete_male.r")
tmpdf <- blood_controls_complete_male[xnam,]
rm(blood_controls_complete_male)
# also add the missing controls from GSE42861
load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/male_controls_betas.r")
tmpsinglegse <- male_controls_betas[xnam,]
rm(male_controls_betas)
#cbind the controls
tmpdf <- cbind(tmpdf,tmpsinglegse)

# select the samples used to validate age
tmpdf <- tmpdf[,gsms]
tmp <- tmpdf
#This for loop creates an index which tells us which columns already contain m values 
#or in some cases betas outside the c(0,1) range. 
index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}

# This can help investigate if m-value or out of bound beta value
for (i in 1:length(index)){
  col <- index[i]
  print(max(tmp[,col]))
}

#All the samples in the index are actually m-values
#so convert to beta values
source("~/R/ageing/functions/b_values.r")
tmp[,index] <- b.values(tmp[,index])

#
int <- as.numeric(as.character(cf$CoefficientTraining[1]))
vec_coef <- as.numeric(as.character(cf$CoefficientTraining[-1]))
vec_probe_id <- xnam

meth_data <- tmp
# needs to have probes as rows and samples as columns
# calculate the horvath age
horvath_age <- c()
for(i in 1:dim(meth_data)[2]){
  a <- meth_data[,i]*vec_coef
  a <- sum(a, na.rm = T)
  a <- a + int
  horvath_age <- c(horvath_age, a)
}

#invert it back to the estimate age in years
inverse.F <- function(me_age){
  if(me_age <= 0){
    i.f <- ((10^me_age)*21) - 1
    return(i.f)
  } else if(me_age>0){ 
    i.f <- 21*me_age + 20
    return(i.f)
  }
}

#unlist and name
horvath_age <- lapply(horvath_age,FUN=inverse.F)
horvath_age <- as.numeric(horvath_age)
names(horvath_age) <- colnames(meth_data)


#score
cor(y = horvath_age, x = ages) # 0.937
mean(abs(horvath_age - ages)) # 5.565 years

#save the horvath age predictions of age_yx_test_controls
save(horvath_age,file = "~/R/ageing/datasets/rheumatoid_arthritis/males/age_yx_test_controls_horvath_estimate.r")
#also on diseased samples
load("~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/male_diseased_betas.r")
tmpsinglegsed <- male_diseased_betas[xnam,]
tmp <- tmpsinglegsed
index <- c()
for (i in 1:dim(tmp)[2]){
  if (max(tmp[,i], na.rm = T) > 1 | min(tmp[,i], na.rm = T) < 0){
    index <- c(index, i)
  }
}
#all betas so conver with
meth_data <- tmp
# needs to have probes as rows and samples as columns
# calculate the horvath age
horvath_age <- c()
for(i in 1:dim(meth_data)[2]){
  a <- meth_data[,i]*vec_coef
  a <- sum(a, na.rm = T)
  a <- a + int
  horvath_age <- c(horvath_age, a)
}

#invert it back to the estimate age in years
inverse.F <- function(me_age){
  if(me_age <= 0){
    i.f <- ((10^me_age)*21) - 1
    return(i.f)
  } else if(me_age>0){ 
    i.f <- 21*me_age + 20
    return(i.f)
  }
}

#unlist and name
horvath_age <- lapply(horvath_age,FUN=inverse.F)
horvath_age <- as.numeric(horvath_age)
names(horvath_age) <- colnames(meth_data)

save(horvath_age, file="~/R/ageing/datasets/rheumatoid_arthritis/males/GSE42861_ra/male_diseased_betas_horvath_estimate.r")

#score
load("~/R/ageing/datasets/rheumatoid_arthritis/males/vec_age_male_blood_diseased.r")
ages <- vec_age_male_blood_diseased
cor(y = horvath_age, x = ages) # 0.867
mean(abs(horvath_age - ages)) # 4.06 years
mean(horvath_age - ages) # 0.657 years

