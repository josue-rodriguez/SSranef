#' ss_ranef_alpha
#'
#' @param y ...
#' @param unit ...
#' @param burnin ...
#' @param iter ...
#' @param chains ...
#' @param priors ...
#' @param vars2monitor ...
#'
#'
#' @importFrom rjags jags.model coda.samples
#' @importFrom stats update
#' @export


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

  post_samps <- do.call(rbind.data.frame, mcmc_list)
  post_samps$chain <- rep(1:chains, each = iter)

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
    model_text = model_text,
    call = args
  )

  class(ret) <- c("ss_ranef", "list")
  return(ret)
}




#' ss_ranef_beta
#'
#' @param y ...
#' @param X ...
#' @param unit ...
#' @param burnin ...
#' @param iter ...
#' @param chains ...
#' @param priors ...
#' @param vars2monitor ...
#'
#' @importFrom rjags jags.model coda.samples
#' @importFrom stats update
#' @export


ss_ranef_beta <- function(y, X, unit, burnin = 1000, iter = 1000, chains = 4, priors = NULL,
                          vars2monitor = c("alpha", "beta", "gamma", "sigma", "tau1", "tau2", "rho", "theta1", "theta2")) {
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

  post_samps <- do.call(rbind.data.frame, mcmc_list)
  post_samps$chain <- rep(1:chains, each = iter)

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
    model_text = model_text,
    call = args
  )
  class(ret) <- c("ss_ranef", "list")
  return(ret)
}



#' ss_ranef_mv
#'
#' @param y ...
#' @param X ...
#' @param unit ...
#' @param burnin ...
#' @param iter ...
#' @param chains ...
#' @param priors ...
#' @param vars2monitor ...
#'
#' @importFrom rjags jags.model coda.samples
#' @importFrom stats update
#' @export


ss_ranef_mv <- function(Y, X, unit, burnin = 1000, iter = 1000, chains = 4, priors = NULL,
                          vars2monitor =c("B", "theta", "gamma1", "gamma2", "sigma", "Tau", "rb", "rw")) {
  args <- match.call()

  if (is.null(priors)) {
    priors_list <- make_default_priors_mv()
  } else {
    priors_list <- make_custom_priors_mv(priors)
  }

  model_text <- make_model_text_mv(priors_list = priors_list)
  og_units <- unique(unit)
  X <- cbind(1, X)
  K <- 4
  data_list <- list(Y = Y,
                    X = X,
                    N = nrow(Y),
                    unit = as.numeric(as.factor(unit)),
                    J = length(unique(unit)),
                    O = diag(K),
                    K = K)

  jags_fit <- jags.model(textConnection(model_text),
                         data = data_list,
                         n.chains = chains)

  if (!is.null(burnin)) update(jags_fit, burnin)

  mcmc_list <- coda.samples(jags_fit,
                            variable.names = vars2monitor,
                            n.iter = iter)

  # post_samps <- do.call(rbind.data.frame, mcmc_list)
  # post_samps$chain <- rep(1:chains, each = iter)

  # clean up column names
  # cnames <- colnames(post_samps)
  # gamma_mask <- grepl("gamma\\[[0-9]+\\]", cnames)
  # theta1_mask <- grepl("theta1\\[[0-9]+\\]", cnames)
  # theta2_mask <- grepl("theta2\\[[0-9]+\\]", cnames)
  #
  # cnames[gamma_mask] <- paste("gamma", og_units, sep = "_")
  # cnames[theta1_mask] <- paste("theta1", og_units, sep = "_")
  # cnames[theta2_mask] <- paste("theta2", og_units, sep = "_")


  # colnames(post_samps) <- cnames
  ret <- list(
    posterior_samples = mcmc_list,
    data_list = data_list,
    model_text = model_text,
    call = args
  )
  class(ret) <- c("ss_ranef", "list")
  return(ret)
}




# jcov2cor <- function(x) {
#   x %>%
#     select(matches("Tau\\[")) %>%
#     colMeans() -> x
#   m <- diag(4)
#   diag(m) <- c(x["Tau[1,1]"], x["Tau[2,2]"], x["Tau[3,3]"],x["Tau[4,4]"])
#   m[lower.tri(m)] <- c(
#     x["Tau[1,2]"],
#     x["Tau[1,3]"],
#     x["Tau[1,4]"],
#     x["Tau[2,3]"],
#     x["Tau[2,4]"],
#     x["Tau[3,4]"]
#   )
#
#   m[upper.tri(m)] <- t(m)[upper.tri(m)]
#
#   return(m)
# }
#
# diag(sqrt(jcov2cor(post_df)))
# post_df %>%
#   select(matches("rho\\[")) %>%
#   colMeans()
