
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OSPSuite.Addins

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/OSPSuite.Addins)](https://CRAN.R-project.org/package=OSPSuite.Addins)
<!-- badges: end -->

The goal of `{ospsuite.addins}` is to provide RStudio addins to work
with the Open System Pharmacology ecosystem.

## Installation

You can install the development version of OSPSuite.Addins from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("pchelle/OSPSuite.Addins")
```

> [!IMPORTANT] Once installed, you will need to restart RStudio to see
> the functions from `{ospsuite.addins}` in the Addins list.

## Examples

### Get all OSPSuite dimensions and units

To get a datatable of all the OSPSuite dimensions and units, you can use
the following code:

``` r
ospsuite.addins::tableOfUnits()
```

> [!TIP] You can also go to the Addins menu in RStudio and select
> “**View OSP Units**”.

### Get all OSPSuite PK Parameters, their dimensions and units

To get a datatable of all the OSPSuite PK Parameters, their dimensions
and units, you can use the following code:

``` r
ospsuite.addins::tableOfPKParameters()
```

> [!TIP] You can also go to the Addins menu in RStudio and select
> “**View PK Parameters**”.
