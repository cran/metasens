#' Print method for objects of class orbbound
#' 
#' Print method for objects of class \code{orbbound}.
#' 
#' For summary measures 'RR', 'OR', and 'HR' column labeled maxbias
#' contains the relative bias, e.g. a value of 1.10 means a maximum
#' overestimation by 10 percent. If \code{logscale=TRUE} for these
#' summary measures, maximum bias is instead printed as absolute bias.
#' 
#' @param x An object of class \code{orbbound}.
#' @param common A logical indicating whether sensitivity analysis for
#'   common effect model should be printed.
#' @param random A logical indicating whether sensitivity analysis for
#'   random effects model should be printed.
#' @param header A logical indicating whether information on
#'   meta-analysis should be printed at top of printout.
#' @param backtransf A logical indicating whether printed results
#'   should be back transformed. If \code{backtransf=TRUE}, results
#'   for \code{sm="OR"} are printed as odds ratios rather than log
#'   odds ratios and results for \code{sm="ZCOR"} are printed as
#'   correlations rather than Fisher's z transformed correlations, for
#'   example.
#' @param digits Minimal number of significant digits, see
#'   \code{print.default}.
#' @param digits.stat Minimal number of significant digits for z- or
#'   t-value, see \code{print.default}.
#' @param digits.pval Minimal number of significant digits for p-value
#'   of overall treatment effect, see \code{print.default}.
#' @param digits.tau2 Minimal number of significant digits for
#'   between-study variance, see \code{print.default}.
#' @param scientific.pval A logical specifying whether p-values should
#'   be printed in scientific notation, e.g., 1.2345e-01 instead of
#'   0.12345.
#' @param big.mark A character used as thousands separator.
#' @param warn.deprecated A logical indicating whether warnings should
#'   be printed if deprecated arguments are used.
#' @param \dots Additional arguments to catch deprecated arguments.
#' 
#' @author Guido Schwarzer \email{guido.schwarzer@@uniklinik-freiburg.de}
#' 
#' @seealso \code{\link{orbbound}}, \code{\link{forest.orbbound}}
#' 
#' @keywords print
#' 
#' @examples
#' data(Fleiss1993bin, package = "meta")
#' 
#' m1 <- metabin(d.asp, n.asp, d.plac, n.plac,
#'   data = Fleiss1993bin, sm = "OR")
#' 
#' orb1 <- orbbound(m1, k.suspect = 1:5)
#' print(orb1, digits = 2)
#' 
#' # Print log odds ratios instead of odds ratios
#' #
#' print(orb1, digits = 2, backtransf = FALSE)
#' 
#' # Assuming that studies are missing on the left side
#' #
#' orb1.missleft <- orbbound(m1, k.suspect = 1:5, left = TRUE)
#' orb1.missleft
#' 
#' m2 <- metabin(d.asp, n.asp, d.plac, n.plac,
#'   data = Fleiss1993bin, sm = "OR", method = "Inverse")
#' 
#' orb2 <- orbbound(m2, k.suspect = 1:5)
#' print(orb2, digits = 2)
#'
#' @method print orbbound
#' @export
#' @export print.orbbound


