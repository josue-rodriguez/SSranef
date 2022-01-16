
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SSranef

<!-- badges: start -->
<!-- badges: end -->

SSranef is an R package for random effects selection that corresponds to
the models described in Rodriguez, Williams, and Rast (2021).
Specifically, `ss_ranef_alpha()` fits a random intercepts model with a
spike-and-slab prior on the random effects, and `ss_ranef_beta()` fits a
model with both random intercepts and random slopes, with a
spike-and-slab prior on the random effects for the slope.

## Installation

This package can be installed with

``` r
# install.packages("devtools")
devtools::install_github("josue-rodriguez/SSranef")
```

## Example

Because `SSranef` uses JAGS as a backend, we must also load the `rjags`
package.

``` r
library(SSranef)
library(rjags)
#> Loading required package: coda
#> Linked to JAGS 4.3.0
#> Loaded modules: basemod,bugs

d <- lme4::sleepstudy
```

## Alpha model

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
#> alpha 0.09      -0.08 0.25
#> sigma 0.79       0.72 0.86
#> tau   1.00       0.62 1.63
```

``` r
ranef_summary(alpha, ci = 0.95, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_alpha(y = d$y, unit = d$Subject)
#> 
#>           Post.mean q025  q975  PIP  BF_10   BF_01
#> theta_308  0.57      0.00  1.12 0.88    7.25 0.14 
#> theta_309 -1.45     -1.97 -0.92 1.00     Inf 0.00 
#> theta_310 -1.19     -1.71 -0.65 1.00 1999.00 0.00 
#> theta_330  0.00     -0.32  0.29 0.22    0.28 3.58 
#> theta_331  0.03     -0.23  0.44 0.25    0.34 2.94 
#> theta_332  0.02     -0.26  0.40 0.24    0.31 3.21 
#> theta_333  0.07     -0.11  0.60 0.30    0.42 2.38 
#> theta_334 -0.04     -0.48  0.17 0.25    0.33 3.05 
#> theta_335 -0.87     -1.40 -0.26 0.98   60.54 0.02 
#> theta_337  1.19      0.66  1.69 1.00     Inf 0.00 
#> theta_349 -0.29     -0.93  0.00 0.61    1.54 0.65 
#> theta_350  0.05     -0.14  0.52 0.27    0.36 2.75 
#> theta_351 -0.07     -0.58  0.14 0.30    0.42 2.39 
#> theta_352  0.44      0.00  1.05 0.76    3.24 0.31 
#> theta_369  0.02     -0.23  0.39 0.22    0.29 3.47 
#> theta_370 -0.05     -0.56  0.15 0.26    0.35 2.89 
#> theta_371 -0.03     -0.46  0.17 0.24    0.31 3.20 
#> theta_372  0.09     -0.11  0.63 0.33    0.49 2.06
```

``` r
caterpillar_plot(alpha)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

``` r
pip_plot(alpha)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

## Beta model

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
#> alpha -0.83     -1.02 -0.64
#> beta   0.18      0.15  0.22
#> sigma  0.47      0.42  0.51
#> tau1   0.43      0.26  0.65
#> tau2   0.17      0.09  0.26
#> rho    0.11     -0.43  0.64
```

``` r
ranef_summary(beta, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_beta(y = d$y, X = d$Days, unit = d$Subject)
#> 
#>            Post.mean q05   q95   PIP  BF_10  BF_01
#> theta1_308  0.00     -0.40  0.40   NA     NA   NA 
#> theta1_309 -0.63     -1.06 -0.21   NA     NA   NA 
#> theta1_310 -0.66     -1.17 -0.19   NA     NA   NA 
#> theta1_330  0.31     -0.09  0.78   NA     NA   NA 
#> theta1_331  0.26     -0.09  0.68   NA     NA   NA 
#> theta1_332  0.14     -0.18  0.47   NA     NA   NA 
#> theta1_333  0.28     -0.04  0.62   NA     NA   NA 
#> theta1_334 -0.08     -0.41  0.24   NA     NA   NA 
#> theta1_335  0.02     -0.37  0.44   NA     NA   NA 
#> theta1_337  0.52      0.11  0.95   NA     NA   NA 
#> theta1_349 -0.37     -0.72 -0.05   NA     NA   NA 
#> theta1_350 -0.21     -0.66  0.24   NA     NA   NA 
#> theta1_351 -0.03     -0.37  0.35   NA     NA   NA 
#> theta1_352  0.43      0.02  0.82   NA     NA   NA 
#> theta1_369  0.09     -0.23  0.42   NA     NA   NA 
#> theta1_370 -0.36     -0.80  0.04   NA     NA   NA 
#> theta1_371 -0.03     -0.37  0.32   NA     NA   NA 
#> theta1_372  0.27     -0.07  0.60   NA     NA   NA 
#> theta2_308  0.17      0.09  0.26 0.99 165.67 0.01 
#> theta2_309 -0.17     -0.25 -0.08 1.00 570.43 0.00 
#> theta2_310 -0.10     -0.20  0.00 0.83   4.76 0.21 
#> theta2_330 -0.06     -0.16  0.00 0.65   1.88 0.53 
#> theta2_331 -0.02     -0.11  0.00 0.40   0.66 1.51 
#> theta2_332  0.00     -0.05  0.03 0.24   0.32 3.11 
#> theta2_333  0.00     -0.04  0.03 0.23   0.30 3.32 
#> theta2_334  0.01     -0.02  0.07 0.29   0.41 2.43 
#> theta2_335 -0.20     -0.28 -0.12 1.00    Inf 0.00 
#> theta2_337  0.17      0.09  0.26 0.99 141.86 0.01 
#> theta2_349  0.01     -0.02  0.06 0.25   0.33 3.05 
#> theta2_350  0.11      0.00  0.20 0.90   9.44 0.11 
#> theta2_351 -0.03     -0.12  0.00 0.42   0.73 1.37 
#> theta2_352  0.05      0.00  0.14 0.58   1.37 0.73 
#> theta2_369  0.01     -0.02  0.06 0.26   0.35 2.86 
#> theta2_370  0.06      0.00  0.16 0.69   2.24 0.45 
#> theta2_371 -0.01     -0.06  0.02 0.26   0.35 2.89 
#> theta2_372  0.01     -0.01  0.08 0.28   0.40 2.52
```

``` r
caterpillar_plot(beta)
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

``` r
pip_plot(beta)
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />
