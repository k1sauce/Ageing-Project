# a function na_predict to fill in missing values according to the models computed from healthy controls
# input m-values of probes (row) for every sample (column), age vector of each sample, POLYNOMIAL table and RES table from profile() function.
# 
library(polynom)
library(MonoPoly)
  na_predict <- function(mvalues, age_vec, POLYNOMIALS, RES){
    for(i in 1:dim(mvalues)[2]){
      #unknown is logical vector for NA values
      tmp <- mvalues[,i]
      unknown <- is.na(tmp)
      #N is the i'th column name, a is the age of the sample
      N <- colnames(mvalues)[i]
      a <- age_vec[i]
      #make a dataframe for the i'th sample tmp
      tmp <- as.data.frame(mvalues[,i])
      colnames(tmp) <- N
      rownames(tmp) <- rownames(mvalues)
      #effectively subsets the tmp dataframe by the logical vector for NA values to get probes with NA values
      unknown <- rownames(tmp)[unknown]
      metV <- c()
      #If there is any NA values then
      if(length(unknown) > 0){
        for(j in 1:length(unknown)){
          p <- POLYNOMIALS[[unknown[j]]] #assign pf the monotonic regression model for the given probe with missing values
          pf <- as.function(p)
          #this logic bounds the estimation between the min and max age values used to compute the monotonic regression model
          if(a > RES[unknown[j],"age_end"]){
            metVpf <- pf(RES[unknown[j],"age_end"])
            metV <- c(metV, metVpf)
          } else if (a < RES[unknown[j],"age_start"]){
            metVpf <- pf(RES[unknown[j],"age_start"])
            metV <- c(metV, metVpf)
          } else (metV <- c(metV, pf(a)))
        }
        #fill in the computed values back into the beta table
        tmp[unknown,] <- metV
        mvalues[,i] <- as.matrix(tmp)
        print(i)} else {print(i)}
    }
    return(mvalues)
  }