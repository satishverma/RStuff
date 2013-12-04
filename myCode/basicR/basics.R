#Types of Data
#character numeric integer logical complex
#vector list matrix data.frame

cData <- "ABC"
str(cData)
#integer
iData <- 5L
str(iData)

nData <- 5
str(nData)

inf_ <- Inf
nan_ <- 0/0

print(inf_)
print(nan_)

#ATTRIBUTES
attributes(nData)

#VECTOR data of same type
vecX<-vector("numeric",length=5)
print(vecX)

#MATRIX Created one column at a time
mData <- matrix(nrow=2,ncol=3)
mData
attributes(mData)
attributes(mData)$dim[1]

#cbind and rbind
c1<-c(1,2,3)
c2<-c(4,5,6)
m1 <-rbind(c1,c2)
m1


#LIST  listData has [[]] while other types have []
lData <- list(1,"A",TRUE,"34")
lData

#FACTORS Categorical Data , Ordered or Unordered
fData <- factor(c("Y","N","Y"))
fData
table(fData)
unclass(fData)


#Apply a test on a vector
x<-c(0,1,2,3,NA)
is.na(x)


#data.frame
#row.names data.matrx -> convert df to matrix

#function names
x<-1:3
names(x)=c("a","b","c")
x



#SUBSETTING 
#[] [[]] $
#[] return obj of same class as the input 
#[[]] extract single element from list or d.f and return object need not be same as input
#$ --- single element by name from d.f or list 


#MATRIX
mat<-matrix(1:6,nrow=2,ncol=3)
subMat<-mat[c(1:2),,drop=FALSE]
str(subMat)

#Indexing, REMOVING NAs
x<-c(1,2,3,NA,5,4,NA,8)
bad<-is.na(x)
good<-x[!bad]
good

#complete.cases
x<-c(1,2,NA,3)
y<-c(3,NA,NA,4)
good<-complete.cases(x,y)
good