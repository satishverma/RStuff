#Usage R --vanilla --slave --args -c cost -g gamma < commandArg.R

opt<-list()
args<-commandArgs(trailingOnly=TRUE)
message("Str of args")
print(str(args))
message("________________________")



helpFlg<-FALSE
if(length(args)==0) {
	helpFlg<-TRUE
} else {
	 if (  !(is.na(charmatch("-h", args)) & is.na(charmatch("-help", args))))
   		 helpFlg<-TRUE 
}


if( helpFlg==TRUE){
  message("Usage:")
  message("\tRscript ")
  message("\tR --vanilla --slave --args -c cVal -g gVal < commandArg.R")
  quit()
}




#read the parameters 
i <- charmatch("-cost", args)
if ( ! is.na(i) ) {
  if ( i+1 > length(args) ) {
    stop("ERROR: no arugment for '-cost'")
  }
  opt$cost <- as.integer(args[i+1])
  args[i] <- ''
  args[i+1] <- ''
}

i <- charmatch("-gamma", args)
if ( ! is.na(i) ) {
  if ( i+1 > length(args) ) {
    stop("ERROR: no arugment for '-gamma'")
  }
  opt$gamma <- as.integer(args[i+1])
  args[i] <- ''
  args[i+1] <- ''
} 

print(opt)
