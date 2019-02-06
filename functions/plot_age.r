# funciton to plot age prediction vs true age
# X is the matrix of m-values and Y is the true age of the samples
# MODEL is the keras model
plot_age <- function(X, PX,xlab,ylab,ggtitle,shape,pointsize,textsize){
  df <- data.frame(cbind(X, PX))
  colnames(df) <- c("Age", "P")
  ggplot(df, aes(y = P, x = Age)) +
    stat_density2d(aes(fill = ..density..), geom = "tile", contour = FALSE, n = 200) +
    scale_fill_continuous(low = "white", high = "dodgerblue4") +
    scale_shape_identity() +
    geom_point(alpha =0.5, color="red", aes(shape=shape), size=pointsize) +
    geom_smooth(method = 'lm', color = "red", linetype="dashed", size = 0.3, se=F) +
    geom_abline(intercept = 0, slope = 1, color = "black", size=0.3) + 
    xlim(0,100) + 
    ylim(0,100) +
    xlab(xlab) +
    ylab(ylab) +
    ggtitle(ggtitle) +
    theme(legend.position = "none", plot.title = element_text(size = textsize), text = element_text(size=textsize))
}

