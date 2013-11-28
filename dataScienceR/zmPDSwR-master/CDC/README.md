

# Example code and data for "Practical Data Science with R" by Nina Zumel and John Mount, Manning 2014.


 * The book: ["Practical Data Science with R" by Nina Zumel and John Mount, Manning 2014](http://affiliate.manning.com/idevaffiliate.php?id=1273_360)
 * The support site: [GitHub WinVector/zmPDSwR](https://github.com/WinVector/zmPDSwR)


## The code and data in this directory supports examples from:
 * Chapter 7: Using Linear and Logistic Regression
 * Chapter 9: Exploring Advanced Methods
 * Chapter 10: Documentation and Deployment


### Our works ([Creative Commons Attribution-NonCommercial 3.0 Unported License] [by-nc]):

Procedures for getting data (still in progress).

Data originally downloaded 4-25-2013 from http://www.cdc.gov/nchs/data_access/Vitalstatsonline.htm
* ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Dataset_Documentation/DVS/natality/UserGuide2010.pdf
* Shasum: 12520b8384defc63a93fad957936fd7ee9a42ef3  UserGuide2010.pdf
* ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/natality/Nat2010us.zip
* Shasum: dad8b9fc9e8b4a4d250b7febf10d4b97350e2651  Nat2010us.zip

get at data
```bash
  unzip Nat2010us.zip
  gzip -9 VS2010NATL.DETAILUS.DAT 
```

Extract fixed field defs from UserGuide2010.pdf (still need to be checked and editted):
*  fieldRanges.tsv

Define H2 database credentials:
*  dbDef.xml

Use SQLScrewdriver to load fixed field data into a H2 database:
```bash
  java -cp SQLScrewdriver.jar:h2-1.3.170.jar -Xmx1G com.winvector.db.LoadFFF file:dbDef.xml file:fieldRanges.tsv natal file:VS2010NATL.DETAILUS.DAT.gz
```

Get at a sample of the data from R:
```R
options( java.parameters = "-Xmx2g" )
library(RJDBC)
drv <- JDBC("org.h2.Driver","h2-1.3.170.jar",identifier.quote="'")
options <- ";LOG=0;CACHE_SIZE=65536;LOCK_MODE=0;UNDO_LOG=0"
conn <- dbConnect(drv,paste("jdbc:h2:NATAL",options,sep=''),"u","u")
d <- dbGetQuery(conn,"SELECT * FROM natal WHERE ORIGRANDGROUP<=10")
dbDisconnect(conn)
write.table(d,'natal2010Sample.tsv',quote=F,sep='\t',col.names=T,row.names=F)
# gzip -9 natal2010Sample.tsv
# recode 99 as unknown in APGAR5 column
d <- read.table('natal2010Sample.tsv.gz',sep='\t',header=T,stringsAsFactors=F)
# combine rare 4-and above births with 3
d$DPLURAL = pmin(d$DPLURAL,3)
# recode unknown in outcome column
d$APGAR5[d$APGAR5==99] <- NA
# recode U as unknown in risk columns
#factorCols <- c('RF_DIAB','RF_GEST','RF_PHYP','RF_GHYP','RF_ECLAM','RF_PPTERM','RF_PPOUTC', 'CIG_REC', 'DPLURAL', 'GESTREC3', 'PRECARE_REC')
factorCols <- c('CIG_REC', 'DPLURAL', 'GESTREC3', 'PRECARE_REC')
lapply(subset(d,,select=factorCols),
   function(col) summary(as.factor(col)))
for(colName in factorCols) {
  d[,colName] <- factor(ifelse(d[,colName] %in% list('','U'),NA,d[,colName]))
}
numCols <- c('DWGT')
for(colName in numCols) {
  d[,colName] <- ifelse(d[,colName] >=999,NA,d[,colName])
}
#d$atRisk <- d$BWTR4<2 | d$APGAR5<7
d$atRisk <- d$APGAR5<7
riskCols <- c(factorCols,numCols)
library(reshape2)
dTrain <- subset(d,ORIGRANDGROUP<=5)
dTest <- subset(d,ORIGRANDGROUP>5)
model <- glm(as.formula(paste('atRisk',paste(riskCols,collapse=' + '),sep=' ~ ')),
  data=dTrain,family=binomial(link='logit'))   
print(summary(model))
dTest$pred <- predict(model,newdata=dTest,type='response')
dplot <- subset(dTest,(!is.na(pred) & (!is.na(atRisk))))
ambientProb <- mean(dplot$atRisk)
table(pred=dplot$pred>=2*ambientProb,atRisk=dplot$atRisk)
```


### Works by others (no claim of license here):

* UserGuide2010.pdf : ( CDC supplied data user guide )


### Derived works (no claim of license here):

* fieldRanges.tsv : (derived from CDC documentation, needs editing).
* natal2010Sample.tsv.gz : uniform sample of CDC 2010 natality data (work in progress).


  [by-nc]: http://creativecommons.org/licenses/by-nc/3.0/ "Attribution-NonCommercial 3.0 Unported (CC BY-NC 3.0)"