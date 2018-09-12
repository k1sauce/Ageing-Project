load(file="coef_horvath.r")
xnam <- cf$CpGmarker
xnam <- xnam[-1]

load("~/R/ageing/datasets/rheumatoid_arthritis/males/horvath_age_betas_male_blood_controls.r")

int <- as.numeric(as.character(cf$CoefficientTraining[1]))
vec_coef <- as.numeric(as.character(cf$CoefficientTraining[-1]))
vec_probe_id <- xnam

meth_data <- t(meth_data)


horvath_age <- c()
for(i in 1:dim(meth_data)[2]){
a <- meth_data[,i]*vec_coef
a <- sum(a, na.rm = T)
a <- a + int
horvath_age <- c(horvath_age, a)}


inverse.F <- function(me_age){
  if(me_age <= 0){
    i.f <- ((10^me_age)*21) - 1
    return(i.f)
  } else if(me_age>0){ 
    i.f <- 21*me_age + 20
    return(i.f)
  }
}

horvath_age <- lapply(horvath_age,FUN=inverse.F)
n <- names(horvath_age)
horvath_age <- as.numeric(horvath_age)
names(horvath_age) <- n

load("~/R/ageing/datasets/rheumatoid_arthritis/males/vec_age_male_blood_controls.r")

cor(y = horvath_age, x = vec_age_male_blood_controls)
mean(abs(horvath_age - vec_age_male_blood_controls))
