test_that("oatFromEGFR applies the eGFR scaling equation", {
  expect_equal(oatFromEGFR(2, 43.9), 2 * (1 - exp(-1)))
  expect_equal(oatFromEGFR(c(1, 1), c(0, Inf)), c(0, 1))
})

test_that("getPathByLeafName only matches exact leaf names", {
  paths <- c("Organism|BSA", "Organism|Kidney|eGFR", "Organism|Kidney|eGFR fraction", "A|reference concentration")
  expect_equal(getPathByLeafName(paths, "BSA"), "Organism|BSA")
  expect_equal(getPathByLeafName(paths, "eGFR"), "Organism|Kidney|eGFR")
})
