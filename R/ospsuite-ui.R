#' @title formatSimulationTree
#' @description
#' Format the simulation tree to be displayed by `{shinyTree}` package
#' @param simulation A `Simulation` object
#' @return A list for the simulation tree.
#' @keywords internal
formatSimulationTree <- function(simulation) {
  simulationTree <- ospsuite::getSimulationTree(simulation)
  return(displayBranchNames(simulationTree))
}

#' @title displayBranchNames
#' @description
#' Display branch names of a simulation tree
#' @param tree A list of simulation paths
#' @return A list with branch names to display
#' @keywords internal
displayBranchNames <- function(tree) {
  lapply(
    tree,
    function(branch) {
      branch$path %||% displayBranchNames(branch)
    }
  )
}

#' @title runSimulationTree
#' @description
#' Popup shiny app that displays a simulation tree.
#' Selected branches are copied to clipboard when closing app.
#'
#' @return A shiny app
#' @export
#' @import shiny
#' @import miniUI
runSimulationTree <- function() {
  simulationFile <- rstudioapi::selectFile(filter = ".pkml")
  if (is.null(simulationFile)) {
    return(invisible())
  }
  if (!ospsuite.utils::isFileExtension(simulationFile, "pkml")) {
    cli::cli_warn(
      c("Selected file is not a valid OSPSuite simulation file.",
        i = "Please select a {.strong '.pkml'} file"
      )
    )
    return(invisible())
  }
  # Load simulation and simulation tree
  simulation <- ospsuite::loadSimulation(simulationFile)
  simulationTree <- formatSimulationTree(simulation)
  # Shiny App UI
  ui <- miniPage(
    gadgetTitleBar(simulation$name),
    miniTabstripPanel(
      miniTabPanel(
        "Search Paths",
        icon = icon("magnifying-glass"),
        miniContentPanel(
          strong(icon("folder-tree"), "Tree View"),
          br(),
          shinyTree::shinyTree(
            "simTree",
            themeIcons = FALSE,
            themeDots = FALSE,
            theme = "proton",
            search = TRUE,
            wholerow = FALSE,
            checkbox = TRUE
          )
        )
      ),
      miniTabPanel(
        "Selected Paths",
        icon = icon("square-check"),
        miniContentPanel(
          DT::dataTableOutput("selectedPaths")
        )
      )
    )
  )
  # Shiny App Server
  server <- function(input, output, session) {
    getSelectedPaths <- reactive({
      sapply(
        shinyTree::get_selected(input$simTree, format = "names"),
        function(branch) {
          paste0("\"", ospsuite::toPathString(attr(branch, "ancestry"), branch), "\"")
        }
      )
    })

    output$simTree <- shinyTree::renderTree({
      simulationTree
    })

    output$selectedPaths <- DT::renderDataTable({
      DT::datatable(
        data.frame(
          "Selected Paths" = getSelectedPaths(),
          check.names = FALSE
        ),
        rownames = FALSE,
        options = list(scrollX = TRUE, scrollY = TRUE)
      )
    })
    # Handle the Done button being pressed.
    observeEvent(input$done, {
      cli::cli_alert_info("The selected branches were copied to clipboard.")
      textToCopy <- paste("c(", paste(getSelectedPaths(), collapse = ",\n"), ")", sep = "\n")
      utils::writeClipboard(textToCopy)
      stopApp()
    })
    observeEvent(input$cancel, {
      stopApp()
    })
  }
  # Run the app
  runGadget(ui, server, viewer = dialogViewer("\U1F332 Simulation Tree"))
  return(invisible())
}

#' @title insertOSPSuiteTemplate
#' @description
#' Insert template code in current document aiming at
#' providing a starting point for users to interact with the `{ospsuite}` package.
#' The code will include the following steps:
#' - loads a simulation
#' - update a simulation parameter
#' - add output paths to a simulation
#' - run a simulation
#' - format simulation results
#' - save simulation results
#' - run a PK analysis
#' - format PK analysis results
#' - save PK analysis results
#' @export
insertOSPSuiteTemplate <- function() {
  textTemplate <- paste(
    "library(ospsuite)",
    "# Load the simulation",
    "simulationFile <- \"my/simulation/path.pkml\" #TODO: update this path",
    "simulation <- loadSimulation(simulationFile)",
    "",
    "# Update a parameter",
    "paramerPath <- \"Organism|Parameter|etc\" #TODO: update this variable",
    "parameterObject <- getParameter(paramerPath, simulation)",
    "newValue <- toBaseUnit(quantity = parameterObject, values = 42) #TODO: update values and unit",
    "setParameterValues(parameters = parameterObject, values = newValue)",
    "",
    "# Add output paths to a simulation runs",
    "newOutputs <- getAllObserverPathsIn(parameterObject) #TODO: update outputs",
    "addOutputs(newOutputs, simulation)",
    "",
    "# Run the simulation and extract its results",
    "simulationResults <- runSimulations(simulations = simulation)",
    "simulationResults <- simulationResults[[simulation$id]]",
    "# Get a tibble out of the results",
    "simulationData <- simulationResultsToTibble(simulationResults)",
    "# Save results into csv file",
    "exportResultsToCSV(results = simulationResults, filePath = \"simulation-results.csv\") #TODO: update this path",
    "",
    "# Calculate PK Analyses of the simulation results",
    "pkAnalysis <- calculatePKAnalyses(results = simulationResults)",
    "# Get a tibble out of the PK Analyses",
    "pkData <- pkAnalysesToTibble(pkAnalysis)",
    "# Save results into csv file",
    "exportPKAnalysesToCSV(pkAnalysis, filePath = \"pk-analyses.csv\") #TODO: update this path",
    "",
    sep = "\n"
  )
  rstudioapi::insertText(textTemplate)
  return(invisible())
}
