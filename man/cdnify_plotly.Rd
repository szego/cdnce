% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cdnify_plotly.R
\name{cdnify_plotly}
\alias{cdnify_plotly}
\title{CDNify a \strong{plotly} page}
\usage{
cdnify_plotly(filename, libdir = sub(".html$", "_files", filename))
}
\arguments{
\item{filename}{.html file to CDNify.}

\item{libdir}{Directory containing dependencies (defaults to filename_files).}
}
\description{
This function replaces dependencies in \href{https://github.com/ropensci/plotly/}{plotly}
.html pages generated using \code{\link[htmlwidgets:saveWidget]{htmlwidgets::saveWidget()}}.
}
\details{
The page must have been saved with \code{selfcontained = FALSE} in the
call to \code{\link[htmlwidgets:saveWidget]{htmlwidgets::saveWidget()}}.
}
