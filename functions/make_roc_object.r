#return the roc object for disease state predictions
make_roc_object <- function(data, probes, model){
  data <- local({
    load(data) 
    stopifnot(length(ls())==1) 
    environment()[[ls()]] 
  })
  probes <- local({
    load(probes) 
    stopifnot(length(ls())==1) 
    environment()[[ls()]] 
  })
  model <- local({
    load(model) 
    stopifnot(length(ls())==1) 
    environment()[[ls()]] 
  }) 
  pr_nn <- compute(model,data[,probes])
  prdf <- cbind(pr_nn$net.result,data[,1])
  prdf <- data.frame(prdf)
  prdf$delta <- prdf$X2 - prdf$X1 
  prdf <- prdf[order(-prdf$X1),]
  rank <- rev(seq_along(prdf$X1))
  return(roc(prdf$X2, rank, plot = F))
}