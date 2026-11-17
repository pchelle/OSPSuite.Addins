test_that("oatFromEGFR applies the eGFR scaling equation", {
  expect_equal(oatFromEGFR(2, 43.9), 2 * (1 - exp(-1)))
  expect_equal(oatFromEGFR(c(1, 1), c(0, Inf)), c(0, 1))
})

test_that("getPathByLeafName only matches exact leaf names", {
  paths <- c("Organism|BSA", "Organism|Kidney|eGFR", "Organism|Kidney|eGFR fraction", "A|reference concentration")
  expect_equal(getPathByLeafName(paths, "BSA"), "Organism|BSA")
  expect_equal(getPathByLeafName(paths, "eGFR"), "Organism|Kidney|eGFR")
})

test_that("getAbsoluteEGFR converts BSA adjusted eGFR to mL/min", {
  # BSA base unit is dm²: 173 dm² = 1.73 m², 86.5 dm² = 0.865 m²
  expect_equal(getAbsoluteEGFR(c(15, 60, 120), rep(173, 3)), c(15, 60, 120))
  expect_equal(getAbsoluteEGFR(100, 86.5), 50)
})

test_that("getEGFRValues reads the eGFR column of Scatter Plot data", {
  scatterPlotData <- data.frame(
    check.names = FALSE,
    "IndividualId" = c(1, 2, 3),
    "Age [year(s)]" = c(20, 30, 40),
    "Kidney-eGFR [ml/min/1.73m\u00b2]" = c(15, 60, 120)
  )
  expect_equal(getEGFRValues(scatterPlotData), c(15, 60, 120))
})

test_that("getEGFRValues requires a single eGFR column", {
  noEGFRData <- data.frame(
    check.names = FALSE,
    "IndividualId" = c(1, 2),
    "Age [year(s)]" = c(20, 30)
  )
  expect_warning(noEGFRValues <- getEGFRValues(noEGFRData), "No eGFR column")
  expect_null(noEGFRValues)

  multipleEGFRData <- data.frame(
    check.names = FALSE,
    "Kidney-eGFR [ml/min/1.73m\u00b2]" = c(60),
    "Liver-eGFR [ml/min/1.73m\u00b2]" = c(90)
  )
  expect_warning(multipleEGFRValues <- getEGFRValues(multipleEGFRData), "Multiple eGFR columns")
  expect_null(multipleEGFRValues)
})
