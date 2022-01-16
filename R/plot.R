#' caterpillar_plot
#'
#'
#'
#' @import ggplot2 patchwork
#' @export

# d <- lme4::sleepstudy
#
#
# d$y <- c(scale(d$Reaction))
#
# alpha <- ss_ranef_beta(y = d$y, X = d$Days, unit = d$Subject)
#
# obj <- alpha
#


caterpillar_plot <- function(obj, ci = 0.9, col_id = TRUE, ...) {
  ranef_summ <- ranef_summary(obj, ci = ci, as_df = TRUE)

  type <- obj$call[1]
  if (grepl("beta", type)) {
    sorted_ranefs2 <- ranef_summ[grepl("theta2", rownames(ranef_summ)), ]
    sorted_ranefs2 <- sorted_ranefs2[order(sorted_ranefs2$Post.mean), ]

    sorted_ranefs2$id <- gsub("theta2_", "", row.names(sorted_ranefs2))
    sorted_ranefs2$id <- factor(sorted_ranefs2$id, levels = c(sorted_ranefs2$id))

    sorted_ranefs1 <- ranef_summ[grepl("theta1", rownames(ranef_summ)), ]
    sorted_ranefs1 <- sorted_ranefs1[order(sorted_ranefs1$Post.mean), ]

    sorted_ranefs1$id <- gsub("theta1_", "", row.names(sorted_ranefs1))
    # make factor levels same as ranefs2
    sorted_ranefs1$id <- factor(sorted_ranefs1$id, levels = levels(sorted_ranefs2$id))

    colnames(sorted_ranefs1)[2:3] <- c("lb", "ub")
    colnames(sorted_ranefs2)[2:3] <- c("lb", "ub")

    p1 <-
      ggplot(sorted_ranefs1, aes(id, Post.mean)) +
      geom_hline(yintercept = 0, col = "red", linetype = "dashed") +
      geom_errorbar(aes(ymin = lb, ymax = ub), width = 0.1) +
      labs(y = "theta1")


    p2 <-
      ggplot(sorted_ranefs2, aes(id, Post.mean)) +
      geom_hline(yintercept = 0, col = "red", linetype = "dashed") +
      geom_errorbar(aes(ymin = lb, ymax = ub), width = 0.1) +
      labs(y = "theta2")

    if (col_id) {
      p1 <- p1 + geom_point(aes(col = id), size = 2) + guides(col = "none")
      p2 <- p2 + geom_point(aes(col = id), size = 2)
    } else {
      p1 <- p1 + geom_point(size = 2)
      p2 <- p2 + geom_point(size = 2)
    }

    p <- p2/p1 + plot_layout(guides = "collect")

    return(p)

  } else { # begin plot for 'alpha' model
    # sort random effects and created a sorted id
    sorted_ranefs <- ranef_summ[order(ranef_summ$Post.mean), ]
    sorted_ranefs$id <- gsub("theta_", "", row.names(sorted_ranefs))
    sorted_ranefs$id <- factor(sorted_ranefs$id, levels = c(sorted_ranefs$id))

    colnames(sorted_ranefs)[2:3] <- c("lb", "ub")

    p <-
      ggplot(sorted_ranefs, aes(id, Post.mean)) +
      geom_hline(yintercept = 0, col = "red", linetype = "dashed") +
      geom_errorbar(aes(ymin = lb, ymax = ub), width = 0.1) +
      labs(y = "theta")

    if (col_id) {
      p <- p + geom_point(aes(col = id), size = 2)
    } else {
      p <- p + geom_point(size = 2)
    }

    return(p)
  }

}


#' pip_plot
#'
#'
#'
#' @import ggplot2
#' @export

pip_plot <- function(obj, pip_line = 0.5, col_id = TRUE, ...) {
  type <- obj$call[1]
  ranef_summ <- ranef_summary(obj, as_df = TRUE)
  if (grepl("beta", type)) {
    sorted_ranefs <- ranef_summ[grepl("theta2", rownames(ranef_summ)), ]
    sorted_ranefs$id <- gsub("theta2_", "", row.names(sorted_ranefs))
    sorted_ranefs$id <- factor(sorted_ranefs$id, levels = c(sorted_ranefs$id))

    p <-
      ggplot(sorted_ranefs, aes(Post.mean, PIP)) +
      geom_hline(yintercept = pip_line, col = "red", linetype = "dashed") +
      labs(x = "theta2")
    if (col_id) {
      p <- p + geom_point(aes(col = id), size = 2)
    } else {
      p <- p + geom_point(size = 2)
    }
    return(p)


  } else {
    # sort random effects and created a sorted id
    sorted_ranefs <- ranef_summ[order(ranef_summ$Post.mean), ]
    sorted_ranefs$id <- gsub("theta_", "", row.names(sorted_ranefs))
    sorted_ranefs$id <- factor(sorted_ranefs$id, levels = c(sorted_ranefs$id))

    p <-
      ggplot(sorted_ranefs, aes(Post.mean, PIP)) +
      geom_hline(yintercept = pip_line, col = "red", linetype = "dashed") +
      labs(x = "theta")
    if (col_id) {
      p <- p + geom_point(aes(col = id), size = 2)
    } else {
      p <- p + geom_point(size = 2)
    }
    return(p)
  }
}

