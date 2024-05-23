#' Shiny Server for geospatial Package
#'
#' @param input,output,session shiny server reactives
#' @return reactive server
#' @export
server <- function(input, output, session) {
  geyserServer("geyser")
}
