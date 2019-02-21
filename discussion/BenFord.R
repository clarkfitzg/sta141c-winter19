###Benford's theoretical distribution
BenFord<-function(x){
  log10(1+1/x)
}
### Function that get first digit from a number k
GetFirstDigit <- function(k){ 
  as.numeric(head(strsplit(as.character(k),'')[[1]],n=1))
}

### check probability sum to 1
sum(BenFord(1:9))
### plot
barplot(BenFord(1:9))
### example with dataset "USArrests"
### Take Assault as example
head(USArrests)
l = unlist(USArrests["Assault"])
leadingnumbers = sapply(X = l,FUN = GetFirstDigit)
### prop.table is a way to get empirical distribution for these leadingnumbers
barplot(prop.table(table(leadingnumbers)))

### KLD function
### Note: Here the function does not take corner case into consideration.
###       For a complete KLD function, "P(X) = 0" or "Q(x) = 0" is the corner case
###       We may not need to consider that in this hw, 
###       but it is a good habit to design functions that can handle all cases, or return some error messages.
KLD<-function(P,Q){
  sum(sapply(1:9, function(x){ P(x)*(log10(P(x)) -log10(Q(x)))}))
}

