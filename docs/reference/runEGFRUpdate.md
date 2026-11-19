# runEGFRUpdate

Popup shiny app that applies eGFR related changes to OAT reference
concentrations of an OSPSuite population file using the equation from
[doi:10.1007/s40262-022-01121-6](https://doi.org/10.1007/s40262-022-01121-6)
(see
[`oatFromEGFR()`](https://www.open-systems-pharmacology.org/OSPSuite.Addins/reference/oatFromEGFR.md)).
eGFR values are read from an Excel file exported from PK-Sim: create a
Scatter Plot including eGFR and export its data. The BSA adjusted eGFR
values in mL/min/1.73m² are converted to eGFR in mL/min with the BSA
parameter of the population. The eGFR values are matched to the
individuals of the population by order, so the Scatter Plot must be
created from the population to update. The updated population is saved
as a csv file selected by the user.

## Usage

``` r
runEGFRUpdate()
```

## Value

A shiny app
