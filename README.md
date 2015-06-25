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

Next create some fake data. In one hand, we create a list named `regulons` containing a vector per kinase with the names of the known substrates. Secondly, we create a vector sites with quantifications for the sites going from A to Z.


```r
regulons <- list(kinaseA=sample(LETTERS, 5))
regulons
```

```
## $kinaseA
## [1] "W" "M" "K" "P" "Y"
```

```r
sites <- rnorm(length(LETTERS))
names(sites) <- LETTERS
sites
```

```
##            A            B            C            D            E 
##  0.625324365 -0.577288591  0.008483193  0.009401793  0.184715982 
##            F            G            H            I            J 
##  0.904663114  0.339512278  1.460114804 -0.193408012 -0.044867689 
##            K            L            M            N            O 
##  0.756278462  1.551934349  0.798047060 -0.944701346 -0.150922121 
##            P            Q            R            S            T 
##  0.446089149 -0.189256209 -0.492199379  0.096011965 -1.154183518 
##            U            V            W            X            Y 
## -2.163000945 -0.332748398  0.168692442 -0.049034005  1.175449545 
##            Z 
##  0.240151411
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
##          J 
## -0.4761905 
## 
## $p.value
##     J 
## 0.241
```

The function `ksea_batchKinases` calculates the KSEA p-value for a list of kinases. To improve the performance of the function, it uses as many cores as possible using the `parallell` package.


```r
regulons[["kinaseB"]] <- sample(LETTERS, 3)
regulons[["kinaseC"]] <- sample(LETTERS, 7)
regulons
```

```
## $kinaseA
## [1] "W" "M" "K" "P" "Y"
## 
## $kinaseB
## [1] "S" "X" "T"
## 
## $kinaseC
## [1] "E" "R" "U" "A" "O" "X" "H"
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
## kinaseA.J kinaseB.R kinaseC.T 
##     0.261     0.049     0.561
```


### Developers

The package is documented using [roxygen2](http://cran.r-project.org/web/packages/roxygen2/index.html). After changing the code located in the `R/` folder remember to run 'make' on the main directory to create the documentation following the roxygen2 rules.

To work on the code you will need the `devtools` package installed (read above to installation guide).
