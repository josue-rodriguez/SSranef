#'
#'
#'
#'
#'
#'
#'
#'

priors_list <- make_default_priors_alpha()

make_default_priors_alpha <- function() {
  priors_list <- list(
    gamma = "gamma[j] ~ dbern(0.5)",
    alpha = "alpha ~ dnorm(0, 1)",
    tau = "tau ~ dt(0, 1, 3)T(0, )",
    sigma = "sigma ~ dt(0, 1, 3)T(0, )"
  )
  return(priors_list)
}

make_custom_priors_alpha <- function(custom_priors) {
  custom_priors_names <- names(custom_priors)
  priors_list <- make_default_priors_alpha()

  priors_list[custom_priors_names] <- custom_priors

  return(custom_priors)
}

alpha_model_text1 <-
  "model{
  for (i in 1:N) {
    # likelihood
    y[i] ~ dnorm(alpha_j[unit[i]], precision)
  }
  for (j in 1:J) {"

alpha_model_text2 <-
   "
    # non-centered parameterization
    alpha_raw[j] ~ dnorm(0, 1)
    theta[j] <- tau * alpha_raw[j] * gamma[j]
    alpha_j[j] <- alpha + theta[j]
    lambda[j] <- (tau^2 / (tau^2 + sigma^2/n_j[j])) * gamma[j]
  }
"


make_model_text_alpha <- function(priors_list) {
  model_text <- paste0(
    alpha_model_text1, "\n    ",
    priors_list$gamma,
    alpha_model_text2, "  ",
    priors_list$alpha, "\n  ",
    priors_list$tau, "\n  ",
    "precision <- pow(sigma, -2)", "\n  ",
    priors_list$sigma, "\n",
    "}"

  )
  return(model_text)
}



#'
#'
#'
#'
#'
#'
#'
#'
#'

make_default_priors_beta <- function() {
  priors_list <- list(
    gamma = "gamma[j] ~ dbern(0.5)",
    alpha = "alpha ~ dnorm(0, 1)",
    beta = "beta ~ dnorm(0, 1)",
    tau1 = "tau1 ~ dt(0, 1, 3)T(0, )",
    tau2 = "tau2 ~ dt(0, 1, 3)T(0, )",
    sigma = "sigma ~ dt(0, 1, 3)T(0, )",
    rho = "rho ~ dunif(-1, 1)"
  )
  return(priors_list)
}




beta_model_text1 <-
  "model {
    for (i in 1:N) {
      # likelihood
      y[i] ~ dnorm(mu[i], precision)
      mu[i] <- inprod(X[i, ], B[unit[i],  ])
    }
    for (j in 1:J) {
      # prior for inclusion variable"

beta_model_text2 <-
  "
      # random intercept
      z1[j] ~ dnorm(0, 1)
      theta1[j] <- tau1 * z1[j]

      # random slope
      z2[j] ~ dnorm(0, 1)
      theta2raw[j] <- rho * z1[j] + sqrt(1 - rho^2) * z2[j]
      theta2star[j] <- theta2raw[j] * gamma[j]
      theta2[j] <- tau2 * theta2star[j]
      B[j, 1] <- alpha + theta1[j]
      B[j, 2] <- beta + theta2[j]
    }
  # priors"

make_model_text_beta <- function(priors_list) {
  model_text <- paste0(
    beta_model_text1, "\n      ",
    priors_list$gamma,
    beta_model_text2, "\n  ",
    priors_list$alpha, "\n  ",
    priors_list$beta, "\n  ",
    priors_list$tau1, "\n  ",
    priors_list$tau2, "\n  ",
    "precision <- pow(sigma, -2)", "\n  ",
    priors_list$sigma, "\n  ",
    priors_list$rho, "\n",
    "}"

  )
  return(model_text)
}


make_model_text_beta(make_default_priors_beta()) %>% cat()
