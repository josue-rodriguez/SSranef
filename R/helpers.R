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

ranef_alpha_text1 <-
  "model{
  for (i in 1:N) {
    # likelihood
    y[i] ~ dnorm(alpha_j[unit[i]], prec)
  }
  for (j in 1:J) {"

ranef_alpha_text2 <-
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
    ranef_alpha_text1, "\n    ",
    priors_list$gamma,
    ranef_alpha_text2, "  ",
    priors_list$alpha, "\n  ",
    priors_list$tau, "\n  ",
    "prec <- pow(sigma, -2)", "\n  ",
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
ranef_beta_rjags <- "
  model {
    for (i in 1:N) {
      y[i] ~ dnorm(mu[i], precision)
      mu[i] <- inprod(X[i, ], B[id[i],  ])
    }
    for (j in 1:J) {
      # random intercept
      z1[j] ~ dnorm(0, 1)
      theta1[j] <- sd_alpha * z1[j]

     # random slope
      z2[j] ~ dnorm(0, 1)
      theta2raw[j] <- cor * z1[j] + sqrt(1 - cor^2) * z2[j]

      gamma[j] ~ dbern(0.5)
      # pi[j] ~ dbeta(1, 1)
      theta2star[j] <- theta2raw[j] * gamma[j]

      theta2[j] <- sd_beta * theta2star[j]

      B[j, 1] <- alpha + theta1[j]
      B[j, 2] <- beta + theta2[j]
    }


  alpha ~ dnorm(0, 0.01)
  beta ~ dnorm(0, 0.01)

  precision <- pow(sigma, -2)
  sigma ~ dt(0, 1, 3)T(0, )

  sd_alpha ~ dt(0, 1, 3)T(0, )
  sd_beta ~ dt(0, 1, 3)T(0, )
  cor ~ dunif(-0.8, 0.8)
  }
"
