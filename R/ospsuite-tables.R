#' @title tableOfUnits
#' @description
#' This function will display a datatable of available OSPSuite units and their corresponding dimensions.
#' @return A datatable of available OSPSuite units and their corresponding dimensions.
#' @export
tableOfUnits <- function() {
  allDimensions <- as.character(ospsuite::ospDimensions)
  unitsData <- lapply(
    ospsuite::ospDimensions,
    function(dimension) {
      dimensionName <- gsub(pattern = "\\(", replacement = "[", dimension)
      dimensionName <- gsub(pattern = "\\)", replacement = "]", dimensionName)

      data.frame(
        Dimension = dimension,
        Unit = as.character(ospsuite::ospUnits[[dimensionName]]),
        BaseUnit = ospsuite::getBaseUnit(dimension)
      )
    }
  )
  unitsData <- do.call(rbind, unitsData)
  # Nice formatted datatable with options
  unitsTable <- DT::datatable(
    unitsData,
    escape = TRUE,
    rownames = FALSE,
    filter = "top",
    options = list(
      dom = "t",
      scroller = TRUE,
      scrollY = TRUE,
      searchHighlight = TRUE,
      pageLength = nrow(unitsData)
    )
  )
  return(unitsTable)
}

#' @title tableOfPKParameters
#' @description
#' This function will display a datatable of available PK Parameters
#' @return A datatable of available PK Parameters
#' @export
tableOfPKParameters <- function() {
  allDimensions <- as.character(ospsuite::ospDimensions)
  pkData <- lapply(
    ospsuite::allPKParameterNames(),
    function(parameterName) {
      pkParameter <- ospsuite::pkParameterByName(parameterName)
      data.frame(
        Name = parameterName,
        DisplayName = pkParameter$displayName,
        Dimension = pkParameter$dimension,
        DisplayUnit = pkParameter$displayUnit
      )
    }
  )
  pkData <- do.call(rbind, pkData)
  # Nice formatted datatable with options
  pkTable <- DT::datatable(
    pkData,
    escape = TRUE,
    rownames = FALSE,
    filter = "top",
    options = list(
      dom = "t",
      scroller = TRUE,
      scrollY = TRUE,
      searchHighlight = TRUE,
      pageLength = nrow(pkData)
    )
  )
  return(pkTable)
}
