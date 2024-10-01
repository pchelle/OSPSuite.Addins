#' @title viewReport
#' @description
#' Open a markdown or docx report from `{ospsuite.reportingengine}` from user default software.
#' @param filePath The path to the report file. If `NULL`, a file dialog will be opened.
#' @return filePath The path to the report file.
#' @export
viewReport <- function(filePath = NULL) {
  if(is.null(filePath)){
    filePath <- rstudioapi::selectFile(filter = "(.md|.docx)")
  }
  if(is.null(filePath)){
    return(invisible())
    }
  browseURL(filePath)
  return(invisible(filePath))
}

#' @title copyQualificationTemplate
#' @description
#' Copy and open the `{ospsuite.reportingengine}` template 
#' for qualification workflows in current project directory.
#' @export
copyQualificationTemplate <- function() {
  templateFile <- "qualification-workflow-template.R"
  if(file.exists(templateFile)){
    cli::cli_warn(c(
      "Template file already exists.",
      i = "Previous template file was overwritten."
      ))
  }
  file.copy(
    from = system.file("extdata", templateFile, package = "ospsuite.reportingengine"), 
    to = templateFile, 
    overwrite = TRUE
  )
  rstudioapi::documentOpen(path = templateFile)
  return(invisible())
}