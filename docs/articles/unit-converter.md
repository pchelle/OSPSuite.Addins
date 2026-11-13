# Unit Converter

## Converter

The function
[`unitConverter()`](https://www.open-systems-pharmacology.org/OSPSuite.Addins/reference/unitConverter.md)
starts a shiny app in the RStudio Viewer pane that allows users to
convert between units of the same dimension as illustrated in the video
below.

View Unit Converter Video

[Video](https://www.open-systems-pharmacology.org/OSPSuite.Addins/articles/videos/unit-converter.mp4)

## Bridging Dimensions with Molecular Weight

So far, the following dimensions can be bridged by **Molecular Weight**:

- **Amount** and **Mass**
- **Concentration (mass)** and **Concentration (molar)**
- **AUC (mass)** and **AUC (molar)**

When selecting one of these dimensions, users are notified by the app
that conversion to the bridged dimension is supported.

The **Molecular Weight** and its **Unit** defined by the user will be
taken into account if converting to the bridged dimension.

## Fractions

For the **Fraction** dimension, the unit named `Unitless` is defined as
such in the enum `ospUnits` and corresponds to the fraction as is.

If users need to convert between fractions, they should currently
provide the unit `""` instead of `"Unitless"`.
