#'
#'
#'
#'
#'
#'
#'
#'

ranef_alpha_rjags <- "
  model{
  for (i in 1:N) {
    # likelihood
    y[i] ~ dnorm(alpha_j[i], prec)
  }
  for (j in 1:J) {
    # random intercepts
    alpha_raw[j] ~ dnorm(0, 1)
    gamma[j] ~ dbern(0.5)
    theta[j] <- tau * alpha_raw[j] * gamma[j]
    alpha_j[j] <- alpha + theta[j]

    lambda[j] <- (tau^2 / (tau^2 + sigma^2/n_j)) * gamma[j]
  }
  alpha ~ dnorm(0, 1)
  tau ~ dt(0, 1, 3)T(0, )
  prec <- pow(sigma, -2)
  sigma ~ dt(0, 1, 3)T(0, )
}
"


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
"
