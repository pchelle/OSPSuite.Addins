# oatFromEGFR

Scale OAT reference concentrations according to eGFR using the equation
from
[doi:10.1007/s40262-022-01121-6](https://doi.org/10.1007/s40262-022-01121-6)
: `oat * (1 - exp(-(egfr / 43.9)^0.9))`

## Usage

``` r
oatFromEGFR(oat, egfr)
```

## Arguments

- oat:

  Numeric values of OAT reference concentrations

- egfr:

  Numeric values of eGFR in mL/min/1.73m²

## Value

Numeric values of updated OAT reference concentrations

## Examples

``` r
oatFromEGFR(oat = c(1, 1, 1), egfr = c(15, 60, 120))
```
