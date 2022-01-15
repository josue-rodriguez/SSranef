
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
posterior_summary(alpha)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_alpha(y = d$y, unit = d$Subject)
#> 
#>       Post.mean q05         q95      
#> alpha 0.0788911 -0.08612121 0.2463557
#> sigma 0.7895496  0.72167440 0.8664707
#> tau   0.9413794  0.59382607 1.4417262
ranef_summary(alpha)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_alpha(y = d$y, unit = d$Subject)
#> 
#>           Post.mean    q05         q95         PIP    
#> theta_308  0.574276220  0.00000000  1.05502707 0.88050
#> theta_309 -1.441459847 -1.87497645 -0.99849007 1.00000
#> theta_310 -1.175777635 -1.61517557 -0.73040593 1.00000
#> theta_330  0.004822279 -0.16674159  0.19351432 0.22025
#> theta_331  0.032550268 -0.09406383  0.34026573 0.25650
#> theta_332  0.021915701 -0.14190517  0.31529489 0.25225
#> theta_333  0.074401687 -0.00110221  0.49607285 0.30000
#> theta_334 -0.037283782 -0.35336232  0.06726522 0.25525
#> theta_335 -0.853544052 -1.29319677 -0.40127921 0.98625
#> theta_337  1.193022625  0.76955000  1.61521043 0.99975
#> theta_349 -0.277781913 -0.82501706  0.00000000 0.59250
#> theta_350  0.061171497 -0.02926822  0.45620359 0.28775
#> theta_351 -0.068822629 -0.49573967  0.02212839 0.29650
#> theta_352  0.448745459  0.00000000  0.96307573 0.78075
#> theta_369  0.010601192 -0.16725696  0.23661416 0.24450
#> theta_370 -0.054851811 -0.43254456  0.04720934 0.28350
#> theta_371 -0.036363610 -0.35419484  0.09368421 0.26100
#> theta_372  0.096121664  0.00000000  0.54989442 0.34675
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
posterior_summary(beta)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_beta(y = d$y, X = d$Days, unit = d$Subject)
#> 
#>       Post.mean  q05        q95       
#> alpha -0.8287323 -1.0287798 -0.6388382
#> beta   0.1881523  0.1533036  0.2236155
#> sigma  0.4666865  0.4217604  0.5157585
#> tau1   0.4355402  0.2426381  0.6522465
#> tau2   0.1661629  0.1013597  0.2629444
#> rho    0.2010057 -0.3914870  0.7838894
ranef_summary(beta)
#> Linear mixed model fit with SSranef
#> Call: ss_ranef_beta(y = d$y, X = d$Days, unit = d$Subject)
#> 
#>            Post.mean    q05         q95         PIP    
#> theta1_308  0.014849922 -0.40815343  0.39434713      NA
#> theta1_309 -0.634857280 -1.07051555 -0.23648323      NA
#> theta1_310 -0.665377580 -1.19057034 -0.20683093      NA
#> theta1_330  0.295630818 -0.11617126  0.79801639      NA
#> theta1_331  0.242372516 -0.09832864  0.67528596      NA
#> theta1_332  0.126206052 -0.18515192  0.45419504      NA
#> theta1_333  0.261892209 -0.05908437  0.60141697      NA
#> theta1_334 -0.073872154 -0.39719410  0.23565055      NA
#> theta1_335  0.007019761 -0.36445316  0.43901139      NA
#> theta1_337  0.531937001  0.14186854  0.96805692      NA
#> theta1_349 -0.382880557 -0.74279315 -0.05219937      NA
#> theta1_350 -0.186763018 -0.61667239  0.22268269      NA
#> theta1_351 -0.025839577 -0.38144880  0.36885685      NA
#> theta1_352  0.427774575  0.01169348  0.83993013      NA
#> theta1_369  0.084999828 -0.23204670  0.39375398      NA
#> theta1_370 -0.345405237 -0.82985223  0.05436807      NA
#> theta1_371 -0.047519276 -0.36295455  0.28295331      NA
#> theta1_372  0.246584001 -0.07529952  0.59236178      NA
#> theta2_308  0.167958537  0.08929512  0.25360718 0.99325
#> theta2_309 -0.174126091 -0.25848420 -0.08824907 0.98975
#> theta2_310 -0.102764710 -0.19749646  0.00000000 0.84400
#> theta2_330 -0.060751897 -0.16534197  0.00000000 0.65375
#> theta2_331 -0.023853062 -0.11887345  0.00000000 0.38825
#> theta2_332 -0.001696765 -0.03958042  0.02452077 0.21800
#> theta2_333 -0.001267518 -0.04959643  0.03928124 0.27575
#> theta2_334  0.003302837 -0.01888986  0.04961019 0.23350
#> theta2_335 -0.201042351 -0.28454079 -0.12180853 1.00000
#> theta2_337  0.167144301  0.08434213  0.24737602 0.98650
#> theta2_349  0.004893420 -0.02763669  0.06492745 0.25500
#> theta2_350  0.106097844  0.00000000  0.19773443 0.90375
#> theta2_351 -0.029622352 -0.12236047  0.00000000 0.45225
#> theta2_352  0.040648867  0.00000000  0.13797127 0.52575
#> theta2_369  0.004048168 -0.01503751  0.04848919 0.23300
#> theta2_370  0.055444903  0.00000000  0.16277976 0.62725
#> theta2_371 -0.005702181 -0.06074765  0.01712051 0.25900
#> theta2_372  0.008927862 -0.01348368  0.07437367 0.29425
```
