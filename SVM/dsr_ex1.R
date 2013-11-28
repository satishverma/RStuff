library('kernlab')
library('ggplot2')

#load the data spirals
data('spirals')

#spectral clustering to identify two spirals
sc<-specc(spirals,centers=2)
df <- data.frame(x=spirals[,1], y=spirals[,2],class = as.numeric(sc))
ggplot(data=df) + geom_point(aes(x=x,y=y,shape=as.factor(class),colour=as.factor(class)))+ scale_colour_brewer(palette="Set2") +coord_fixed() 


#KERNEL 1 
set.seed(2335246L)
df$group <- sample.int(100,size=dim(df)[[1]],replace=T)
sTrain <- subset(df,group>10)
sTest <- subset(df,group<=10)
mSVMV <- ksvm(class~x+y,data=sTrain,kernel='vanilladot')
sTest$predSVMV <- predict(mSVMV,newdata=sTest,type='response')
ggplot() +
  geom_point(data=sTest,aes(x=x,y=y,shape=predSVMV=='1'),
             show_guide=T) +
  geom_point(data=df,aes(x=x,y=y,shape=class=='1'),alpha=0.2,
             show_guide=F) +
  coord_fixed()


#KERNEL 2

mSVMG <- ksvm(class~x+y,data=sTrain,kernel='rbfdot')
sTest$predSVMG <- predict(mSVMG,newdata=sTest,type='response')
ggplot() +
  geom_point(data=sTest,aes(x=x,y=y,shape=predSVMG=='1'),
             show_guide=T) +
  geom_point(data=df,aes(x=x,y=y,shape=class=='1'),alpha=0.2,
             show_guide=F)
