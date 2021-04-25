
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cdnce

<!-- badges: start -->
<!-- badges: end -->

cdnce (“cadence”) modifies generated .html pages so that they load
JavaScript and CSS resources from remote CDNs instead of from local
files. This can greatly reduce their strain on your bandwidth.

## Installation

You can install the development version of cdnce from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("szego/cdnce")
```

## Example

Consider a simple document using the tufte style:

    ---
    title: "An Example Using the Tufte Style"
    author: "John Smith"
    output:
      tufte::tufte_html:
        tufte_features: ["fonts", "background", "italics"]
        self_contained: false
    ---

    # Blah blah

    Some more blah

Note that we set `self_contained: false` in the YAML header. This is
necessary for cdnce.

Suppose we had knit this document into the file “test.html”. To replace
its local dependencies with remote ones on CDNs using cdnce, we can run

``` r
cdnce::cdnify_tufte("test.html")
```
