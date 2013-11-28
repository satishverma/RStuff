

cv.folds <- function(n,folds=3){
  split(sample(n),rep(1:folds,length=length(n)))
}