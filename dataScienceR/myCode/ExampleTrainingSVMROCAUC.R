magic04 = read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/magic/magic04.data", header = F, sep=",")


#Function begins
# split the data set in test and training set
split.data <- function(data, p = 0.7, s = 666){
  set.seed(s)
  index <- sample(1:dim(data)[1])
  train <- data[index[1:floor(dim(data)[1] * p)], ]
  test <- data[index[((ceiling(dim(data)[1] * p)) + 1):dim(data)[1]], ]
  return(list(train = train, test = test))
} 
#Function ends

#dati 
dati = split.data(magic04, p = 0.7)
train<-dati$train
test<-dati$test 

#str(train)
#str(test)


#SVM TRAINING 
library(e1071)
model <- svm(train[,1:10],train[,11], probability = T)
# prediction on the test set
pred <- predict(model, test[,1:(dim(test)[[2]]-1)], probability = T)
# Check the predictions
table(pred,test[,dim(test)[2]])
pred.prob <- attr(pred, "probabilities")
pred.to.roc <- pred.prob[, 1]
# performance assessment
library(ROCR)
pred.rocr <- prediction(pred.to.roc, as.factor(test[,(dim(test)[[2]])]))
perf.rocr <- performance(pred.rocr, measure = "auc", x.measure = "cutoff")
cat("AUC =",deparse(as.numeric(perf.rocr@y.values)),"\n")
perf.tpr.rocr <- performance(pred.rocr, "tpr","fpr")
plot(perf.tpr.rocr, colorize=T) 
