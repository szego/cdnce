#' CDNify a **tufte** page
#'
#' This function replaces dependencies in [leaflet](https://rstudio.github.io/leaflet/)
#' .html pages generated using [htmlwidgets::saveWidget()].
#'
#' The page must have been saved with `selfcontained = TRUE` in the
#' call to [htmlwidgets::saveWidget()].
#'
#' @param html A string containing a valid path to an .html file.
#'
#' @export
cdnify_leaflet <- function(html, libdir = sub(".html$", "_files", html)) {
  if(missing(html))
    stop("Argument 'html' must be provided.")

  html %>%
    readLines() %>%
    stringr::str_replace(
      "=\"[^\"]*htmlwidgets-([0-9\\.]+)/htmlwidgets.js\"",
      "=\"https://cdn.jsdelivr.net/gh/ramnathv/htmlwidgets@\\1/inst/www/htmlwidgets.js\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*jquery-([0-9\\.]+)/jquery.min.js\"",
      "=\"https://code.jquery.com/jquery-\\1.min.js\""
    ) %>%
    stringr::str_replace_all(  # replaces leaflet.js and leaflet.css
      "=\"[^\"]*leaflet-([0-9\\.]+)/leaflet",
      "=\"https://unpkg.com/leaflet@\\1/dist/leaflet"
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*Proj4Leaflet-([0-9\\.]+)/proj4leaflet.js\"",
      "=\"https://unpkg.com/proj4leaflet@\\1/src/proj4leaflet.js\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*proj4-([0-9\\.]+)/proj4.min.js\"",
      "=\"https://unpkg.com/proj4@\\1/dist/proj4.js\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*leaflet-binding-([0-9\\.]+)/leaflet.js\"",
      "=\"https://cdn.jsdelivr.net/gh/rstudio/leaflet/inst/htmlwidgets/leaflet.js\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*leafletfix-([0-9\\.]+)/leafletfix.css\"",
      "=\"https://cdn.jsdelivr.net/gh/rstudio/leaflet/inst/htmlwidgets/lib/leafletfix/leafletfix.css\""
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*rstudio_leaflet-([0-9\\.]+)/rstudio_leaflet.css\"",
      "=\"https://cdn.jsdelivr.net/gh/rstudio/leaflet/inst/htmlwidgets/lib/rstudio_leaflet/rstudio_leaflet.css\""
    ) %>%
    writeLines(html)

  to_delete <-
    c(
      "/htmlwidgets.js$",
      "/jquery.min.js$",
      "/leaflet.js$",
      "/leaflet.css$",
      "/proj4leaflet.js$",
      "/proj4.min.js$",
      "/leafletfix.css$",
      "/rstudio_leaflet.css$"
    ) %>%
    paste(collapse = "|") %>%
    paste0("(", ., ")")

  libdir %>%
    list.files(full.names = TRUE, recursive = TRUE) %>%
    .[which(stringr::str_detect(., to_delete))] %>%
    file.remove()

  invisible()
}
