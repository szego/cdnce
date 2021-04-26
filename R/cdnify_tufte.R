#' CDNify a **tufte** page
#'
#' This function replaces dependencies in .html pages generated using
#' the [tufte](https://github.com/rstudio/tufte) package.
#'
#' The page must have been knit with `self_contained: false` in the
#' YAML header. For example, a valid header would be:
#'
#' \preformatted{---
#' title: "An Example Using the Tufte Style"
#' author: "John Smith"
#' output:
#'   tufte::tufte_html:
#'     tufte_features: ["fonts", "background", "italics"]
#'     self_contained: false
#' ---}
#'
#' @param filename .html file to CDNify.
#' @param libdir Directory containing dependencies (defaults to filename_files).
#'
#' @export
cdnify_tufte <- function(filename, libdir = sub(".html$", "_files", filename)) {
  if(missing(filename))
    stop("Argument 'filename' must be provided.")

  filename %>%
    readLines() %>%
    stringr::str_replace(
      "=\"[^\"]*highlightjs-([0-9\\.]+)/highlight.js\"",
      "=\"https://unpkg.com/highlight.js@\\1/lib/highlight.js\""
    ) %>%
    writeLines(filename)

  libdir %>%
    list.files(full.names = TRUE, recursive = TRUE) %>%
    .[which(stringr::str_detect(., "/highlight.js$"))] %>%
    file.remove()

  invisible()
}
