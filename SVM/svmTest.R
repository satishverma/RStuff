source("plotDecisionBdd.R")

#Understanding and Visualizing SVMs
#number of data, number of dimensions

n<-150
p<-2

sigma<-1
meanpos<-0
meanneg <- 3
npos <- round(n/2)
nneg <- n-npos

#generate the positive and neg examples
xpos<-matrix(rnorm(npos*p,mean=meanpos,sd<-sigma),npos,p)
xneg <- matrix(rnorm(nneg*p,mean=meanneg,sd=sigma),npos,p)
x<-rbind(xpos,xneg)
print(x)


#generate the labels
y<-matrix(c(rep(1,npos),rep(-1,nneg)))

#visualize 
plot(x,col=ifelse(y>0,1,2))
legend("topleft",c("Positive","Negative"),col=seq(2),pch=1,text.col=seq(2))


#Split to get training and test data
ntrain<-round(0.8*n)
tindex<-sample(n,ntrain)
xtrain<-x[tindex,]
xtest<-x[-tindex,]
ytrain<-y[tindex,]
ytest<-y[-tindex,]
istrain=rep(0,n)
istrain[tindex]=1

#Visualize
plot(x,col=ifelse(y>0,1,2),pch=ifelse(istrain==1,1,2))
legend("topleft",c("Pos Train","Pos Test","Neg Train","Neg Test"),col=c(1,1,2,2),pch=c(1,2,1,2),text.col=c(1,1,2,2))


#svm 
library(kernlab)
svp<-ksvm(xtrain,ytrain,type="C-svc",kernel="vanilladot",C=100,scaled=c())

plotlinearsvm2D(svp,xtrain)


#attributes(svp)


#PREDICTION PART NOW THE THE SVM MODEL IS READY
ypred = predict(svp,xtest)
ypred
table(ytest,ypred)

#Accuracy
sum(ypred==ytest)/length(ytest)
ypredscore = predict(svp,xtest,type="decision")
ypredscore
table(ypredscore>0,ypred)

#ROCR
library(ROCR)
pred<-prediction(ypredscore,ytest)
#pred

perf<-performance(pred,measure="tpr",x.measure="fpr")
plot(perf)

perf<-performance(pred,measure="prec",x.measure="rec")
plot(perf)

perf<-performance(pred,measure="acc")
plot(perf)


cv.folds(9)