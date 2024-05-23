#' Shiny Server for geospatial Package
#'
#' @param input 
#' @param output 
#' @param session 
#'
#' @return reactive server
#' @export
#' @importFrom shiny NS renderUI
#' @importFrom graphics hist
#'
#' @examples
server <- function(input, output, session) {
  geyser("geyserApp")
}
