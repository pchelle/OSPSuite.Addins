#' @title areFilesUTF8
#' @description
#' Generalization of `ospsuite.utils::isFileUTF8()` to check multiple files.
#' @param filePaths A character vector of file paths.
#' @return Logical values
#' @keywords internal
#' @importFrom ospsuite.utils isFileUTF8
areFilesUTF8 <- function(filePaths){
  sapply(
    filePaths, 
    function(filePath) {
      ospsuite.utils::isFileUTF8(filePath)
      },
    USE.NAMES = TRUE,
    simplify = TRUE
    )
}

#' @title utfCheck
#' @description
#' Popup shiny app that displays the list of files in a selected folder
#' along with a check if the file is UTF-8 encoded.
#' Selected branches are copied to clipboard when closing app.
#'
#' @return A shiny app
#' @export
#' @import shiny
#' @import miniUI
#' @importFrom readr guess_encoding
utfCheck <- function() {
  # Shiny App UI
  ui <- miniPage(
    gadgetTitleBar(span(icon("file-circle-check"), " UTF-8 Check")),
    miniContentPanel(
      fluidPage(
        actionButton(
          "selectDirectory",
          "Select a directory",
          icon = icon("folder-open")
          ),
        br(),
        htmlOutput("selectedDirectory"),
        br(),
        tableOutput("utfTable"),
        br(),
        actionButton(
          "convert", 
          "Convert to UTF-8",
          icon = icon("repeat")
          )
      )
    )
  )
  # Shiny App Server
  server <- function(input, output, session) {
    reactiveData <- reactiveValues(
      directory = NULL,
      files = NULL, 
      isUTF = NULL
      )
    output$selectedDirectory <- renderText({
      if(is.null(reactiveData$directory)){
        return()
        }
      HTML(paste(icon("file-circle-exclamation"), reactiveData$directory))
    })
    observeEvent(input$selectDirectory, {
      selectedDirectory <- rstudioapi::selectDirectory()
      if (is.null(selectedDirectory)) {
        reactiveData$directory <- NULL
        reactiveData$files <- NULL
        reactiveData$isUTF <- NULL
        return(invisible())
      }
      reactiveData$directory <- selectedDirectory
      filesInDirectory <- setdiff(
        list.files(path = selectedDirectory),
        list.dirs(path = selectedDirectory, full.names = FALSE, recursive = FALSE)
        )
      reactiveData$files <- filesInDirectory
      reactiveData$isUTF <- areFilesUTF8(file.path(selectedDirectory, filesInDirectory))
    })
    output$utfTable <- renderTable({
      if(is.null(reactiveData$files)){
        return()
        }
      data.frame(
        File = reactiveData$files,
        UTF8 = ifelse(
          reactiveData$isUTF, 
          '<font color="forestgreen">&check;', 
          '<font color="firebrick">&cross;'
          )
      )
      },
      sanitize.text.function = identity,
      striped = TRUE,
      hover = TRUE,
      bordered = TRUE
      )
    # Convert
    observeEvent(input$convert, {
      if(is.null(reactiveData$directory)){
        return()
        }
      filesToConvert <- file.path(reactiveData$directory, reactiveData$files)
      for(fileIndex in seq_along(filesToConvert)){
        if(reactiveData$isUTF[fileIndex]){
          next
        }
        fileEncoding <- readr::guess_encoding(filesToConvert[fileIndex])
        fileContent <- readLines(filesToConvert[fileIndex])
        newFileContent <- iconv(fileContent, head(fileEncoding$encoding, 1), "UTF-8")
        writeLines(newFileContent, filesToConvert[fileIndex])
        reactiveData$isUTF[fileIndex] <- TRUE
      }
    })
    # Handle the Done button being pressed.
    observeEvent(input$done, {
      stopApp()
    })
    observeEvent(input$cancel, {
      stopApp()
    })
  }
  # Run the app
  runGadget(ui, server, viewer = dialogViewer("UTF-8 Check", width = 400))
  return(invisible())
}
