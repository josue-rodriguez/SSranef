
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SSranef

<!-- badges: start -->
<!-- badges: end -->

The goal of SSranef is to …

## Installation

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("josue-rodriguez/SSranef")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(SSranef)
library(rjags)
#> Loading required package: coda
#> Linked to JAGS 4.3.0
#> Loaded modules: basemod,bugs

d <- lme4::sleepstudy
```

``` r
d$y <- c(scale(d$Reaction))
alpha <- ss_ranef_alpha(y = d$y, unit = d$Subject)
#> Compiling model graph
#>    Resolving undeclared variables
#>    Allocating nodes
#> Graph information:
#>    Observed stochastic nodes: 180
#>    Unobserved stochastic nodes: 39
#>    Total graph size: 486
#> 
#> Initializing model
posterior_summary(alpha, ci = 0.90, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_alpha(y = d$y, unit = d$Subject)
#> 
#>       Post.mean q05   q95 
#> alpha 0.09      -0.08 0.26
#> sigma 0.79       0.72 0.86
#> tau   0.95       0.61 1.46
ranef_summary(alpha, ci = 0.95, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_alpha(y = d$y, unit = d$Subject)
#> 
#>           Post.mean q025  q975  PIP  BF_10  BF_01
#> theta_308  0.56      0.00  1.14 0.87   6.92 0.14 
#> theta_309 -1.45     -1.98 -0.94 1.00    Inf 0.00 
#> theta_310 -1.19     -1.72 -0.67 1.00 999.00 0.00 
#> theta_330  0.00     -0.32  0.30 0.22   0.27 3.65 
#> theta_331  0.03     -0.19  0.42 0.25   0.33 3.04 
#> theta_332  0.02     -0.26  0.40 0.23   0.31 3.26 
#> theta_333  0.07     -0.12  0.57 0.29   0.41 2.42 
#> theta_334 -0.04     -0.47  0.18 0.25   0.32 3.08 
#> theta_335 -0.87     -1.39 -0.33 0.99 128.03 0.01 
#> theta_337  1.19      0.69  1.69 1.00    Inf 0.00 
#> theta_349 -0.29     -0.93  0.00 0.61   1.55 0.65 
#> theta_350  0.05     -0.16  0.53 0.27   0.36 2.77 
#> theta_351 -0.08     -0.63  0.11 0.32   0.47 2.14 
#> theta_352  0.44      0.00  1.04 0.78   3.61 0.28 
#> theta_369  0.01     -0.27  0.39 0.23   0.29 3.41 
#> theta_370 -0.06     -0.59  0.16 0.30   0.43 2.31 
#> theta_371 -0.04     -0.48  0.20 0.26   0.34 2.91 
#> theta_372  0.09     -0.11  0.63 0.33   0.50 2.00
```

``` r
beta <- ss_ranef_beta(y = d$y, X = d$Days, unit = d$Subject)
#> Compiling model graph
#>    Resolving undeclared variables
#>    Allocating nodes
#> Graph information:
#>    Observed stochastic nodes: 180
#>    Unobserved stochastic nodes: 60
#>    Total graph size: 1316
#> 
#> Initializing model
posterior_summary(beta, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_beta(y = d$y, X = d$Days, unit = d$Subject)
#> 
#>       Post.mean q05   q95  
#> alpha -0.85     -1.08 -0.62
#> beta   0.19      0.15  0.23
#> sigma  0.47      0.42  0.52
#> tau1   0.43      0.26  0.64
#> tau2   0.15      0.10  0.24
#> rho    0.20     -0.26  0.73
ranef_summary(beta, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_beta(y = d$y, X = d$Days, unit = d$Subject)
#> 
#>            Post.mean q05   q95   PIP  BF_10  BF_01
#> theta1_308  0.04     -0.38  0.46   NA     NA   NA 
#> theta1_309 -0.64     -1.08 -0.23   NA     NA   NA 
#> theta1_310 -0.65     -1.17 -0.20   NA     NA   NA 
#> theta1_330  0.33     -0.11  0.84   NA     NA   NA 
#> theta1_331  0.29     -0.08  0.70   NA     NA   NA 
#> theta1_332  0.14     -0.20  0.47   NA     NA   NA 
#> theta1_333  0.28     -0.05  0.63   NA     NA   NA 
#> theta1_334 -0.06     -0.41  0.27   NA     NA   NA 
#> theta1_335  0.02     -0.37  0.44   NA     NA   NA 
#> theta1_337  0.58      0.18  1.03   NA     NA   NA 
#> theta1_349 -0.37     -0.73 -0.04   NA     NA   NA 
#> theta1_350 -0.16     -0.61  0.29   NA     NA   NA 
#> theta1_351 -0.03     -0.38  0.38   NA     NA   NA 
#> theta1_352  0.44      0.03  0.86   NA     NA   NA 
#> theta1_369  0.09     -0.24  0.43   NA     NA   NA 
#> theta1_370 -0.32     -0.82  0.07   NA     NA   NA 
#> theta1_371 -0.03     -0.37  0.32   NA     NA   NA 
#> theta1_372  0.27     -0.08  0.63   NA     NA   NA 
#> theta2_308  0.16      0.08  0.25 0.99 124.00 0.01 
#> theta2_309 -0.17     -0.25 -0.08 0.99 116.65 0.01 
#> theta2_310 -0.10     -0.20  0.00 0.83   5.04 0.20 
#> theta2_330 -0.06     -0.17  0.00 0.68   2.16 0.46 
#> theta2_331 -0.03     -0.13  0.00 0.45   0.83 1.21 
#> theta2_332  0.00     -0.04  0.03 0.26   0.34 2.90 
#> theta2_333  0.00     -0.04  0.03 0.22   0.28 3.52 
#> theta2_334  0.00     -0.03  0.06 0.27   0.37 2.72 
#> theta2_335 -0.20     -0.28 -0.12 1.00 999.00 0.00 
#> theta2_337  0.16      0.07  0.24 0.98  50.28 0.02 
#> theta2_349  0.00     -0.03  0.06 0.26   0.35 2.82 
#> theta2_350  0.10      0.00  0.19 0.88   7.33 0.14 
#> theta2_351 -0.03     -0.12  0.00 0.44   0.80 1.25 
#> theta2_352  0.04      0.00  0.14 0.54   1.17 0.85 
#> theta2_369  0.01     -0.02  0.06 0.27   0.36 2.74 
#> theta2_370  0.05      0.00  0.16 0.62   1.61 0.62 
#> theta2_371 -0.01     -0.06  0.02 0.29   0.41 2.42 
#> theta2_372  0.01     -0.01  0.07 0.28   0.38 2.61
```
