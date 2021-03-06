
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SSranef

<!-- badges: start -->
<!-- badges: end -->

SSranef is an R package for random effects selection that corresponds to
the models described in Rodriguez, Williams, and Rast (2021).
Specifically, `ss_ranef_alpha()` fits a random intercepts model with a
spike-and-slab prior on the random effects and `ss_ranef_beta()` fits a
model with both random intercepts and random slopes, with a
spike-and-slab prior on the random effects for the slope. The function
`ss_ranef_mv()` fits a multivariate mixed-effects models for two
outcomes and places a spike-and-slab prior on the random slope for each
outcome.

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
#> alpha 0.08      -0.08 0.24
#> sigma 0.79       0.72 0.87
#> tau   0.98       0.60 1.51
```

``` r
ranef_summary(alpha, ci = 0.95, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_alpha(y = d$y, unit = d$Subject)
#> 
#>           Post.mean q025  q975  PIP  BF_10 BF_01
#> theta_308  0.58      0.00  1.14 0.87  6.94 0.14 
#> theta_309 -1.43     -1.96 -0.91 1.00   Inf 0.00 
#> theta_310 -1.18     -1.70 -0.67 1.00   Inf 0.00 
#> theta_330  0.00     -0.28  0.31 0.22  0.28 3.55 
#> theta_331  0.03     -0.20  0.44 0.24  0.32 3.15 
#> theta_332  0.02     -0.24  0.42 0.24  0.32 3.12 
#> theta_333  0.08     -0.11  0.61 0.30  0.42 2.36 
#> theta_334 -0.03     -0.47  0.19 0.24  0.31 3.19 
#> theta_335 -0.86     -1.39 -0.32 0.99 92.02 0.01 
#> theta_337  1.19      0.70  1.69 1.00   Inf 0.00 
#> theta_349 -0.27     -0.91  0.00 0.59  1.41 0.71 
#> theta_350  0.06     -0.13  0.51 0.28  0.39 2.56 
#> theta_351 -0.07     -0.56  0.13 0.30  0.42 2.39 
#> theta_352  0.46      0.00  1.07 0.79  3.87 0.26 
#> theta_369  0.02     -0.25  0.40 0.23  0.31 3.27 
#> theta_370 -0.06     -0.56  0.13 0.27  0.37 2.68 
#> theta_371 -0.03     -0.45  0.21 0.24  0.31 3.22 
#> theta_372  0.09     -0.12  0.64 0.34  0.51 1.97
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
#> alpha -0.84     -1.05 -0.62
#> beta   0.19      0.15  0.22
#> sigma  0.47      0.42  0.51
#> tau1   0.46      0.25  0.69
#> tau2   0.16      0.10  0.27
#> rho    0.18     -0.37  0.86
```

``` r
ranef_summary(beta, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_beta(y = d$y, X = d$Days, unit = d$Subject)
#> 
#>            Post.mean q05   q95   PIP  BF_10  BF_01
#> theta1_308  0.02     -0.40  0.42   NA     NA   NA 
#> theta1_309 -0.64     -1.09 -0.23   NA     NA   NA 
#> theta1_310 -0.69     -1.19 -0.23   NA     NA   NA 
#> theta1_330  0.30     -0.12  0.79   NA     NA   NA 
#> theta1_331  0.28     -0.08  0.71   NA     NA   NA 
#> theta1_332  0.14     -0.18  0.48   NA     NA   NA 
#> theta1_333  0.28     -0.05  0.63   NA     NA   NA 
#> theta1_334 -0.08     -0.42  0.25   NA     NA   NA 
#> theta1_335  0.02     -0.38  0.43   NA     NA   NA 
#> theta1_337  0.54      0.15  0.97   NA     NA   NA 
#> theta1_349 -0.38     -0.73 -0.05   NA     NA   NA 
#> theta1_350 -0.19     -0.65  0.23   NA     NA   NA 
#> theta1_351 -0.04     -0.40  0.33   NA     NA   NA 
#> theta1_352  0.46      0.03  0.88   NA     NA   NA 
#> theta1_369  0.09     -0.24  0.44   NA     NA   NA 
#> theta1_370 -0.35     -0.84  0.06   NA     NA   NA 
#> theta1_371 -0.02     -0.35  0.33   NA     NA   NA 
#> theta1_372  0.26     -0.08  0.61   NA     NA   NA 
#> theta2_308  0.17      0.09  0.25 1.00 570.43 0.00 
#> theta2_309 -0.17     -0.25 -0.08 0.99  73.07 0.01 
#> theta2_310 -0.09     -0.19  0.00 0.79   3.67 0.27 
#> theta2_330 -0.06     -0.16  0.00 0.64   1.78 0.56 
#> theta2_331 -0.03     -0.12  0.00 0.44   0.77 1.30 
#> theta2_332  0.00     -0.04  0.04 0.25   0.33 3.06 
#> theta2_333  0.00     -0.03  0.03 0.25   0.33 3.07 
#> theta2_334  0.01     -0.02  0.07 0.28   0.38 2.62 
#> theta2_335 -0.20     -0.28 -0.12 1.00    Inf 0.00 
#> theta2_337  0.17      0.09  0.25 1.00 306.69 0.00 
#> theta2_349  0.01     -0.02  0.07 0.26   0.35 2.88 
#> theta2_350  0.11      0.00  0.20 0.89   8.05 0.12 
#> theta2_351 -0.02     -0.11  0.00 0.43   0.76 1.32 
#> theta2_352  0.04      0.00  0.14 0.52   1.08 0.92 
#> theta2_369  0.01     -0.01  0.06 0.26   0.35 2.87 
#> theta2_370  0.06      0.00  0.17 0.67   2.03 0.49 
#> theta2_371 -0.01     -0.07  0.02 0.27   0.36 2.75 
#> theta2_372  0.01     -0.01  0.08 0.30   0.42 2.39
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
#>  $ y1: num  0.158 0.661 5.618 4.208 1.802 ...
#>  $ y2: num  8.43 1.92 7.65 7.79 8.34 ...
#>  $ x : num  1 0 1 1 1 1 0 1 1 1 ...
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
#> B_1_1    3.32      1.68   4.91
#> B_1_2   -0.85     -3.32   1.70
#> B_2_1    3.27      2.75   3.80
#> B_2_2    3.09      2.00   4.53
#> rb_1_2   0.14     -0.98   0.99
#> rb_1_3   0.19     -0.97   1.00
#> rb_1_4  -0.13     -0.99   0.99
#> rb_2_3   0.08     -0.98   0.99
#> rb_2_4   0.07     -0.99   0.99
#> rb_3_4  -0.02     -0.99   0.99
#> rw       0.20     -0.16   0.53
#> sigma_1  3.79      2.88   4.95
#> sigma_2  1.06      0.79   1.42
#> Tau_1_1 67.74      0.26 228.48
#> Tau_2_2 12.65      0.37  47.95
#> Tau_3_3 25.13      0.32  69.44
#> Tau_4_4 18.28      2.49  56.27
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
#>           Post.mean q05   q95   PIP  BF_10  BF_01
#> theta_308  0.62      0.06  1.06 0.96  24.16 0.04 
#> theta_309 -1.37     -1.83 -0.93 1.00    Inf 0.00 
#> theta_310 -1.13     -1.57 -0.69 1.00    Inf 0.00 
#> theta_330  0.01     -0.31  0.36 0.51   1.03 0.97 
#> theta_331  0.07     -0.21  0.49 0.55   1.22 0.82 
#> theta_332  0.06     -0.23  0.44 0.53   1.11 0.90 
#> theta_333  0.15     -0.11  0.59 0.61   1.57 0.64 
#> theta_334 -0.05     -0.45  0.23 0.51   1.04 0.96 
#> theta_335 -0.82     -1.25 -0.40 1.00 249.00 0.00 
#> theta_337  1.19      0.77  1.62 1.00    Inf 0.00 
#> theta_349 -0.34     -0.82  0.00 0.80   4.04 0.25 
#> theta_350  0.12     -0.14  0.56 0.57   1.34 0.75 
#> theta_351 -0.11     -0.56  0.16 0.57   1.32 0.76 
#> theta_352  0.53      0.00  0.99 0.91  10.63 0.09 
#> theta_369  0.04     -0.24  0.42 0.50   1.00 1.00 
#> theta_370 -0.10     -0.54  0.16 0.55   1.21 0.83 
#> theta_371 -0.06     -0.46  0.23 0.52   1.08 0.92 
#> theta_372  0.18     -0.10  0.65 0.66   1.90 0.53
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

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-rodriguez2021" class="csl-entry">

Rodriguez, Josue E, Donald R Williams, and Philippe Rast. 2021. ???Who Is
and Is Not" Average???"? Random Effects Selection with Spike-and-Slab
Priors.??? <https://doi.org/10.31234/osf.io/4d9tv>.

</div>

</div>
