# library(rjags)
# library(dplyr)
#
# # set.seed(42)
# # N <- 100
# # x <- runif(N, -1, 1)
# #
# # r <- 0.4
# # Omega <- rbind( # correlation matrix
# #   c(1, r),
# #   c(r, 1)
# # )
# # sigma <- c(2, 4) # residual SDs
# # Sigma <- diag(sigma) %*% Omega %*% diag(sigma) # covariance matrix
# # Sigma
# #
# # errors <- mvtnorm::rmvnorm(N, c(0,0), Sigma)
# #
# # cor(errors) # realized correlation
# #
# # y1 <- -0.5 + x * 1.1 + errors[,1]
# # y2 <- 0.8 + x * 0.4 + errors[,2]
# #
# # par(mfrow = c(1, 2))
# # plot(y1, y2, main = "Y's")
# # points(errors, col = "red", main = "Residuals")
# # par(mfrow = c(1, 1))
# # fit <- lm(cbind(y1, y2) ~ x)
# # summary(fit)
# #
# #
# # cor(resid(fit))
# # beta[1,1] is the first intercept
# # beta[1,2] is the first slope
# # beta[2,1] is the second intercept
# # beta[2,2] is the second slope
# # Omega are the elements of the correlation matrix
# # Sigma are the elements of the covariance matrix
#
#
#
# # model_code <- "
# # model{
# #   for (i in 1:N) {
# #     Y[i, 1:2] ~ dmnorm(M[i, 1:2], P[1:2, 1:2])
# #
# #     M[i, 1] <- B[1, 1] + B[2, 1] * x[i]
# #     M[i, 2] <- B[1, 2] + B[2, 2] * x[i]
# #   }
# #
# #   B[1, 1] ~ dnorm(0, 0.1)
# #   B[1, 2] ~ dnorm(0, 0.1)
# #   B[2, 1] ~ dnorm(0, 0.1)
# #   B[2, 2] ~ dnorm(0, 0.1)
# #
# #   P <- inverse(Sigma)
# #   sigma <- sqrt(Sigma)
# #   Sigma <- Tau %*% R %*% Tau
# #
# #   rho ~ dunif(-1, 1)
# #   R[1, 1] <- 1
# #   R[2, 2] <- 1
# #   R[1, 2] <- rho
# #   R[2, 1] <- rho
# #
# #   Tau[1, 2] <- 0
# #   Tau[2, 1] <- 0
# #   Tau[1, 1] ~ dt(0, 1, 3)T(0, )
# #   Tau[2, 2] ~ dt(0, 1, 3)T(0, )
# # }
# # "
# #
# # data_list <- list(
# #   Y = cbind(y1, y2),
# #   x = x,
# #   N = length(y1)
# # )
# #
# #
# # mod <- jags.model(file = textConnection(model_code),
# #                   data = data_list)
# # post_samps <- coda.samples(mod,
# #                            variable.names = c("B", "sigma", "rho"),
# #                            n.iter = 4000)
# # df <- do.call(rbind, post_samps)
# #
# # colMeans(df)
# # summary(fit)
#
#
# #===========================
# #===========================
# #===========================
# #===========================
# #===========================
# library(lme4)
# library(Matrix)
# # library(brms)
# # library(cmdstanr)
#
# # ---- GENERATE DATA ----
# n <- 100
# n_j <- 50
# N <- n * n_j
#
# # design matrix + betas
# X <- cbind(1, sample(0:1, size = N, replace = TRUE))
# B1 <- rbind(1, 1)
# B2 <- rbind(1, 1)
#
# # random effect SDs
# tau <- diag(c(3, 2, 2, 2))
#
# # 4 x 4 cor matrix for random effects
# Rb <- rbind(
#   c(1, 0.1, 0.2, 0.3),
#   c(0.1, 1, 0.1, 0.1),
#   c(0.2, 0.1, 1, 0.1),
#   c(0.3, 0.1, 0.1, 1)
# )
#
# # vcov matrix for random effects
# Tau <- tau %*% Rb %*% tau
#
# # generate random effects and stack them for each regression
# u_mat <- mvtnorm::rmvnorm(n, rep(0, 4), Tau)
#
# # -- random effects for y1
# u_list1 <- lapply(1:n, function(i) cbind(u_mat[i, 1:2]))
# u1 <- do.call(rbind, u_list1)
# # -- random effects for y2
# u_list2 <- lapply(1:n, function(i) cbind(u_mat[i, 3:4]))
# u2 <- do.call(rbind, u_list2)
#
# # generate factor levels + Z matrix
# # -- taken from lme4 documentation
# g <- gl(n, n_j)
# Ji <- t(as(g, Class = "sparseMatrix"))
# Z <- t(KhatriRao(t(Ji), t(X)))
#
# # cor matrix for residuals
# Rw <- rbind(
#   c(1, 0.3),
#   c(0.3, 1)
# )
#
# # residual SDs
# sigma <- c(2, 0.5)
#
# # vcov matrix for residuals
# Sigma <- diag(sigma) %*% Rw %*% diag(sigma)
# eps <- mvtnorm::rmvnorm(N, c(0,0), Sigma)
#
# # generate data
# y <- X %*% cbind(B1, B2) + Z %*% cbind(u1, u2) + eps
#
# df <- data.frame(y1 = y[, 1], y2 = y[, 2], x = X[, 2], id = g)
#
# # mvbind for multivariate component
# # set_rescore for estimating cor of residuals
#
# # mv_fit <- brm(
# #   bf(mvbind(y1, y2) ~ x + (x|c|id)) + set_rescor(TRUE),
# #   data = df,
# #   iter = 4000,
# #   cores = 2,
# #   chains = 2,
# #   backend = "cmdstanr",
# #   file = "data-raw/mv_fit.rds"
# # )
#
# # update(mv_fit, newdata = df,
# #        cores = 2,
# #        chains = 2,
# #        iter = 4000,
# #        backend = "cmdstanr",
# #        file = "mv_fit2.rds")
#
#
#
# # summary(mv_fit)
# #
# # vcov(mv_fit, correlation = TRUE)
