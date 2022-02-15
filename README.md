
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
#> alpha 0.08      -0.08 0.24
#> sigma 0.79       0.72 0.86
#> tau   0.96       0.62 1.44
```

``` r
ranef_summary(alpha, ci = 0.95, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_alpha(y = d$y, unit = d$Subject)
#> 
#>           Post.mean q025  q975  PIP  BF_10 BF_01
#> theta_308  0.57      0.00  1.14 0.87  6.77 0.15 
#> theta_309 -1.45     -1.98 -0.92 1.00   Inf 0.00 
#> theta_310 -1.19     -1.71 -0.67 1.00   Inf 0.00 
#> theta_330  0.00     -0.31  0.34 0.23  0.29 3.41 
#> theta_331  0.03     -0.21  0.44 0.24  0.32 3.08 
#> theta_332  0.02     -0.25  0.39 0.23  0.30 3.29 
#> theta_333  0.07     -0.10  0.57 0.31  0.44 2.27 
#> theta_334 -0.04     -0.48  0.18 0.24  0.32 3.15 
#> theta_335 -0.86     -1.40 -0.31 0.99 79.00 0.01 
#> theta_337  1.19      0.68  1.69 1.00   Inf 0.00 
#> theta_349 -0.28     -0.92  0.00 0.59  1.46 0.68 
#> theta_350  0.05     -0.17  0.53 0.28  0.39 2.57 
#> theta_351 -0.07     -0.59  0.12 0.30  0.43 2.31 
#> theta_352  0.45      0.00  1.04 0.78  3.57 0.28 
#> theta_369  0.01     -0.25  0.37 0.22  0.28 3.56 
#> theta_370 -0.06     -0.54  0.14 0.27  0.37 2.71 
#> theta_371 -0.04     -0.49  0.20 0.25  0.34 2.98 
#> theta_372  0.09     -0.11  0.65 0.33  0.49 2.04
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
#> alpha -0.82     -1.01 -0.62
#> beta   0.19      0.15  0.22
#> sigma  0.47      0.42  0.51
#> tau1   0.43      0.24  0.67
#> tau2   0.15      0.09  0.23
#> rho    0.19     -0.34  0.71
```

``` r
ranef_summary(beta, digits = 2)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_beta(y = d$y, X = d$Days, unit = d$Subject)
#> 
#>            Post.mean q05   q95   PIP  BF_10  BF_01
#> theta1_308  0.01     -0.39  0.39   NA     NA   NA 
#> theta1_309 -0.65     -1.11 -0.24   NA     NA   NA 
#> theta1_310 -0.68     -1.21 -0.22   NA     NA   NA 
#> theta1_330  0.28     -0.12  0.73   NA     NA   NA 
#> theta1_331  0.24     -0.08  0.62   NA     NA   NA 
#> theta1_332  0.13     -0.19  0.47   NA     NA   NA 
#> theta1_333  0.27     -0.05  0.59   NA     NA   NA 
#> theta1_334 -0.07     -0.40  0.24   NA     NA   NA 
#> theta1_335  0.01     -0.39  0.41   NA     NA   NA 
#> theta1_337  0.53      0.14  0.96   NA     NA   NA 
#> theta1_349 -0.38     -0.74 -0.06   NA     NA   NA 
#> theta1_350 -0.19     -0.65  0.23   NA     NA   NA 
#> theta1_351 -0.04     -0.39  0.38   NA     NA   NA 
#> theta1_352  0.43      0.01  0.84   NA     NA   NA 
#> theta1_369  0.09     -0.24  0.40   NA     NA   NA 
#> theta1_370 -0.35     -0.86  0.05   NA     NA   NA 
#> theta1_371 -0.04     -0.35  0.28   NA     NA   NA 
#> theta1_372  0.26     -0.07  0.61   NA     NA   NA 
#> theta2_308  0.17      0.09  0.25 1.00 332.33 0.00 
#> theta2_309 -0.17     -0.25 -0.08 0.98  57.82 0.02 
#> theta2_310 -0.10     -0.19  0.00 0.81   4.19 0.24 
#> theta2_330 -0.06     -0.15  0.00 0.65   1.84 0.54 
#> theta2_331 -0.02     -0.10  0.00 0.40   0.65 1.53 
#> theta2_332  0.00     -0.04  0.04 0.25   0.34 2.95 
#> theta2_333  0.00     -0.03  0.04 0.24   0.31 3.18 
#> theta2_334  0.01     -0.02  0.06 0.25   0.33 3.00 
#> theta2_335 -0.20     -0.28 -0.12 1.00    Inf 0.00 
#> theta2_337  0.17      0.09  0.25 1.00 332.33 0.00 
#> theta2_349  0.01     -0.03  0.07 0.28   0.38 2.62 
#> theta2_350  0.11      0.00  0.20 0.90   9.39 0.11 
#> theta2_351 -0.03     -0.12  0.00 0.42   0.74 1.36 
#> theta2_352  0.04      0.00  0.14 0.56   1.25 0.80 
#> theta2_369  0.01     -0.03  0.06 0.30   0.42 2.37 
#> theta2_370  0.06      0.00  0.17 0.66   1.94 0.52 
#> theta2_371 -0.01     -0.06  0.02 0.26   0.35 2.87 
#> theta2_372  0.01     -0.01  0.07 0.29   0.41 2.45
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

Note, this currently only returns an MCMC list for the posterior samples

``` r
mv_data <- gen_mv_data(5, 5)
str(mv_data)
#> 'data.frame':    25 obs. of  4 variables:
#>  $ y1: num  0.729 -1.701 -1.716 3.144 1.191 ...
#>  $ y2: num  8.32 8.66 7.75 3.93 2.31 ...
#>  $ x : num  1 1 1 0 0 1 0 1 1 0 ...
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

summary(mv_model$posterior_samples)
#> 
#> Iterations = 1101:1600
#> Thinning interval = 1 
#> Number of chains = 4 
#> Sample size per chain = 500 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>                Mean      SD Naive SE Time-series SE
#> B[1,1]      0.94669  1.3046 0.029171       0.073365
#> B[2,1]      2.91772  0.4850 0.010845       0.030106
#> B[1,2]      1.54485  1.7184 0.038426       0.109331
#> B[2,2]      3.82628  1.8398 0.041139       0.334069
#> Tau[1,1]   21.75830 58.4544 1.307079       6.879021
#> Tau[2,1]   11.02283 34.4368 0.770030       4.424008
#> Tau[3,1]    2.35404 31.9266 0.713900       3.581963
#> Tau[4,1]    9.07713 27.0763 0.605446       3.741602
#> Tau[1,2]   11.02283 34.4368 0.770030       4.424008
#> Tau[2,2]   16.42595 26.9885 0.603482       3.422651
#> Tau[3,2]    0.39593 22.5162 0.503478       2.433544
#> Tau[4,2]   10.60887 19.2665 0.430812       2.942279
#> Tau[1,3]    2.35404 31.9266 0.713900       3.581963
#> Tau[2,3]    0.39593 22.5162 0.503478       2.433544
#> Tau[3,3]   13.39847 31.1617 0.696798       3.136519
#> Tau[4,3]    1.58881 21.0119 0.469841       2.491407
#> Tau[1,4]    9.07713 27.0763 0.605446       3.741602
#> Tau[2,4]   10.60887 19.2665 0.430812       2.942279
#> Tau[3,4]    1.58881 21.0119 0.469841       2.491407
#> Tau[4,4]   15.94898 17.8647 0.399467       1.216561
#> gamma1[1]   0.39850  0.4897 0.010950       0.030554
#> gamma1[2]   0.44700  0.4973 0.011120       0.020488
#> gamma1[3]   0.76900  0.4216 0.009427       0.039005
#> gamma1[4]   0.32100  0.4670 0.010442       0.026803
#> gamma1[5]   0.55300  0.4973 0.011120       0.020664
#> gamma2[1]   0.73400  0.4420 0.009883       0.048472
#> gamma2[2]   0.91150  0.2841 0.006352       0.027212
#> gamma2[3]   0.68000  0.4666 0.010433       0.056362
#> gamma2[4]   0.96600  0.1813 0.004053       0.034596
#> gamma2[5]   0.46200  0.4987 0.011151       0.045606
#> rb[1,1]     1.00000  0.0000 0.000000       0.000000
#> rb[2,1]     0.22593  0.7858 0.017571       0.156292
#> rb[3,1]     0.01717  0.7757 0.017345       0.115718
#> rb[4,1]     0.29222  0.8002 0.017893       0.127950
#> rb[1,2]     0.22593  0.7858 0.017571       0.156292
#> rb[2,2]     1.00000  0.0000 0.000000       0.000000
#> rb[3,2]     0.05829  0.7840 0.017530       0.101935
#> rb[4,2]     0.44170  0.7330 0.016391       0.130943
#> rb[1,3]     0.01717  0.7757 0.017345       0.115718
#> rb[2,3]     0.05829  0.7840 0.017530       0.101935
#> rb[3,3]     1.00000  0.0000 0.000000       0.000000
#> rb[4,3]     0.02290  0.8307 0.018575       0.133059
#> rb[1,4]     0.29222  0.8002 0.017893       0.127950
#> rb[2,4]     0.44170  0.7330 0.016391       0.130943
#> rb[3,4]     0.02290  0.8307 0.018575       0.133059
#> rb[4,4]     1.00000  0.0000 0.000000       0.000000
#> rw          0.66216  0.1323 0.002959       0.007597
#> sigma[1]    4.75220  0.8512 0.019034       0.057936
#> sigma[2]    1.59031  0.2963 0.006626       0.019621
#> theta[1,1]  0.72654  3.8922 0.087031       0.538105
#> theta[2,1]  1.83686  4.3715 0.097751       0.644376
#> theta[3,1]  1.94268  4.3084 0.096338       0.702637
#> theta[4,1] -1.78852  5.2675 0.117785       0.877870
#> theta[5,1] -0.64273  3.6155 0.080846       0.289114
#> theta[1,2]  0.65958  3.2708 0.073138       0.495903
#> theta[2,2]  2.11861  3.6203 0.080952       0.661736
#> theta[3,2]  3.08562  3.4776 0.077761       0.526591
#> theta[4,2] -2.18029  4.2284 0.094551       0.728787
#> theta[5,2] -1.08565  3.2589 0.072871       0.307527
#> theta[1,3]  0.33606  3.1632 0.070732       0.369791
#> theta[2,3]  0.32790  4.0294 0.090100       0.666275
#> theta[3,3]  0.09928  4.1774 0.093410       0.635518
#> theta[4,3]  0.05255  3.9892 0.089201       0.618611
#> theta[5,3] -0.02010  3.0080 0.067262       0.221791
#> theta[1,4]  1.82378  2.8811 0.064424       0.422991
#> theta[2,4]  3.59056  2.4123 0.053941       0.270361
#> theta[3,4]  2.78030  3.1095 0.069530       0.382314
#> theta[4,4] -4.27105  2.1120 0.047226       0.318312
#> theta[5,4] -1.11360  3.1106 0.069555       0.260698
#> 
#> 2. Quantiles for each variable:
#> 
#>                2.5%      25%      50%     75%    97.5%
#> B[1,1]      -1.5415  0.05135  0.91386  1.8280   3.6397
#> B[2,1]       2.0019  2.59243  2.89842  3.2213   3.9214
#> B[1,2]      -2.0001  0.44919  1.56990  2.7325   4.8423
#> B[2,2]      -0.3539  2.68810  3.73028  5.1107   7.1203
#> Tau[1,1]     0.2332  1.33502  4.43213 18.4176 156.9057
#> Tau[2,1]   -18.0253 -1.01733  0.91464 12.9462  93.3712
#> Tau[3,1]   -37.9255 -2.25411  0.02123  3.1764  76.0784
#> Tau[4,1]   -17.7315 -1.80306  2.82519 12.5787  74.6328
#> Tau[1,2]   -18.0253 -1.01733  0.91464 12.9462  93.3712
#> Tau[2,2]     0.2584  1.55927  6.95182 21.6720  82.5604
#> Tau[3,2]   -38.7413 -2.72436  0.15897  3.9623  44.7293
#> Tau[4,2]   -11.3424 -0.24684  5.52708 16.5269  59.1969
#> Tau[1,3]   -37.9255 -2.25411  0.02123  3.1764  76.0784
#> Tau[2,3]   -38.7413 -2.72436  0.15897  3.9623  44.7293
#> Tau[3,3]     0.1937  1.01107  3.41785 12.8087  92.8145
#> Tau[4,3]   -30.8849 -4.40243  0.11370  5.5743  48.5470
#> Tau[1,4]   -17.7315 -1.80306  2.82519 12.5787  74.6328
#> Tau[2,4]   -11.3424 -0.24684  5.52708 16.5269  59.1969
#> Tau[3,4]   -30.8849 -4.40243  0.11370  5.5743  48.5470
#> Tau[4,4]     2.7408  6.57938 10.89500 18.7193  58.9166
#> gamma1[1]    0.0000  0.00000  0.00000  1.0000   1.0000
#> gamma1[2]    0.0000  0.00000  0.00000  1.0000   1.0000
#> gamma1[3]    0.0000  1.00000  1.00000  1.0000   1.0000
#> gamma1[4]    0.0000  0.00000  0.00000  1.0000   1.0000
#> gamma1[5]    0.0000  0.00000  1.00000  1.0000   1.0000
#> gamma2[1]    0.0000  0.00000  1.00000  1.0000   1.0000
#> gamma2[2]    0.0000  1.00000  1.00000  1.0000   1.0000
#> gamma2[3]    0.0000  0.00000  1.00000  1.0000   1.0000
#> gamma2[4]    0.0000  1.00000  1.00000  1.0000   1.0000
#> gamma2[5]    0.0000  0.00000  0.00000  1.0000   1.0000
#> rb[1,1]      1.0000  1.00000  1.00000  1.0000   1.0000
#> rb[2,1]     -0.9855 -0.67101  0.59315  0.9661   0.9974
#> rb[3,1]     -0.9937 -0.82120  0.01541  0.8612   0.9956
#> rb[4,1]     -0.9847 -0.67361  0.80994  0.9707   0.9960
#> rb[1,2]     -0.9855 -0.67101  0.59315  0.9661   0.9974
#> rb[2,2]      1.0000  1.00000  1.00000  1.0000   1.0000
#> rb[3,2]     -0.9938 -0.83369  0.19870  0.8786   0.9932
#> rb[4,2]     -0.9730 -0.12317  0.89835  0.9785   0.9961
#> rb[1,3]     -0.9937 -0.82120  0.01541  0.8612   0.9956
#> rb[2,3]     -0.9938 -0.83369  0.19870  0.8786   0.9932
#> rb[3,3]      1.0000  1.00000  1.00000  1.0000   1.0000
#> rb[4,3]     -0.9927 -0.89822  0.05291  0.9282   0.9935
#> rb[1,4]     -0.9847 -0.67361  0.80994  0.9707   0.9960
#> rb[2,4]     -0.9730 -0.12317  0.89835  0.9785   0.9961
#> rb[3,4]     -0.9927 -0.89822  0.05291  0.9282   0.9935
#> rb[4,4]      1.0000  1.00000  1.00000  1.0000   1.0000
#> rw           0.3598  0.58631  0.68223  0.7589   0.8586
#> sigma[1]     3.4015  4.13506  4.64420  5.2605   6.7160
#> sigma[2]     1.1342  1.38057  1.54693  1.7525   2.3337
#> theta[1,1]  -6.9711 -0.85654  0.35578  2.0067   9.8183
#> theta[2,1]  -5.2797 -0.80834  0.86037  3.7334  12.7590
#> theta[3,1]  -4.3443 -0.66296  0.71890  3.9256  13.0099
#> theta[4,1] -15.3264 -3.63669 -1.06333  1.1174   6.9970
#> theta[5,1]  -9.3112 -1.80546 -0.24263  0.9551   6.1216
#> theta[1,2]  -5.6017 -1.16594  0.18773  2.6156   7.2078
#> theta[2,2]  -4.5044 -0.31031  1.50965  4.8188   9.2654
#> theta[3,2]  -2.4366  0.22868  2.64048  5.8763  10.0597
#> theta[4,2] -11.5967 -4.39635 -1.68201  0.5314   5.5766
#> theta[5,2]  -7.6345 -2.68504 -0.62185  0.4981   4.6583
#> theta[1,3]  -5.0204 -1.21351 -0.06260  1.4232   8.3203
#> theta[2,3]  -6.8316 -1.56047  0.04242  1.7619   9.2502
#> theta[3,3]  -8.2126 -1.68204 -0.03071  1.6367   9.2082
#> theta[4,3]  -7.3756 -2.02065  0.08200  1.9127   9.7855
#> theta[5,3]  -6.6420 -1.07770 -0.02103  1.0814   5.9548
#> theta[1,4]  -4.5024  0.73903  2.31480  3.4112   6.7536
#> theta[2,4]  -1.5583  2.33753  3.63518  4.9169   8.1879
#> theta[3,4]  -4.3462  1.32301  2.96085  4.6249   8.2933
#> theta[4,4]  -7.9982 -5.46039 -4.19409 -3.2117  -0.2687
#> theta[5,4]  -6.8727 -2.95742 -1.29341  0.5916   5.6777
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
#> theta_308  0.62      0.02  1.06 0.96  21.73 0.05 
#> theta_309 -1.39     -1.83 -0.97 1.00    Inf 0.00 
#> theta_310 -1.14     -1.59 -0.72 1.00    Inf 0.00 
#> theta_330  0.01     -0.31  0.36 0.51   1.04 0.96 
#> theta_331  0.07     -0.19  0.46 0.50   0.99 1.01 
#> theta_332  0.05     -0.24  0.44 0.52   1.09 0.91 
#> theta_333  0.14     -0.11  0.59 0.60   1.47 0.68 
#> theta_334 -0.06     -0.45  0.22 0.52   1.09 0.92 
#> theta_335 -0.83     -1.26 -0.40 1.00 306.69 0.00 
#> theta_337  1.18      0.75  1.61 1.00    Inf 0.00 
#> theta_349 -0.35     -0.81  0.00 0.81   4.28 0.23 
#> theta_350  0.11     -0.15  0.55 0.53   1.14 0.87 
#> theta_351 -0.11     -0.56  0.16 0.54   1.20 0.83 
#> theta_352  0.53      0.00  0.99 0.93  12.94 0.08 
#> theta_369  0.04     -0.25  0.39 0.52   1.06 0.94 
#> theta_370 -0.10     -0.52  0.16 0.55   1.23 0.81 
#> theta_371 -0.06     -0.47  0.21 0.52   1.11 0.90 
#> theta_372  0.17     -0.09  0.64 0.63   1.73 0.58
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
