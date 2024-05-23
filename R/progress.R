#' Progress Bar
#'
#' @param messagename 
#' @param functionname 
#' @param ... 
#' @return return from call to `functionname` with arguments `...`
#' @export
#' @importFrom shiny setProgress withProgress
progress <- function(messagename = "", functionname, ...) {
  shiny::withProgress(
    message = paste(messagename, 'calculations in progress'),
    detail = 'This may take a while...',
    value = 0.5,
    { 
      out <- functionname(...)
      shiny::setProgress(
        message = "Done",
        value = 1)
    })
  out
}
