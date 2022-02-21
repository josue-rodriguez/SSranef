
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
#> alpha 0.09      -0.08 0.26
#> sigma 0.79       0.72 0.86
#> tau   0.97       0.62 1.48
```

``` r
ranef_summary(alpha, ci = 0.95, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_alpha(y = d$y, unit = d$Subject)
#> 
#>           Post.mean q025  q975  PIP  BF_10 BF_01
#> theta_308  0.56      0.00  1.12 0.87  6.97 0.14 
#> theta_309 -1.45     -1.96 -0.95 1.00   Inf 0.00 
#> theta_310 -1.19     -1.71 -0.68 1.00   Inf 0.00 
#> theta_330  0.00     -0.33  0.29 0.23  0.30 3.31 
#> theta_331  0.03     -0.22  0.43 0.25  0.33 3.05 
#> theta_332  0.02     -0.25  0.40 0.24  0.31 3.19 
#> theta_333  0.07     -0.13  0.59 0.31  0.44 2.26 
#> theta_334 -0.04     -0.49  0.18 0.26  0.35 2.88 
#> theta_335 -0.87     -1.40 -0.30 0.99 92.02 0.01 
#> theta_337  1.18      0.66  1.68 1.00   Inf 0.00 
#> theta_349 -0.30     -0.94  0.00 0.62  1.62 0.62 
#> theta_350  0.04     -0.18  0.51 0.26  0.35 2.83 
#> theta_351 -0.07     -0.60  0.13 0.31  0.45 2.21 
#> theta_352  0.43      0.00  1.06 0.75  3.02 0.33 
#> theta_369  0.01     -0.27  0.34 0.22  0.27 3.64 
#> theta_370 -0.06     -0.54  0.14 0.28  0.40 2.53 
#> theta_371 -0.03     -0.46  0.18 0.23  0.29 3.42 
#> theta_372  0.09     -0.12  0.62 0.33  0.50 2.00
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
#> alpha -0.81     -1.01 -0.62
#> beta   0.19      0.15  0.22
#> sigma  0.47      0.42  0.51
#> tau1   0.44      0.26  0.66
#> tau2   0.16      0.10  0.24
#> rho    0.14     -0.38  0.71
```

``` r
ranef_summary(beta, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_beta(y = d$y, X = d$Days, unit = d$Subject)
#> 
#>            Post.mean q05   q95   PIP  BF_10  BF_01
#> theta1_308 -0.01     -0.42  0.38   NA     NA   NA 
#> theta1_309 -0.67     -1.15 -0.27   NA     NA   NA 
#> theta1_310 -0.68     -1.21 -0.25   NA     NA   NA 
#> theta1_330  0.29     -0.11  0.76   NA     NA   NA 
#> theta1_331  0.26     -0.09  0.67   NA     NA   NA 
#> theta1_332  0.12     -0.19  0.44   NA     NA   NA 
#> theta1_333  0.25     -0.07  0.58   NA     NA   NA 
#> theta1_334 -0.09     -0.42  0.23   NA     NA   NA 
#> theta1_335  0.01     -0.39  0.44   NA     NA   NA 
#> theta1_337  0.52      0.14  0.96   NA     NA   NA 
#> theta1_349 -0.41     -0.79 -0.08   NA     NA   NA 
#> theta1_350 -0.23     -0.70  0.21   NA     NA   NA 
#> theta1_351 -0.04     -0.39  0.36   NA     NA   NA 
#> theta1_352  0.41     -0.02  0.81   NA     NA   NA 
#> theta1_369  0.07     -0.25  0.39   NA     NA   NA 
#> theta1_370 -0.35     -0.84  0.07   NA     NA   NA 
#> theta1_371 -0.05     -0.38  0.27   NA     NA   NA 
#> theta1_372  0.25     -0.10  0.57   NA     NA   NA 
#> theta2_308  0.17      0.09  0.25 1.00 799.00 0.00 
#> theta2_309 -0.17     -0.25 -0.07 0.97  37.46 0.03 
#> theta2_310 -0.10     -0.19  0.00 0.85   5.46 0.18 
#> theta2_330 -0.06     -0.17  0.00 0.67   2.02 0.50 
#> theta2_331 -0.03     -0.12  0.00 0.44   0.79 1.27 
#> theta2_332  0.00     -0.04  0.04 0.25   0.34 2.96 
#> theta2_333  0.00     -0.04  0.03 0.23   0.30 3.29 
#> theta2_334  0.01     -0.02  0.07 0.27   0.36 2.77 
#> theta2_335 -0.20     -0.28 -0.12 1.00    Inf 0.00 
#> theta2_337  0.17      0.08  0.25 0.99  73.07 0.01 
#> theta2_349  0.01     -0.02  0.07 0.28   0.39 2.55 
#> theta2_350  0.11      0.00  0.20 0.91  10.63 0.09 
#> theta2_351 -0.03     -0.12  0.00 0.45   0.83 1.20 
#> theta2_352  0.04      0.00  0.14 0.55   1.21 0.83 
#> theta2_369  0.01     -0.03  0.06 0.27   0.37 2.71 
#> theta2_370  0.06      0.00  0.17 0.62   1.63 0.61 
#> theta2_371 -0.01     -0.07  0.02 0.29   0.42 2.40 
#> theta2_372  0.01     -0.01  0.07 0.26   0.36 2.78
```

``` r
caterpillar_plot(beta)
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

``` r
pip_plot(beta)
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

## Multivariate model

``` r
mv_data <- gen_mv_data(5, 5)
str(mv_data)
#> 'data.frame':    25 obs. of  4 variables:
#>  $ y1: num  1.47 3.81 5.81 3.79 3.22 ...
#>  $ y2: num  0.0613 1.6811 3.1749 1.1092 0.271 ...
#>  $ x : num  0 0 1 0 0 0 0 0 1 0 ...
#>  $ id: Factor w/ 5 levels "1","2","3","4",..: 1 1 1 1 1 2 2 2 2 2 ...

mv_model <- ss_ranef_mv(Y = cbind(mv_data$y1, mv_data$y2),
                        X = mv_data$x,
                        unit = mv_data$id,
                        burnin = 100,
                        iter = 500,
                        chains = 4)
#> Compiling model graph
#>    Resolving undeclared variables
#>    Allocating nodes
#> Graph information:
#>    Observed stochastic nodes: 25
#>    Unobserved stochastic nodes: 23
#>    Total graph size: 338
#> 
#> Initializing model

posterior_summary(mv_model)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_mv(Y = cbind(mv_data$y1, mv_data$y2), X = mv_data$x, 
#>     unit = mv_data$id, burnin = 100, iter = 500, chains = 4)
#> 
#>         Post.mean q05   q95  
#> B_1_1    3.01      2.31  3.68
#> B_1_2    1.87      0.37  3.62
#> B_2_1    2.72      2.04  3.47
#> B_2_2    4.74      2.30  6.79
#> rb_1_2   0.04     -0.98  0.97
#> rb_1_3  -0.08     -0.98  0.97
#> rb_1_4  -0.10     -0.99  0.99
#> rb_2_3   0.00     -0.97  0.98
#> rb_2_4  -0.47     -0.99  0.95
#> rb_3_4   0.08     -0.98  0.99
#> rw      -0.20     -0.52  0.14
#> sigma_1  1.65      1.25  2.17
#> sigma_2  1.69      1.27  2.37
#> Tau_1_1  8.74      0.29 34.63
#> Tau_2_2  6.98      0.30 25.87
#> Tau_3_3  8.55      0.24 37.29
#> Tau_4_4 17.05      1.60 49.79
```

## Priors

Priors can be passed on to either of the `ss_ranef` functions through a
named list and using JAGS code, e.g.,

``` r
# change prior for mean intercept
priors <- list(alpha = "alpha ~ dt(0, 1, 3)",
               # for each jth unit, change prior probability of inclusion
               gamma = "gamma[j] ~ dbern(0.75)") 

fit <- ss_ranef_alpha(y = d$y, unit = d$Subject, priors = priors)
#> Compiling model graph
#>    Resolving undeclared variables
#>    Allocating nodes
#> Graph information:
#>    Observed stochastic nodes: 180
#>    Unobserved stochastic nodes: 39
#>    Total graph size: 485
#> 
#> Initializing model
ranef_summary(fit)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_alpha(y = d$y, unit = d$Subject, priors = priors)
#> 
#>           Post.mean q05   q95   PIP  BF_10   BF_01
#> theta_308  0.62      0.05  1.07 0.96   24.00 0.04 
#> theta_309 -1.38     -1.82 -0.93 1.00     Inf 0.00 
#> theta_310 -1.13     -1.57 -0.69 1.00 3999.00 0.00 
#> theta_330  0.01     -0.32  0.37 0.51    1.04 0.97 
#> theta_331  0.07     -0.21  0.48 0.53    1.12 0.89 
#> theta_332  0.05     -0.25  0.45 0.52    1.07 0.93 
#> theta_333  0.15     -0.13  0.63 0.63    1.71 0.58 
#> theta_334 -0.06     -0.47  0.25 0.54    1.16 0.86 
#> theta_335 -0.82     -1.27 -0.37 0.99  180.82 0.01 
#> theta_337  1.18      0.75  1.63 1.00     Inf 0.00 
#> theta_349 -0.35     -0.84  0.00 0.81    4.29 0.23 
#> theta_350  0.12     -0.15  0.55 0.58    1.36 0.74 
#> theta_351 -0.12     -0.57  0.14 0.57    1.34 0.75 
#> theta_352  0.53      0.00  0.98 0.92   12.25 0.08 
#> theta_369  0.04     -0.25  0.42 0.50    1.00 1.00 
#> theta_370 -0.10     -0.53  0.20 0.56    1.28 0.78 
#> theta_371 -0.06     -0.45  0.23 0.53    1.13 0.88 
#> theta_372  0.17     -0.10  0.64 0.61    1.59 0.63
```

## Building on top of SSranef models

The code for each model can also be extracted to make more extensive
modifications or build more complex models

``` r
jags_model_text <- fit$model_text
cat(jags_model_text)
#> model{
#>   for (i in 1:N) {
#>     # likelihood
#>     y[i] ~ dnorm(alpha_j[unit[i]], precision)
#>   }
#>   for (j in 1:J) {
#>     gamma[j] ~ dbern(0.75)
#>     # non-centered parameterization
#>     alpha_raw[j] ~ dnorm(0, 1)
#>     theta[j] <- tau * alpha_raw[j] * gamma[j]
#>     alpha_j[j] <- alpha + theta[j]
#>     lambda[j] <- (tau^2 / (tau^2 + sigma^2/n_j[j])) * gamma[j]
#>   }
#>   alpha ~ dt(0, 1, 3)
#>   tau ~ dt(0, 1, 3)T(0, )
#>   precision <- pow(sigma, -2)
#>   sigma ~ dt(0, 1, 3)T(0, )
#> }
```
