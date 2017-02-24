
[![Travis-CI Build Status](https://travis-ci.org/evocellnet/ksea.svg?branch=master)](https://travis-ci.org/evocellnet/ksea)

### Introduction

This package contains an implementation of the Kinase Set Enrichment Analysis (KSEA) used to predict kinase activities based on quantitative phosphoproteomic studies. Using a quantitative phosphoproteomic profile and a list of known targets, the algorithms predicts the activity of the based on the enrichment on top regulated sites within the known targets of the kinase.

![kinase](./kinase_GSEA.png)

###Installation

The `ksea` package can be installed directly from github (if public) or locally using the devtools package.


```r
install.packages('devtools')
```

#####Github installation


```r
require(devtools)
install_github("dogcaesar/ksea")
```

#####Local installation

You can clone this project and install it locally in your computer.


```r
require(devtools)
install("./ksea")
```

###Usage

First load the `ksea` package.


```r
library("ksea")
```

Next create some fake data. In one hand, we create a list named `regulons` containing a vector per kinase with the names of the known substrates. Secondly, we create a vector sites with quantifications for the sites going from A to Z. Finally, we sort the quantifications.


```r
regulons <- list(kinaseA=sample(LETTERS, 5))
regulons
```

```
## $kinaseA
## [1] "D" "Y" "M" "R" "F"
```

```r
sites <- rnorm(length(LETTERS))
names(sites) <- LETTERS
sites <- sites[order(sites, decreasing=TRUE)]
sites
```

```
##           H           W           M           T           B           Q 
##  1.35493454  1.22982337  1.20976224  1.19283534  1.07068773  1.03135307 
##           A           R           O           I           Z           V 
##  0.59213343  0.52228920  0.38475542  0.08131043 -0.03939757 -0.04698889 
##           J           U           Y           K           S           C 
## -0.06058610 -0.18578440 -0.24771177 -0.24956496 -0.48579737 -0.62584545 
##           X           E           L           N           F           P 
## -0.63211973 -0.67376567 -0.90732279 -1.10864892 -1.24098466 -1.43944726 
##           G           D 
## -1.49230285 -1.49906797
```

The function `ksea` will run the enrichment analysis for the provided quantifications and known kinase targets.


```r
ksea_result <- ksea(names(sites), sites, regulons[["kinaseA"]], trial=1000, significance = TRUE)
```

![plot of chunk ksea](figure/ksea-1.png) 

```r
ksea_result
```

```
## $ES
##          N 
## -0.4853042 
## 
## $p.value
##     N 
## 0.249
```

The function `ksea_batchKinases` calculates the KSEA p-value for a list of kinases. To improve the performance of the function, it uses as many cores as possible using the `parallell` package.


```r
regulons[["kinaseB"]] <- sample(LETTERS, 3)
regulons[["kinaseC"]] <- sample(LETTERS, 7)
regulons
```

```
## $kinaseA
## [1] "D" "Y" "M" "R" "F"
## 
## $kinaseB
## [1] "C" "E" "Z"
## 
## $kinaseC
## [1] "E" "H" "D" "O" "A" "T" "C"
```

```r
kinases_ksea <- ksea_batchKinases(names(sites), sites, regulons, trial=1000)
```

```
## Loading required package: parallel
```

```r
kinases_ksea
```

```
## kinaseA.N kinaseB.S kinaseC.T 
##     0.260     0.186     0.412
```

##### KSEA in parallel #####

Some functions such as `ksea_batchkinases` are optimized to run in parallel in multicore processors. By default they run in 2 cores (if available) but this number can be increased by changing the "mc.cores" variable.


```r
options("mc.cores" = 4)
```

If you are working with an LSF cluster, you can also take the number of cores allocated in the `bsub` command from the `LSB_MCPU_HOSTS` environment variable.


```r
## Setup multicore forking for mclapply based in bsub available cores
hosts <- Sys.getenv("LSB_MCPU_HOSTS")
if(length(hosts) >0){
ncores <- unlist(strsplit(hosts," "))[2]
}else{
ncores <- 1
}
options("mc.cores" = ncores)
```



### Developers

The package is documented using [roxygen2](http://cran.r-project.org/web/packages/roxygen2/index.html). After changing the code located in the `R/` folder remember to run 'make' on the main directory to create the documentation following the roxygen2 rules.

To work on the code you will need the `devtools` package installed (installation guide above).
