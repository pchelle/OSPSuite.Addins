
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

> [!NOTE]
> All the functions introduced in the examples below can be access by clicking in the __Addins__ menu in RStudio and select the corresponding item.

## Addins for [`{ospsuite}`](https://www.open-systems-pharmacology.org/OSPSuite-R/) &#11088;


### View OSP Units

View datatable of OSPSuite Dimensions, Units and Base Units

```r
ospsuite.addins::tableOfUnits()
```

### View PK Parameters

View datatable of OSPSuite PK Parameters

```r
ospsuite.addins::tableOfPKParameters()
```

### OSP Unit Converter

Convert Values in Desired OSPSuite Unit

```r
ospsuite.addins::unitConverter()
```

### View Simulation Tree

View simulation tree and select branches

```r
ospsuite.addins::runSimulationTree()
```

### Insert OSPSuite Template

Insert OSPSuite Template in your R Script

```r
ospsuite.addins::insertOSPSuiteTemplate()
```

## Addins for [`{ospsuite.reportingengine}`](https://www.open-systems-pharmacology.org/OSPSuite.ReportingEngine/) &#11088;

### View Report

Open and view your report populated by the Reporting Engine with the appropriate software

```r
ospsuite.addins::viewReport()
```

### Copy Qualification Template

Copy and open the Qualification Template R Script

```r
ospsuite.addins::copyQualificationTemplate()
```

## Additional Addins &#11088;

### Convert your files to UTF-8

Check and convert your files to UTF-8 encoding

```r
ospsuite.addins::utfCheck()
```

## Code of conduct

Everyone interacting in the Open Systems Pharmacology community (codebases, issue trackers, chat rooms, mailing lists etc...) is expected to follow the Open Systems Pharmacology [code of conduct](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CODE_OF_CONDUCT.md).

## Contribution &#128161;

We encourage contribution to the Open Systems Pharmacology community. Before getting started please read the [contribution guidelines](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CONTRIBUTING.md). If you are contributing code, please be familiar with the [coding standards](https://github.com/Open-Systems-Pharmacology/Suite/blob/master/CODING_STANDARDS_R.md).

Please submit new feature ideas &#128161; and bug reports &#x1F41B; using the Github [__issues__](https://github.com/Open-Systems-Pharmacology/OSPSuite.Addins/issues) tab.

## License

OSPSuite.Addins Library is released under the [GPLv3 License](LICENSE.md).

All trademarks within this document belong to their legitimate owners.