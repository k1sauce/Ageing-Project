GSE <- c()
for(i in 1:length(sd$GSM)){
  gsm <- as.character(sd$GSM[i])
  ret <- parseGEO(getGEOfile(gsm, amount="brief"))
  gse <- ret@header$series_id
  GSE <- c(GSE,gse[1])
}

