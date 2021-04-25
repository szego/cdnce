#' CDNify a **tufte** page
#'
#' This function replaces dependencies in .html pages generated using
#' the [tufte](https://github.com/rstudio/tufte) package.
#'
#' The page must have been knit with `self_contained: false``in the
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
#' @param html A string containing a valid path to an .html file.
#'
#' @export
cdnify_tufte <- function(html) {
  if(missing(html))
    stop("Argument 'html' must be provided.")

  html %>%
    readLines() %>%
    stringr::str_replace(
      "<script src=\"([^/]+)/highlightjs-([0-9\\.]+)/highlight.js\">",
      "<script src=\"https://unpkg.com/highlight.js@\\2/lib/highlight.js\">"
    ) %>%
    writeLines(html)

  html %>%
    dirname() %>%
    list.files(full.names = TRUE, recursive = TRUE) %>%
    .[which(stringr::str_detect(., "highlight.js$"))] %>%
    file.remove()

  invisible()
}
