# getEGFRValues

Get BSA adjusted eGFR values in mL/min/1.73m² from the data of a PK-Sim
Scatter Plot export including eGFR. The column names of the export carry
the unit of the plotted quantities, e.g. `Kidney-eGFR [ml/min/1.73m²]`.

## Usage

``` r
getEGFRValues(data)
```

## Arguments

- data:

  A `data.frame` with the data of a PK-Sim Scatter Plot export

## Value

Numeric values of eGFR in mL/min/1.73m², or `NULL` if the eGFR column is
missing or ambiguous
