#' @title oatFromEGFR
#' @description
#' Scale OAT reference concentrations according to eGFR
#' using the equation from \doi{10.1007/s40262-022-01121-6}:
#' `oat * (1 - exp(-(egfr / 43.9)^0.9))`
#' @param oat Numeric values of OAT reference concentrations
#' @param egfr Numeric values of eGFR in mL/min
#' @return Numeric values of updated OAT reference concentrations
#' @export
#' @examples
#' oatFromEGFR(oat = c(1, 1, 1), egfr = c(15, 60, 120))
oatFromEGFR <- function(oat, egfr) {
  epah <- 1 - exp(-(egfr / 43.9)^0.9)
  return(oat * epah)
}

#' @title getPathByLeafName
#' @description
#' Get the parameter paths whose last element exactly matches a name
#' @param paths Character vector of parameter paths
#' @param name Leaf name to match
#' @return Character vector of matching paths
#' @keywords internal
getPathByLeafName <- function(paths, name) {
  leafNames <- sapply(strsplit(paths, "|", fixed = TRUE), utils::tail, n = 1)
  return(paths[leafNames %in% name])
}

#' @title getEGFRValues
#' @description
#' Get BSA adjusted eGFR values in mL/min/1.73m² from the data of a PK-Sim
#' Scatter Plot export including eGFR.
#' The column names of the export carry the unit of the plotted quantities,
#' e.g. `Kidney-eGFR [ml/min/1.73m²]`.
#' @param data A `data.frame` with the data of a PK-Sim Scatter Plot export
#' @return Numeric values of eGFR in mL/min/1.73m², or `NULL` if the eGFR
#' column is missing or ambiguous
#' @keywords internal
getEGFRValues <- function(data) {
  egfrColumns <- grep("(^|-)eGFR \\[[^]]+\\]$", names(data), value = TRUE)
  if (length(egfrColumns) == 0) {
    cli::cli_warn(
      c("No eGFR column found in the Scatter Plot data.",
        i = "Please export the data of a PK-Sim Scatter Plot including eGFR"
      )
    )
    return(NULL)
  }
  if (length(egfrColumns) > 1) {
    cli::cli_warn(
      c("Multiple eGFR columns found in the Scatter Plot data.",
        i = "Found {.val {egfrColumns}}",
        i = "Please include eGFR only once in the PK-Sim Scatter Plot"
      )
    )
    return(NULL)
  }
  return(as.numeric(data[[egfrColumns]]))
}

#' @title getAbsoluteEGFR
#' @description
#' Get eGFR in mL/min from BSA adjusted eGFR in mL/min/1.73m²
#' @param egfr Numeric values of BSA adjusted eGFR in mL/min/1.73m²
#' @param bsa Numeric values of BSA in base unit (dm²)
#' @return Numeric values of eGFR in mL/min
#' @keywords internal
getAbsoluteEGFR <- function(egfr, bsa) {
  bsa <- ospsuite::toUnit("Area", bsa, "m\u00b2")
  return(egfr * bsa / 1.73)
}

