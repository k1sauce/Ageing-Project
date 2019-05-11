# This is to estimate the age of samples based on Horvath's 353 clock probes

#load in the coefficients of the 353 clock CpGs
load(file="~/R/ageing/datasets/coef_horvath.r")
xnam <- cf$CpGmarker
xnam <- xnam[-1]

# load in the samples used for age predicti0n validation
load("~/R/ageing/datasets/alzheimers/males/age_yx_test_controls.r")
ages <- as.numeric(age_yx_test_controls[1,])
gsms <- colnames(age_yx_test_controls)

# load in the betas from the original dataset
load("~/R/ageing/datasets/alzheimers/males/beta_values_mc_ad.r")
tmpdf <- mcmerge5[xnam,]
rm(mcmerge5)

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
  horvath_age <- c(horvath_age, a)}

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

save(horvath_age,file = "~/R/ageing/datasets/alzheimers/males/age_yx_test_controls_horvath_estimate.r")


#score
cor(y = horvath_age, x = ages) # 0.9460418
mean(abs(horvath_age - ages)) # 6.495214 years


#also on diseased samples
load("~/R/ageing/datasets/alzheimers/males/md_ad_beta.r")
tmpsinglegsed <- md_ad_beta[xnam,]
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
  horvath_age <- c(horvath_age, a)}

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

save(horvath_age,file = "~/R/ageing/datasets/alzheimers/males/male_diseased_betas_horvath_estimate.r")


#score
load("~/R/ageing/datasets/alzheimers/males/vec_age_male_diseased.r")
ages <- vec_age_male_diseased
cor(y = horvath_age, x = ages) # 0.628
mean(abs(horvath_age - ages)) # 14.69 years
mean(horvath_age - ages) # -14.69 years
