# A function profile(), which takes as input a vector of ages in years for all samples and all the samples m-values at each probe
# alpha is the significance cut off for cor test, rss cut off for polynomial model.
# Outputs RSS, POLYNOMIALS, MAGNITUDES, and RES files
# RSS, residual sum of squares, a measure of a probes m-value monotonic correlation with age in the data
# POLYNOMIALS, a monotonic polynomial function for the probe
# MAGNITUDES, a dataframe of "mvalue_start","mvalue_end","mvalue_magnitude","methyl_state","age_start","age_end","delta_mag_year". "mvalue_start","mvalue_end", refer to the mvalue at the earliest and latest age used to constuct the model
# the "mvalue_magnitude" is the difference between the start and end m values. "methyl_state",  is one of methylated, demethylated, divergent+, or divergent- which refers to the methylation state of the probe during ageing. 
# for instance, a methylated probe is methylated at the start and end m-values, demethylated probe is demethylated at the start and end m values, divergent+ refers to a probe that changes from demethylated to methylated during ageing. 
# divergent- refers to a probe that changes from methylated to demethylated during ageing. The "age_start","age_end", refer to the starting and ending ages used to construct the model. "delta_mag_year" is simply the Magnitude change per year, can be positive or negative.
# the RES file is the RSS + MAGNITUDES file

profile = function(vec_age, mvalues, alpha = 1, rss = 35){
  
  #sources a modified cor.test base r function that ignores na values
  source(file = "~/R/ageing/functions/cor_test_m.r")
  
  #make a 2 column matrix with the same number of rows as the mvalues input matrix called cor_results
  d <- dim(mvalues)
  cor_results <- matrix(nrow = d[1],ncol = 2) 
  
  #fill cor_results with the output of a spearman's correlation test of monotonicity
  for(i in 1:d[1]){
    out <- cor.test.m(vec_age,as.numeric(mvalues[i,]),method="spearman")
    cor_results[i,1] <- out$estimate
    cor_results[i,2] <- out$p.value
  }
  rm(out)
  
  #set rownames of cor_results to probe IDs, make sure mvalues rownames are labelled correctly in input matrix
  row.names(cor_results) <- row.names(mvalues)
  
  #bonferroni correction adjust by alpha input
  #b <- (alpha/d[1])
  b <- alpha
  
  #sort by p-value and keep only significant probes
  cor_results <- cor_results[sort.list(cor_results[,2]), ]
  cor_results <- cor_results[cor_results[,2] < b,]
  cor_results <- cor_results[!is.na(cor_results[,2]),]
  
  #subset mvalues matrix by rownames of the significant cor_results and call it significant_cor_results
  significant_cor_results <- mvalues[rownames(cor_results),] 
  
  # Set up RSS, POLYNOMIALS, and MAGNITUDES tables. Also define the methyl.state function
  RSS <- data.frame("character",0)
  colnames(RSS) <-c("Probe","RSS")
  POLYNOMIALS <- list(0)
  names(POLYNOMIALS) <- "NA"
  methyl.state <- function(x1,x2){
    if(sign(x1)==sign(x2) & sign(x1) ==  1){
      print("methylated")
    } else if(sign(x1)==sign(x2) & sign(x1) == -1){
      print("demthylated")
    } else if(sign(x1)== -1 & sign(x2) == 1){
      print("divergent+")
    } else if(sign(x1)== 1 & sign(x2) == -1){
      print("divergent-")
    } else {print("error")}
  }				
  MAGNITUDES <- data.frame(0,0,0,"character",0,0,0)
  colnames(MAGNITUDES) <- c("mvalue_start","mvalue_end","mvalue_magnitude","methyl_state","age_start","age_end","delta_mag_year")
  
  #make monotonic polynomial models and fill in RSS, POLYNOMIALS, and MAGNITUDES tables
  for(i in 1:dim(significant_cor_results)[1]){
    #make the monotonic polynomial model for each significant probe
    mp <- monpol(as.numeric(significant_cor_results[i,])~vec_age)
    #adjust rss to keep best models, no more than five thousand models.
    if(mp$RSS < rss){
      # Fill in RSS table with best models
      tmp <- data.frame(row.names(significant_cor_results)[i],mp$RSS)
      colnames(tmp) <- c("Probe","RSS")
      RSS <- rbind(RSS, tmp)
      # Fill in POLYNOMIAL table with best model
      tmp <- list(polynomial(mp$beta.raw))
      names(tmp) <- row.names(significant_cor_results)[i]
      POLYNOMIALS <- c(POLYNOMIALS,tmp)
      # Fill in MAGNITUDE table for eahc monotonic polynomial model, bounded by minimum and maximum age of samples for each probe
      newage <- data.frame(vec_age=c(mp$minx,mp$minx+mp$sclx))
      tmp <- predict(mp,newdata = newage, scale = "original")
      mag <- data.frame(tmp[1],tmp[2],tmp[2,] - tmp[1,])
      colnames(mag) <- c("mvalue_start","mvalue_end","mvalue_magnitude")
      mag$methyl_state <- methyl.state(x1=tmp[1],x2=tmp[2])
      mag$age_start <- mp$minx
      mag$age_end <- mp$minx + mp$sclx
      mag$delta_mag_year <- mag$mvalue_magnitude/(mp$sclx) 
      MAGNITUDES <- rbind(MAGNITUDES,mag)
    }
  }
  # save tables 
  RSS <- RSS[-1,]
  save(RSS, file="RSS.r")
  POLYNOMIALS[1] <- NULL
  save(POLYNOMIALS, file="POLYNOMIALS.r")
  MAGNITUDES <- MAGNITUDES[-1,]
  save(MAGNITUDES, file="MAGNITUDES.r")
  # another convenient table to have is RSS and MAGNITUDES together, call it RES
  RES <- cbind(RSS, MAGNITUDES)
  rownames(RES) <- as.character(RES$Probe)
  save(RES, file="RES.r")
}