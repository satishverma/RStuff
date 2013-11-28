plotlinearsvm2D=function(svp,xtrain)
  ## Pretty plot a linear SVM with decision boundary ##
  ## xtrain should be a 2-dimensional data.
{
  # Define the range of the plot
  # First column is plotted vertically
  yr <- c(min(xtrain[,1]), max(xtrain[,1]))
  # Second column is plotted horizontally
  xr <- c(min(xtrain[,2]), max(xtrain[,2]))
  
  # Plot the points of xtrain with different signs for positive/negative and SV/non SV
  plot(xr,yr,type='n')
  ymat <- ymatrix(svp)
  points(xtrain[-SVindex(svp),2], xtrain[-SVindex(svp),1], pch = ifelse(ymat[-SVindex(svp)] < 0, 2, 1))
  points(xtrain[SVindex(svp),2], xtrain[SVindex(svp),1], pch = ifelse(ymat[SVindex(svp)] < 0, 17, 16))
  
  # Extract w and b from the model	
  w <- colSums(coef(svp)[[1]] * xtrain[SVindex(svp),])
  b <- b(svp)
  
  # Draw the lines 
  abline(b/w[1],-w[2]/w[1])
  abline((b+1)/w[1],-w[2]/w[1],lty=2)
  abline((b-1)/w[1],-w[2]/w[1],lty=2)
}


