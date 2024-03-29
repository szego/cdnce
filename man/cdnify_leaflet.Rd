% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cdnify_leaflet.R
\name{cdnify_leaflet}
\alias{cdnify_leaflet}
\title{CDNify a \strong{tufte} page}
\usage{
cdnify_leaflet(filename, libdir = sub(".html$", "_files", filename))
}
\arguments{
\item{filename}{.html file to CDNify.}

\item{libdir}{Directory containing dependencies (defaults to filename_files).}
}
\description{
This function replaces dependencies in \href{https://rstudio.github.io/leaflet/}{leaflet}
.html pages generated using \code{\link[htmlwidgets:saveWidget]{htmlwidgets::saveWidget()}}.
}
\details{
The page must have been saved with \code{selfcontained = FALSE} in the
call to \code{\link[htmlwidgets:saveWidget]{htmlwidgets::saveWidget()}}.
}
