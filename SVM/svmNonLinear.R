numData<-200
numClass<-2

#Gaussian
sigma<.5

#Divide into 4 groups
# 

meanpos1<-0
meanpos2<-4
meanneg1 <- 0
meanneg2 <- 3
npos <- (numData/2)
nneg <- numData-npos


#generate the positive and neg examples
xpos1 <-matrix(rnorm(npos*p,mean=meanpos1,sd<-sigma),npos,p)
xpos2 <- matrix(rnorm(npos*p,mean=meanpos2,sd=sigma),npos,p)
xneg1 <-matrix(rnorm(npos*p,mean=meanneg1,sd<-sigma),npos,p)
xneg1[,2]=xneg1[,2]+4
xneg2 <-matrix(rnorm(npos*p,mean=meanneg2,sd<-sigma),npos,p)
xneg2[,2]=xneg2[,2]-4


x<-rbind(xpos1,xpos2,xneg1,xneg2)
print(x)
#generate the labels
y<-matrix(c(rep(1,npos),rep(1,npos),rep(-1,npos),rep(-1,npos)))

#visualize 
plot(x,col=ifelse(y>0,1,2))
legend("topleft",c("Positive","Negative"),col=seq(2),pch=1,text.col=seq(2))

print(y)

svp <- ksvm(x,y,type="C-svc",kernel='rbf',kpar=list(sigma=1),C=1)
plot(svp,data=x)


#PREDICTION
ypred=predict(svp,x)
table(ypred,y)
library(gplots)
library(ROCR)
ypredscore=predict(svp,x,type="decision")
pred<-prediction(ypredscore,y)
perf=performance(pred,measure="prec",x.measure="rec")
plot(perf)