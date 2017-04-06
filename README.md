[![Travis-CI Build Status](https://travis-ci.org/evocellnet/ksea.svg?branch=master)](https://travis-ci.org/evocellnet/ksea)

### Introduction

This package contains an implementation of the Kinase Set Enrichment Analysis (KSEA) used to predict kinase activities based on quantitative phosphoproteomic studies. Using a quantitative phosphoproteomic profile and a list of known targets, the algorithms predicts the activity of the based on the enrichment on top regulated sites within the known targets of the kinase.

![kinase](./kinase_GSEA.png)

###Installation

The `ksea` package can be installed directly from github (if public) or locally using the devtools package.


```r
install.packages('devtools')
```

##### Github installation


```r
require(devtools)
install_github("evocellnet/ksea")
```

##### Local installation

You can clone this project and install it locally in your computer.


```r
require(devtools)
install("./ksea")
```

### Usage

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
## [1] "Y" "C" "I" "S" "B"
```

```r
sites <- rnorm(length(LETTERS))
names(sites) <- LETTERS
sites <- sites[order(sites, decreasing=TRUE)]
sites
```

```
##            E            U            Z            N            S 
##  1.611089290  1.250664569  1.234637179  1.082452371  1.026981805 
##            B            Q            J            M            D 
##  0.575379472  0.532877556  0.474246843  0.421483820  0.358049788 
##            F            K            Y            G            O 
##  0.194403791  0.162551646  0.150628008  0.008759558 -0.150678120 
##            P            C            W            V            T 
## -0.156401856 -0.237702939 -0.240834542 -0.254118235 -0.317312680 
##            H            R            A            I            X 
## -0.337654466 -0.406046178 -0.433621274 -0.585813866 -1.189626572 
##            L 
## -1.706905250
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
##         B 
## 0.4314363 
## 
## $p.value
##     B 
## 0.447
```

The function `ksea_batchKinases` calculates the KSEA p-value for a list of kinases. To improve the performance of the function, it uses as many cores as possible using the `parallell` package.


```r
regulons[["kinaseB"]] <- sample(LETTERS, 3)
regulons[["kinaseC"]] <- sample(LETTERS, 7)
regulons
```

```
## $kinaseA
## [1] "Y" "C" "I" "S" "B"
## 
## $kinaseB
## [1] "J" "N" "E"
## 
## $kinaseC
## [1] "W" "E" "C" "Z" "G" "A" "U"
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
## kinaseA.B kinaseB.J kinaseC.Z 
##     0.439     0.091     0.005
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
