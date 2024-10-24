
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OSPSuite.Addins

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/OSPSuite.Addins)](https://CRAN.R-project.org/package=OSPSuite.Addins)
<!-- badges: end -->

The goal of `{ospsuite.addins}` is to provide RStudio [addins](https://rstudio.github.io/rstudio-extensions/rstudio_addins.html) to work with the Open System Pharmacology ecosystem.

## Installation &#x1f4bb;

You can install the development version of OSPSuite.Addins from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("Open-Systems-Pharmacology/OSPSuite.Addins")
```

> <font color = "violet"><strong> &#x1f6c8;  Important </strong></font>
> 
> Once installed, you may need to restart RStudio to see the functions from `{ospsuite.addins}` in the Addins list.

## Documentation &#128214;

Quick tutorial videos showing how each addin works are available in the Articles tab. 

Sections below provide a quick snapshot of the current addins and their purpose.

## Addins for [`{ospsuite}`](https://www.open-systems-pharmacology.org/OSPSuite-R/) &#11088;

> [!NOTE]
> All the functions introduced in the examples below can be access by clicking in the __Addins__ menu in RStudio and select the corresponding item.


| &#128204; Name | &#128203; Description | &#128223; Function |
|----------------|-----------------------|----------|
| __View OSP Units__ | View datatable of OSPSuite Dimensions,<br> Units and Base Units | `tableOfUnits()` |
| __View PK Parameters__ | View datatable of OSPSuite PK Parameters | `tableOfPKParameters()` |
| __OSP Unit Converter__ | Convert Values in Desired OSPSuite Unit | `unitConverter()` |
| __View Simulation Tree__ | View simulation tree<br>and select branches | `runSimulationTree()` |
| __Insert OSPSuite Template__ | Insert OSPSuite Template | `insertOSPSuiteTemplate()` |


## Addins for [`{ospsuite.reportingengine}`](https://www.open-systems-pharmacology.org/OSPSuite.ReportingEngine/) &#11088;

| &#128204; Name | &#128203; Description | &#128223; Function |
|----------------|-----------------------|----------|
| __View Report__ | View Reporting Engine Report | `viewReport()` |
| __Copy Qualification Template__ | Copy and open the Qualification Template file | `copyQualificationTemplate()` |


## Code of conduct

Everyone interacting in the Open Systems Pharmacology community (codebases, issue trackers, chat rooms, mailing lists etc...) is expected to follow the Open Systems Pharmacology [code of conduct](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CODE_OF_CONDUCT.md).

## Contribution &#128161;

We encourage contribution to the Open Systems Pharmacology community. Before getting started please read the [contribution guidelines](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CONTRIBUTING.md). If you are contributing code, please be familiar with the [coding standards](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CODING_STANDARDS_R.md).

Please submit new feature ideas &#128161; and bug reports &#x1F41B; using the Github [__issues__](https://github.com/Open-Systems-Pharmacology/OSPSuite.Addins/issues) tab.

## License

OSPSuite.Addins Library is released under the [GPLv3 License](LICENSE.md).

All trademarks within this document belong to their legitimate owners.