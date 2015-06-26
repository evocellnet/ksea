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
## [1] "M" "V" "U" "X" "S"
```

```r
sites <- rnorm(length(LETTERS))
names(sites) <- LETTERS
sites <- sites[order(sites, decreasing=TRUE)]
sites
```

```
##           X           Z           A           V           O           H 
##  1.65893111  0.95009321  0.78208600  0.77177370  0.72384673  0.61570291 
##           D           M           Y           J           F           R 
##  0.43395361  0.39844077  0.37872158  0.17841874  0.15080595  0.07230215 
##           U           E           W           L           Q           C 
## -0.03903746 -0.04094557 -0.05629761 -0.08365891 -0.15640349 -0.22658056 
##           T           G           I           S           P           N 
## -0.24810027 -0.29495063 -0.38296909 -0.41612990 -0.43166183 -0.49439111 
##           B           K 
## -1.16878279 -1.90545807
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
##         V 
## 0.6448573 
## 
## $p.value
##     V 
## 0.154
```

The function `ksea_batchKinases` calculates the KSEA p-value for a list of kinases. To improve the performance of the function, it uses as many cores as possible using the `parallell` package.


```r
regulons[["kinaseB"]] <- sample(LETTERS, 3)
regulons[["kinaseC"]] <- sample(LETTERS, 7)
regulons
```

```
## $kinaseA
## [1] "M" "V" "U" "X" "S"
## 
## $kinaseB
## [1] "X" "T" "H"
## 
## $kinaseC
## [1] "S" "P" "Z" "N" "F" "T" "O"
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
## kinaseA.V kinaseB.H kinaseC.O 
##     0.178     0.158     0.471
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
