#' @title oatFromEGFR
#' @description
#' Scale OAT reference concentrations according to eGFR
#' using the equation from \doi{10.1007/s40262-022-01121-6}:
#' `oat * (1 - exp(-(egfr / 43.9)^0.9))`
#' @param oat Numeric values of OAT reference concentrations
#' @param egfr Numeric values of eGFR in mL/min/1.73m²
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

#' @title getNormalizedEGFR
#' @description
#' Get eGFR normalized by BSA in mL/min/1.73m² from population base unit values
#' @param egfr eGFR values in base unit (l/min)
#' @param bsa BSA values in base unit (dm²)
#' @return Numeric values of normalized eGFR in mL/min/1.73m²
#' @keywords internal
getNormalizedEGFR <- function(egfr, bsa) {
  egfr <- ospsuite::toUnit("Flow", egfr, "ml/min")
  bsa <- ospsuite::toUnit("Area", bsa, "m\u00b2")
  return(egfr * 1.73 / bsa)
}

#' @title runEGFRUpdate
#' @description
#' Popup shiny app that applies eGFR related changes to OAT reference
#' concentrations of an OSPSuite population file using the equation from
#' \doi{10.1007/s40262-022-01121-6} (see [oatFromEGFR()]).
#' The updated population is saved as a csv file selected by the user.
#'
#' @return A shiny app
#' @export
#' @import shiny
#' @import miniUI
#' @importFrom ggplot2 .data
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
  population <- ospsuite::loadPopulation(populationFile)
  variableNames <- population$allParameterPaths
  bsaPath <- getPathByLeafName(variableNames, "BSA")
  egfrPath <- getPathByLeafName(variableNames, "eGFR")
  isAvailable <- length(bsaPath) == 1 && length(egfrPath) == 1

  if (isAvailable) {
    egfr <- getNormalizedEGFR(
      egfr = population$getParameterValues(egfrPath),
      bsa = population$getParameterValues(bsaPath)
    )
    variableChoices <- setdiff(variableNames, c(bsaPath, egfrPath))
    selectedVariables <- grep(
      "reference concentration",
      variableChoices,
      ignore.case = TRUE,
      value = TRUE
    )
  }

  # Shiny App UI
  ui <- miniPage(
    gadgetTitleBar(
      basename(populationFile),
      right = if (isAvailable) {
        miniTitleBarButton("done", "Update and Save", primary = TRUE)
      }
    ),
    miniContentPanel(
      if (isAvailable) {
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
      } else {
        HTML(paste0(
          "<font color=\"darkred\">",
          icon("triangle-exclamation"),
          " BSA/eGFR not available in Population data",
          "</font>"
        ))
      }
    )
  )

  # Shiny App Server
  server <- function(input, output, session) {
    if (isAvailable) {
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
          ggplot2::labs(x = "eGFR [mL/min/1.73m\u00b2]", y = NULL, color = NULL) +
          ggplot2::theme_bw() +
          ggplot2::theme(legend.position = "top")
      })
    }

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
