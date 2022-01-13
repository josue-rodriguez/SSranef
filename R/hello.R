#'
#'
#'
#'
#'
#'
#' @importFrom lme4
library(dplyr)
x <- lme4::sleepstudy %>% janitor::clean_names()

ss_ranef_int <- function(y, X, unit, priors = NULL) {
  args <- match.call()

  return(args)
}




o <- ss_ranef_int(y = x$reaction, X = NULL, unit = "group", priors = NULL)
