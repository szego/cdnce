#' CDNify a **plotly** page
#'
#' This function replaces dependencies in [plotly](https://github.com/ropensci/plotly/)
#' .html pages generated using [htmlwidgets::saveWidget()].
#'
#' The page must have been saved with `selfcontained = FALSE` in the
#' call to [htmlwidgets::saveWidget()].
#'
#' @param filename .html file to CDNify.
#' @param libdir Directory containing dependencies (defaults to filename_files).
#'
#' @export
cdnify_plotly <- function(filename, libdir = sub(".html$", "_files", filename)) {
  if(missing(filename))
    stop("Argument 'filename' must be provided.")

  filename %>%
    readLines() %>%
    stringr::str_replace(
      "=\"[^\"]*htmlwidgets-([0-9\\.]+)/htmlwidgets.js\"",
      "=\"https://cdn.jsdelivr.net/gh/ramnathv/htmlwidgets@\\1/inst/www/htmlwidgets.js\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*jquery-([0-9\\.]+)/jquery.min.js\"",
      "=\"https://code.jquery.com/jquery-\\1.min.js\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*plotly-binding-([0-9\\.]+)/plotly.js\"",
      "=\"https://cdn.jsdelivr.net/gh/ropensci/plotly@\\1/inst/htmlwidgets/plotly.js\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*typedarray-([0-9\\.]+)/typedarray.min.js\"",
      "=\"https://cdn.jsdelivr.net/gh/ropensci/plotly/inst/htmlwidgets/lib/typedarray/typedarray.min.js\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*crosstalk-([0-9\\.]+)/css/crosstalk.css\"",
      "=\"https://cdn.jsdelivr.net/gh/rstudio/crosstalk@\\1/inst/www/css/crosstalk.css\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*crosstalk-([0-9\\.]+)/js/crosstalk.min.js\"",
      "=\"https://cdn.jsdelivr.net/gh/rstudio/crosstalk@\\1/inst/www/js/crosstalk.min.js\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*plotly-htmlwidgets-css-([0-9\\.]+)/plotly-htmlwidgets.css\"",
      "=\"https://cdn.jsdelivr.net/gh/ropensci/plotly/inst/htmlwidgets/lib/plotlyjs/plotly-htmlwidgets.css\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*plotly-main-([0-9\\.]+)/plotly-latest.min.js\"",
      "=\"https://cdn.plot.ly/plotly-\\1.min.js\""
    ) %>%
    writeLines(filename)

  to_delete <-
    c(
      "/htmlwidgets-([0-9\\.]+)$",
      "/jquery-([0-9\\.]+)$",
      "/plotly-binding-([0-9\\.]+)$",
      "/typedarray-([0-9\\.]+)$",
      "/crosstalk-([0-9\\.]+)$",
      "/plotly-htmlwidgets-css-([0-9\\.]+)$",
      "/plotly-main-([0-9\\.]+)$"
    ) %>%
    paste(collapse = "|") %>%
    paste0("(", ., ")")

  libdir %>%
    list.dirs(full.names = TRUE, recursive = TRUE) %>%
    .[which(stringr::str_detect(., to_delete))] %>%
    unlink(recursive = TRUE)

  invisible()
}
