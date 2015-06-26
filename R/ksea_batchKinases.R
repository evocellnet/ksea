##' Runs KSEA in batch for all Kinase-Substrates
##'
##' This functions allows to run the KSEA in a given dataset for all provided kinases.
##' The function makes use of all available cores in the computer (using \code{parallel})
##' package.
##' @title Batch KSEA for all kinase regulons
##' @param ranking vector with all quantified positions
##' @param logvalues vector with all quantifications
##' @param regulons list containing vectors with substrates of each kinase. Substrates
##' should be encoded with the same id as the \code{ranking} vector.
##' @param trial Number of permutations used for the empirical p-value generation.
##' @return A vector of p-values containing all KSEA p-values for all 
##' @author David Ochoa
##' 
ksea_batchKinases <- function(ranking, logvalues, regulons, trial=1000){
  require(parallel)
  tests <- mclapply(regulons, function(x)
    ksea(ranking, logvalues, x,
          display=FALSE,
          returnRS=FALSE,
          significance=TRUE,
          trial=trial), mc.preschedule = FALSE)
  if(is.matrix(tests)){
    pvals <-  unlist(tests["p.value", ])
  }else{
    pvals <- sapply(tests, function(x) if(is.list(x)){return(x$p.value)}else{return(x)})
  }
  return(pvals)
}