print.orbbound <- function(x,
                           common = x$x$common,
                           random = x$x$random,
                           header = TRUE, backtransf = x$backtransf,
                           digits = gs("digits"),
                           digits.stat = gs("digits.stat"),
                           digits.pval = max(gs("digits.pval"), 2),
                           digits.tau2 = gs("digits.tau2"),
                           scientific.pval = gs("scientific.pval"),
                           big.mark = gs("big.mark"),
                           warn.deprecated = gs("warn.deprecated"),
                           ...) {
  
  
  chkclass(x, "orbbound")
  x <- updateversion(x)
  
  
  k <- x$x$k
  k.suspect <- x$k.suspect
  sm <- x$x$sm
  
  
  cl <- class(x)[1]
  args <- list(...)
  addargs <- names(args)
  ##
  fun <- "print.orbbound"
  ##
  chklogical(warn.deprecated)
  if (warn.deprecated)
    warnarg("logscale", addargs, fun, otherarg = "backtransf")
  ##
  if (is.null(backtransf))
    if (!is.null(args[["logscale"]]))
      backtransf <- !args[["logscale"]]
    else
      backtransf <- TRUE
  ##
  common <- deprecated(common, missing(common), args, "fixed",
                       warn.deprecated)
  chklogical(common)
  chklogical(random)
  chklogical(header)
  chklogical(backtransf)
  ##
  chknumeric(digits, min = 0, length = 1)
  chknumeric(digits.stat, min = 0, length = 1)
  chknumeric(digits.pval, min = 1, length = 1)
  chknumeric(digits.tau2, min = 0, length = 1)
  ##
  chklogical(scientific.pval)
  
  
  sm.lab <- sm
  ##
  if (backtransf) {
    if (sm == "ZCOR")
      sm.lab <- "COR"
    if (sm %in% c("PFT", "PAS", "PRAW", "PLOGIT", "PLN"))
      sm.lab <- "proportion"
  }
  else 
    if (is.relative.effect(sm))
      sm.lab <- paste("log", sm, sep = "")
  
  
  ci.lab <- paste(round(100 * x$x$level.ma, 1), "%-CI", sep = "")
  
  
  TE.common    <- x$common$TE
  lowTE.common <- x$common$lower
  uppTE.common <- x$common$upper
  ##
  TE.random    <- x$random$TE
  lowTE.random <- x$random$lower
  uppTE.random <- x$random$upper
  ##
  maxbias <- x$maxbias
  
  
  if (backtransf) {
    ##
    npft.ma <- 1 / mean(1 / x$x$n)
    ##
    TE.common    <- backtransf(TE.common, sm, "mean",
                               npft.ma, warn = common)
    lowTE.common <- backtransf(lowTE.common, sm, "lower",
                               npft.ma, warn = common)
    uppTE.common <- backtransf(uppTE.common, sm, "upper",
                               npft.ma, warn = common)
    ##
    TE.random <- backtransf(TE.random, sm, "mean",
                            npft.ma, warn = random)
    lowTE.random <- backtransf(lowTE.random, sm, "lower",
                               npft.ma, warn = random)
    uppTE.random <- backtransf(uppTE.random, sm, "upper",
                               npft.ma, warn = random)
    ##
    maxbias <- backtransf(maxbias, sm, "mean", npft.ma, warn = FALSE)
  }
  ##
  TE.common    <- round(TE.common, digits)
  lowTE.common <- round(lowTE.common, digits)
  uppTE.common <- round(uppTE.common, digits)
  pTE.common <- x$common$p
  sTE.common <- round(x$common$statistic, digits)
  ##
  TE.random    <- round(TE.random, digits)
  lowTE.random <- round(lowTE.random, digits)
  uppTE.random <- round(uppTE.random, digits)
  pTE.random <- x$random$p
  sTE.random <- round(x$random$statistic, digits)
  ##
  maxbias <- round(maxbias, digits)
  
  
  if (header)
    crtitle(x$x)
  
  
  if (common | random) {
    tau2 <- formatPT(x$tau^2,
                     lab = TRUE, labval = "tau^2",
                     digits = digits.tau2,
                     lab.NA = "NA",
                     big.mark = big.mark)
    
    cat("\n        Sensitivity Analysis for Outcome Reporting Bias (ORB)\n\n")
    
    cat(paste("Number of studies combined: k=", x$x$k, "\n", sep = ""))
    cat(paste("Between-study variance: ", tau2, "\n\n", sep = ""))
  }
  
  if (common) {
    if (random & x$tau == 0)
      cat("Common effect model / Random effects model\n\n")
    else
      cat("Common effect model\n\n")
    
    res <- cbind(k.suspect,
                 formatN(maxbias, digits, big.mark = big.mark),
                 formatN(TE.common, digits, "NA", big.mark = big.mark),
                 formatCI(formatN(lowTE.common, digits, "NA",
                                  big.mark = big.mark),
                          formatN(uppTE.common, digits, "NA",
                                  big.mark = big.mark)),
                 formatN(round(sTE.common, digits = digits.stat),
                         digits.stat, big.mark = big.mark),
                 formatPT(pTE.common, digits = digits.pval,
                          scientific = scientific.pval))
    
    zlab <- "z"
    
    names(res) <- c("k.suspect", "maxbias",
                    sm.lab, ci.lab, zlab, "p-value")
    
    dimnames(res) <- list(rep("", length(k.suspect)),
                          c("k.suspect", "maxbias",
                            sm.lab, ci.lab, zlab, "p-value"))
    
    prmatrix(res, quote = FALSE, right = TRUE)
  }
  
  
  if (random & (x$tau != 0 | !common)) {
    cat("\nRandom effects model\n\n")
    
    res <- cbind(k.suspect,
                 formatN(maxbias, digits, big.mark = big.mark),
                 formatN(TE.random, digits, "NA", big.mark = big.mark),
                 formatCI(formatN(lowTE.random, digits, "NA",
                                  big.mark = big.mark),
                          formatN(uppTE.random, digits, "NA",
                                  big.mark = big.mark)),
                 formatN(round(sTE.random, digits = digits.stat),
                         digits.stat, big.mark = big.mark),
                 formatPT(pTE.random, digits = digits.pval,
                          scientific = scientific.pval))
    
    zlab <- "z"
    
    names(res) <- c("k.suspect", "maxbias",
                    sm.lab, ci.lab, zlab, "p-value")
    
    dimnames(res) <- list(rep("", length(k.suspect)),
                          c("k.suspect", "maxbias",
                            sm.lab, ci.lab, zlab, "p-value"))
    
    prmatrix(res, quote = FALSE, right = TRUE)
  }
  
  
  if (common | random) {
    ## Print information on summary method:
    catmeth(method = x$x$method,
            method.tau = if (random) x$x$method.tau else "",
            sm = sm,
            k.all = 666)
  }
  
  
  invisible(NULL)
}
