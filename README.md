
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
> All the functions introduced in the examples below can be access by clicking in the __Addins__ menu in RStudio and select the corresponding item.


| &#128204; Name | &#128203; Description | &#128223; Function |
|----------------|-----------------------|----------|
| __View OSP Units__ | View datatable of OSPSuite Dimensions,<br> Units and Base Units | `tableOfUnits()` |
| __View PK Parameters__ | View datatable of OSPSuite PK Parameters | `tableOfPKParameters()` |
| __OSP Unit Converter__ | Convert Values in Desired OSPSuite Unit | `unitConverter()` |
| __View Simulation Tree__ | View simulation tree<br>and select branches | `runSimulationTree()` |
| __Insert OSPSuite Template__ | Insert OSPSuite Template | `insertOSPSuiteTemplate()` |


## Addins for `{ospsuite.reportingengine}`

| &#128204; Name | &#128203; Description | &#128223; Function |
|----------------|-----------------------|----------|
| __View Report__ | View Reporting Engine Report | `viewReport()` |
| __Copy Qualification Template__ | Copy and open the Qualification Template file | `copyQualificationTemplate()` |

