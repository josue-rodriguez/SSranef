library(lme4)
library(Matrix)
library(dplyr)

# ---- GENERATE DATA ----
n <- 100
n_j <- 50
N <- n * n_j

# design matrix + betas
X <- cbind(1, sample(0:1, size = N, replace = TRUE))
B1 <- rbind(1, 2)
B2 <- rbind(3, 4)

# random effect SDs
tau <- diag(c(3, 2, 2, 2))

# 4 x 4 cor matrix for random effects
Rb <- rbind(
  c(1, 0.1, 0.2, 0.3),
  c(0.1, 1, 0.1, 0.1),
  c(0.2, 0.1, 1, 0.1),
  c(0.3, 0.1, 0.1, 1)
)

# vcov matrix for random effects
Tau <- tau %*% Rb %*% tau

# generate random effects and stack them for each regression
u_mat <- mvtnorm::rmvnorm(n, rep(0, 4), Tau)

# -- random effects for y1
u_list1 <- lapply(1:n, function(i) cbind(u_mat[i, 1:2]))
u1 <- do.call(rbind, u_list1)
# -- random effects for y2
u_list2 <- lapply(1:n, function(i) cbind(u_mat[i, 3:4]))
u2 <- do.call(rbind, u_list2)

# generate factor levels + Z matrix
# -- taken from lme4 documentation
g <- gl(n, n_j)
Ji <- t(as(g, Class = "sparseMatrix"))
Z <- t(KhatriRao(t(Ji), t(X)))

# cor matrix for residuals
Rw <- rbind(
  c(1, 0.3),
  c(0.3, 1)
)

# residual SDs
sigma <- c(2, 0.5)

# vcov matrix for residuals
Sigma <- diag(sigma) %*% Rw %*% diag(sigma)
eps <- mvtnorm::rmvnorm(N, c(0,0), Sigma)

# generate data
y <- X %*% cbind(B1, B2) + Z %*% cbind(u1, u2) + eps

df <- data.frame(y1 = y[, 1], y2 = y[, 2], x = X[, 2], id = g)


mv_model_text <- "
model{
  for (i in 1:N) {
    Y[i, 1:2] ~ dmnorm(M[i, 1:2], Pw[1:2, 1:2])
    M[i, 1] <- inprod(X[i, 1:2], Bj[id[i], 1, 1:2])
    M[i, 2] <- inprod(X[i, 1:2], Bj[id[i], 2, 1:2])
  }
  for (j in 1:J) {
    u[j, 1:4] ~ dmnorm(c(0, 0, 0, 0), Tau[1:4, 1:4])

    Bj[j, 1, 1:2] <- B[1, 1:2] + u[j, 1:2]
    Bj[j, 2, 1:2] <- B[2, 1:2] + u[j, 3:4]
  }

  # ==== Fixed effects ====
  B[1, 1] ~ dnorm(0, 0.1)
  B[1, 2] ~ dnorm(0, 0.1)
  B[2, 1] ~ dnorm(0, 0.1)
  B[2, 2] ~ dnorm(0, 0.1)

  # ==== Covariance matrix for residuals ====

  # Precision matrix for within-unit errors
  Pw <- inverse(Sigma)

  # standard deviations for residuals
  sigma[1:2] <- c(sqrt(Sigma[1, 1]),
                  sqrt(Sigma[2, 2]))

  # Covariance matrix for residuals
  Sigma <- s %*% Rw %*% s

  # within-unit correlation
  Rw[1, 1] <- 1
  Rw[2, 2] <- 1
  Rw[1, 2] <- rw
  Rw[2, 1] <- rw
  rw ~ dunif(-1, 1)

  s[1, 2] <- 0
  s[2, 1] <- 0
  # priors for SDs
  s[1, 1] ~ dt(0, 1, 3)T(0, )
  s[2, 2] ~ dt(0, 1, 3)T(0, )

  # ==== Covariance matrix for random effects ====
  # Precision matrix for between-units errors
  Pb <- inverse(Sigma)

  # standard deviations for random effects
  tau[1:4] <- c(sqrt(t[1, 1]),
                sqrt(t[2, 2]),
                sqrt(t[3, 3]),
                sqrt(t[4, 4]))

  # Covariance matrix for random effects
  Tau <- t %*% Rb %*% t

  # between-unit correlations
  Rb[1, 1] <- 1
  Rb[2, 2] <- 1
  Rb[3, 3] <- 1
  Rb[4, 4] <- 1

  Rb[1, 2] <- rb12
  Rb[1, 3] <- rb13
  Rb[1, 4] <- rb14
  Rb[2, 1] <- rb12
  Rb[3, 1] <- rb13
  Rb[4, 1] <- rb14

  Rb[2, 3] <- rb23
  Rb[2, 4] <- rb24
  Rb[3, 2] <- rb23
  Rb[4, 2] <- rb24

  Rb[3, 4] <- rb34
  Rb[4, 3] <- rb34

  rb12 ~ dunif(-1, 1)
  rb13 ~ dunif(-1, 1)
  rb14 ~ dunif(-1, 1)
  rb23 ~ dunif(-1, 1)
  rb24 ~ dunif(-1, 1)
  rb34 ~ dunif(-1, 1)

  # priors for SDs
  t[1, 1] ~ dt(0, 1, 3)T(0, )
  t[2, 2] ~ dt(0, 1, 3)T(0, )
  t[3, 3] ~ dt(0, 1, 3)T(0, )
  t[4, 4] ~ dt(0, 1, 3)T(0, )

  t[1, 2] <- 0
  t[1, 3] <- 0
  t[1, 4] <- 0
  t[2, 1] <- 0
  t[3, 1] <- 0
  t[4, 1] <- 0

  t[2, 3] <- 0
  t[2, 4] <- 0
  t[3, 2] <- 0
  t[4, 2] <- 0

  t[3, 4] <- 0
  t[4, 3] <- 0
}
"
data_list <- list(
  Y = cbind(df$y1, df$y2),
  X = cbind(1, df$x),
  N = nrow(df),
  J = length(unique(df$id)),
  id = df$id
)


mod <- jags.model(file = textConnection(mv_model_text),
                  data = data_list,
                  n.chains = 4)
vars2monitor <- c("B", "u",
                  "sigma", "tau",
                  "rw", "rb12", "rb13", "rb14", "rb23", "rb24", "rb34")
post_samps <- coda.samples(mod,
                           variable.names = vars2monitor,
                           n.iter = 4000)


post_df <- do.call(rbind.data.frame, post_samps)

post_df %>%
  select(-matches("^u")) %>%
  colMeans()

