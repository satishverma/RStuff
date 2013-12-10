library(topicmodels)
library(tm)
set.seed(1102)
library("XML")
library("SnowballC")

#install.packages("corpus.JSS.papers",repos = "http://datacube.wu.ac.at/")
data("JSS_papers", package = "corpus.JSS.papers")
attributes(JSS_papers)
#dim 556 15

remove_HTML_markup <-
  function(s) {
    doc <- htmlTreeParse(s, asText = TRUE, trim = FALSE)
    iconv(xmlValue(xmlRoot(doc)), "", "UTF-8")
  }


corpus <- Corpus(VectorSource(sapply(JSS_papers[, "description"], remove_HTML_markup)))
dtm <- DocumentTermMatrix(corpus,control = list(stemming = TRUE, stopwords = TRUE, minWordLength = 3,removeNumbers = TRUE))
dtm <- removeSparseTerms(dtm, 0.99)
dim(dtm)

#LDA 
jss_LDA <- LDA(dtm[1:450,], control = list(alpha = 0.1), k = 10)
post <- posterior(jss_LDA, newdata = dtm[-c(1:450),])
get_terms(jss_LDA, 5)