
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

> [!IMPORTANT] 
> Once installed, you may need to restart RStudio to see the functions from `{ospsuite.addins}` in the Addins list.

## Addins for `{ospsuite}`

> [!NOTE]
> All the functions introduced in the examples below can be access by clicking in the Addins menu in RStudio and select the corresponding item.

### View simulation tree

```r
ospsuite.addins::runSimulationTree()
```

### Insert OSPSuite template code

```r
ospsuite.addins::insertOSPSuiteTemplate()
```

### Get all OSPSuite dimensions and units

```r
ospsuite.addins::tableOfUnits()
```

### Get all OSPSuite PK Parameters, their dimensions and units

```r
ospsuite.addins::tableOfPKParameters()
```

## Addins for `{ospsuite.reportingengine}`

### View your markdown or docx report

```r
ospsuite.addins::viewReport()
```

### Copy and open a Qualification Template

```r
ospsuite.addins::copyQualificationTemplate()
```
