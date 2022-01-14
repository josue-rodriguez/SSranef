
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

d <- lme4::sleepstudy

ss_ranef_beta(y = d$Reaction, X = d$Days, unit = d$Subject)
```