#' @title runEGFRUpdate
#' @description
#' Popup shiny app that applies eGFR related changes to OAT reference
#' concentrations of an OSPSuite population file using the equation from
#' \doi{10.1007/s40262-022-01121-6} (see [oatFromEGFR()]).
#' eGFR values are read from an Excel file exported from PK-Sim:
#' create a Scatter Plot including eGFR and export its data.
#' The BSA adjusted eGFR values in mL/min/1.73m² are converted to eGFR in
#' mL/min with the BSA parameter of the population.
#' The eGFR values are matched to the individuals of the population by order,
#' so the Scatter Plot must be created from the population to update.
#' The updated population is saved as a csv file selected by the user.
#'
#' @return A shiny app
#' @export
#' @import shiny
#' @import miniUI
#' @importFrom ggplot2 .data
#' @importFrom readxl read_xlsx
runEGFRUpdate <- function() {
  populationFile <- rstudioapi::selectFile(
    caption = "Select Population File",
    filter = "CSV (*.csv)"
  )
  if (is.null(populationFile)) {
    return(invisible())
  }
  if (!ospsuite.utils::isFileExtension(populationFile, "csv")) {
    cli::cli_warn(
      c("Selected file is not a valid OSPSuite population file.",
        i = "Please select a {.strong '.csv'} file"
      )
    )
    return(invisible())
  }
  egfrFile <- rstudioapi::selectFile(
    caption = "Select eGFR Scatter Plot Data File",
    filter = "Excel (*.xlsx)"
  )
  if (is.null(egfrFile)) {
    return(invisible())
  }
  if (!ospsuite.utils::isFileExtension(egfrFile, "xlsx")) {
    cli::cli_warn(
      c("Selected file is not a valid PK-Sim Scatter Plot data export.",
        i = "Please select a {.strong '.xlsx'} file"
      )
    )
    return(invisible())
  }
  population <- ospsuite::loadPopulation(populationFile)
  normalizedEGFR <- getEGFRValues(readxl::read_xlsx(egfrFile))
  if (is.null(normalizedEGFR)) {
    return(invisible())
  }
  if (population$count != length(normalizedEGFR)) {
    cli::cli_warn(
      c("Number of eGFR values ({length(normalizedEGFR)}) does not match the number of individuals in the population ({population$count}).",
        i = "Please export the Scatter Plot data of the population to update"
      )
    )
    return(invisible())
  }
  variableNames <- population$allParameterPaths
  bsaPath <- getPathByLeafName(variableNames, "BSA")
  if (length(bsaPath) != 1) {
    cli::cli_warn(
      c("BSA parameter not available in the population data.",
        i = "BSA is required to convert the BSA adjusted eGFR to mL/min"
      )
    )
    return(invisible())
  }
  egfr <- getAbsoluteEGFR(
    egfr = normalizedEGFR,
    bsa = population$getParameterValues(bsaPath)
  )
  # BSA and eGFR are not eligible for the OAT scaling
  variableChoices <- setdiff(
    variableNames,
    getPathByLeafName(variableNames, c("eGFR", "BSA"))
  )
  selectedVariables <- grep(
    "reference concentration",
    variableChoices,
    ignore.case = TRUE,
    value = TRUE
  )

  # Shiny App UI
  ui <- miniPage(
    gadgetTitleBar(
      basename(populationFile),
      right = miniTitleBarButton("done", "Update and Save", primary = TRUE)
    ),
    miniContentPanel(
      fillCol(
        flex = c(NA, 1),
        selectInput(
          "variableNames",
          label = span(icon("list-check"), "Variables to update"),
          choices = variableChoices,
          selected = selectedVariables,
          multiple = TRUE,
          width = "100%"
        ),
        plotOutput("egfrPlot", height = "100%")
      )
    )
  )

  # Shiny App Server
  server <- function(input, output, session) {
    output$egfrPlot <- renderPlot({
      req(input$variableNames)
      plotData <- do.call(
        rbind,
        lapply(input$variableNames, function(variableName) {
          values <- population$getParameterValues(variableName)
          data.frame(
            eGFR = rep(egfr, 2),
            Value = c(values, oatFromEGFR(values, egfr)),
            Population = rep(c("Original", "Updated"), each = length(values)),
            Variable = variableName
          )
        })
      )
      ggplot2::ggplot(
        plotData,
        ggplot2::aes(x = .data$eGFR, y = .data$Value, color = .data$Population)
      ) +
        ggplot2::geom_point(alpha = 0.6) +
        ggplot2::scale_color_manual(
          values = c(Original = "grey60", Updated = "dodgerblue")
        ) +
        ggplot2::facet_wrap(~Variable, scales = "free_y", ncol = 1) +
        ggplot2::labs(x = "eGFR [mL/min]", y = NULL, color = NULL) +
        ggplot2::theme_bw() +
        ggplot2::theme(legend.position = "top")
    })

    observeEvent(input$done, {
      outputFile <- rstudioapi::selectFile(
        caption = "Save Updated Population File",
        label = "Save",
        path = populationFile,
        filter = "CSV (*.csv)",
        existing = FALSE
      )
      if (is.null(outputFile)) {
        return()
      }
      for (variableName in input$variableNames) {
        population$setParameterValues(
          variableName,
          oatFromEGFR(population$getParameterValues(variableName), egfr)
        )
      }
      ospsuite::exportPopulationToCSV(population, outputFile)
      cli::cli_alert_success("Updated population saved in {.file {outputFile}}")
      stopApp()
    })
    observeEvent(input$cancel, {
      stopApp()
    })
  }
  # Run the app
  runGadget(ui, server, viewer = dialogViewer("eGFR Update", width = 800, height = 700))
  return(invisible())
}
