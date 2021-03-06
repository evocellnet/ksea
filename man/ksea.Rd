% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ksea.R
\name{ksea}
\alias{ksea}
\title{Kinase Set Enrichment Analysis}
\usage{
ksea(ranking, norm_express, signature, p = 1, display = TRUE,
  returnRS = FALSE, significance = FALSE, trial = 1000)
}
\arguments{
\item{ranking}{Vector of strings containing the ranking of all ids ordered based on
their quantifications.}

\item{norm_express}{Numeric vector with quantifications.}

\item{signature}{Vector of strings containing all ids in the signature.}

\item{p}{Numeric value indicating the power at which the weights are scaled.}

\item{display}{Logical. When TRUE prints the plot of the enrichment.Set to FALSE
when running in batch.}

\item{returnRS}{Logical. If TRUE a list with all the result attributes is returned.
If FALSE only a subset is printed based on the value of \code{significance}.}

\item{significance}{Logical. When \code{returnRS} is FALSE, if TRUE prints a list with the
ES and p-value. If FALSE only the Enrichment Score is printed.}

\item{trial}{Integer with number of iterations to calculate significance.}
}
\value{
Enrichment result. The output varies depends on the values of \code{returnRS}
and \code{significance}.
}
\description{
Enrichment of differentially regulated sites in a signature of kinase known targets
}
\details{
The Kinase Set Enrichment Analysis is a established analysis statistical method to look
for an enrichment on differentially regulated genes/proteins belonging to a given category
in a ranked list usually based on gene expression.
}
\author{
David Ochoa (code adapted from Francesco Ioirio's version of the same function).
}
