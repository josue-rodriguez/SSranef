#' ss_ranef_alpha
#'
#'
#'
#'
#' @importFrom rjags jags.model coda.samples update
# library(dplyr)


ss_ranef_alpha <- function(y, unit, burnin = 1000, iter = 1000, chains = 4, priors = NULL,
                           vars2monitor = c("alpha", "gamma", "lambda", "sigma", "tau", "theta")) {
  args <- match.call()

  if (is.null(priors)) {
    priors_list <- make_default_priors_alpha()
  } else {
      priors_list <- make_custom_priors_alpha(priors)
    }

  model_text <- make_model_text_alpha(priors_list = priors_list)
  og_units <- unique(unit)
  data_list <- list(y = y,
                    N = length(y),
                    unit = as.numeric(as.factor(unit)),
                    J = length(unique(unit)),
                    n_j = as.numeric(table(unit)))

  jags_fit <- jags.model(textConnection(model_text),
                         data = data_list,
                         n.chains = chains)

  if (!is.null(burnin)) update(jags_fit, burnin)

  mcmc_list <- coda.samples(jags_fit,
                            variable.names = vars2monitor,
                            n.iter = iter)

  post_samps <- do.call(rbind, mcmc_list)

  # clean up column names
  cnames <- colnames(post_samps)
  gamma_mask <- grepl("gamma\\[[0-9]+\\]", cnames)
  lambda_mask <- grepl("lambda\\[[0-9]+\\]", cnames)
  theta_mask <- grepl("theta\\[[0-9]+\\]", cnames)

  cnames[gamma_mask] <- paste("gamma", og_units, sep = "_")
  cnames[lambda_mask] <- paste("lambda", og_units, sep = "_")
  cnames[theta_mask] <- paste("theta", og_units, sep = "_")


  colnames(post_samps) <- cnames

  ret <- list(
    posterior_samples = post_samps,
    data_list = data_list,
    call = args
  )
  return(ret)
}



# x <- mlmRev::bdf %>% group_by(schoolNR) %>% slice_sample(n = 3)
# tst <- ss_ranef_int(y = x$IQ.verb, X = NULL, unit = x$schoolNR)
#
# colMeans(tst$posterior_samples)

#' ss_ranef_beta
#'
#'
#'
#'
#' @importFrom rjags jags.model coda.samples update


ss_ranef_beta <- function(y, X, unit, burnin = 1000, iter = 1000, chains = 4, priors = NULL,
                          vars2monitor = c("alpha", "beta", "gamma", "sigma", "tau1", "tau2", "theta1", "theta2")) {
  args <- match.call()

  if (is.null(priors)) {
    priors_list <- make_default_priors_beta()
  } else {
    priors_list <- make_custom_priors_beta(priors)
  }

  model_text <- make_model_text_beta(priors_list = priors_list)
  og_units <- unique(unit)
  X <- cbind(1, X)
  data_list <- list(y = y,
                    X = X,
                    N = length(y),
                    unit = as.numeric(as.factor(unit)),
                    J = length(unique(unit)))

  jags_fit <- jags.model(textConnection(model_text),
                         data = data_list,
                         n.chains = chains)

  if (!is.null(burnin)) update(jags_fit, burnin)

  mcmc_list <- coda.samples(jags_fit,
                            variable.names = vars2monitor,
                            n.iter = iter)

  post_samps <- do.call(rbind, mcmc_list)

  # clean up column names
  cnames <- colnames(post_samps)
  gamma_mask <- grepl("gamma\\[[0-9]+\\]", cnames)
  theta1_mask <- grepl("theta1\\[[0-9]+\\]", cnames)
  theta2_mask <- grepl("theta2\\[[0-9]+\\]", cnames)

  cnames[gamma_mask] <- paste("gamma", og_units, sep = "_")
  cnames[theta1_mask] <- paste("theta1", og_units, sep = "_")
  cnames[theta2_mask] <- paste("theta2", og_units, sep = "_")


  colnames(post_samps) <- cnames

  ret <- list(
    posterior_samples = post_samps,
    data_list = data_list,
    call = args
  )
  return(ret)
}

