% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/forest.orbbound.R
\name{forest.orbbound}
\alias{forest.orbbound}
\title{Forest plot for \code{orbbound} object (bound for outcome reporting
bias)}
\usage{
\method{forest}{orbbound}(
  x,
  common = x$x$common,
  random = x$x$random,
  text.common = "CE model",
  text.random = "RE model",
  smlab = NULL,
  leftcols = c("studlab", "maxbias"),
  leftlabs = c("Missing\\nstudies", "Maximum\\nbias"),
  backtransf = x$backtransf,
  digits = max(3, .Options$digits - 3),
  warn.deprecated = gs("warn.deprecated"),
  ...
)
}
\arguments{
\item{x}{An object of class \code{orbbound}.}

\item{common}{A logical indicating whether sensitivity analysis for
common effect model should be plotted.}

\item{random}{A logical indicating whether sensitivity analysis for
random effects model should be plotted.}

\item{text.common}{A character string used in the plot to label
subgroup with results for common effect model.}

\item{text.random}{A character string used in the plot to label
subgroup with results for random effects model.}

\item{smlab}{A label printed at top of figure. If only results for
either common effect or random effects model is plotted, text
indicates which model was used.}

\item{leftcols}{A character vector specifying (additional) columns
to be plotted on the left side of the forest plot or a logical
value (see \code{\link{forest.meta}} help page for details).}

\item{leftlabs}{A character vector specifying labels for
(additional) columns on left side of the forest plot (see
\code{\link{forest.meta}} help page for details).}

\item{backtransf}{A logical indicating whether results should be
back transformed in printouts and plots. If
\code{backtransf=TRUE} (default), results for \code{sm="OR"} are
printed as odds ratios rather than log odds ratio, for example.}

\item{digits}{Minimal number of significant digits, see
\code{print.default}.}

\item{warn.deprecated}{A logical indicating whether warnings should
be printed if deprecated arguments are used.}

\item{\dots}{Additional arguments for \code{\link{forest.meta}}
function and to catch deprecated arguments.}
}
\description{
Draws a forest plot in the active graphics window (using grid
graphics system).
}
\details{
A forest plot, also called confidence interval plot, is drawn in
the active graphics window.

For relative effect measures, e.g., 'RR', 'OR', and 'HR', the
column labeled "Maximum bias" contains the relative bias, e.g. a
value of 1.10 means a maximum overestimation by 10 percent. If
\code{backtransf=FALSE} for these summary measures, maximum bias is
instead printed as absolute bias.

Internally, R function \code{\link{forest.meta}} is called to
create a forest plot. For more information see help page of the
\code{\link{forest.meta}} function.
}
\examples{
data(Fleiss1993bin, package = "meta")

m1 <- metabin(d.asp, n.asp, d.plac, n.plac, data = Fleiss1993bin, sm = "OR")

orb1 <- orbbound(m1, k.suspect = 1:5)
print(orb1, digits = 2)
forest(orb1, xlim = c(0.7, 1.5))
\dontrun{forest(orb1, backtransf = FALSE)}

}
\seealso{
\code{\link{orbbound}}, \code{\link{print.orbbound}}
}
\author{
Guido Schwarzer \email{guido.schwarzer@uniklinik-freiburg.de}
}
\keyword{hplot}
