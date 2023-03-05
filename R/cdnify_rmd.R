#' CDNify an .Rmd HTML Document
#'
#' This function replaces dependencies in HTML Documents knit from
#' .Rmd files.
#'
#' The page must have been knit with `self_contained: false` in the
#' YAML header. For example, a valid header would be:
#'
#' \preformatted{---
#' title: "An Example RMarkdown Document"
#' author: "Engelbert Humperdinck"
#' output:
#'   html_document:
#'     self_contained: false
#' ---}
#'
#' @param filename .html file to CDNify.
#' @param libdir Directory containing dependencies (defaults to filename_files).
#'
#' @export
cdnify_rmd <- function(filename, libdir = sub(".html$", "_files", filename)) {
  if(missing(filename))
    stop("Argument 'filename' must be provided.")

  rmd_ver <- as.character(packageVersion("rmarkdown"))

  filename %>%
    readLines() %>%
    stringr::str_replace(
      "=\"[^\"]*jquery-([0-9\\.]+)/jquery[0-9\\.-]*.min.js\"",
      "=\"https://code.jquery.com/jquery-\\1.min.js\""
    ) %>%
    stringr::str_replace_all(
      "=\"[^\"]*bootstrap-[0-9\\.]+/([\\w\\./]+)\"",
      paste0("=\"https://cdn.jsdelivr.net/gh/rstudio/rmarkdown@", rmd_ver, "/inst/rmd/h/bootstrap/\\1\"")
    ) %>%
    stringr::str_replace(
      "=\"[^\"]*header-attrs-[0-9\\.]+/header-attrs.js\"",
      paste0("=\"https://cdn.jsdelivr.net/gh/rstudio/rmarkdown@", rmd_ver, "/inst/rmd/h/pandoc/header-attrs.js\"")
    ) %>%
    stringr::str_replace_all(
      "=\"[^\"]*navigation-([0-9\\.]+)/([\\w\\./]+)\"",
      paste0("=\"https://cdn.jsdelivr.net/gh/rstudio/rmarkdown@", rmd_ver, "/inst/rmd/h/navigation-\\1/\\2\"")
    ) %>%
    stringr::str_replace_all(
      "=\"[^\"]*pagedtable-([0-9\\.]+)/([\\w\\./]+)\"",
      paste0("=\"https://cdn.jsdelivr.net/gh/rstudio/rmarkdown@", rmd_ver, "/inst/rmd/h/pagedtable-\\1/\\2\"")
    ) %>%
    writeLines(filename)

  to_delete <-
    c(
      "/jquery-([0-9\\.]+)$",
      "/bootstrap-([0-9\\.]+)$",
      "/header-attrs-([0-9\\.]+)$",
      "/navigation-([0-9\\.]+)$",
      "/pagedtable-([0-9\\.]+)$"
    ) %>%
    paste(collapse = "|") %>%
    paste0("(", ., ")")

  libdir %>%
    list.dirs(full.names = TRUE, recursive = TRUE) %>%
    .[which(stringr::str_detect(., to_delete))] %>%
    unlink(recursive = TRUE)

  if(list.dirs(libdir, full.names = FALSE) == "")
    unlink(libdir, recursive = TRUE)

  invisible()
}
