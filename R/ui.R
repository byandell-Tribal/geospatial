#' Shiny UI for geospatial Package
#'
#' @return reactive UI
#' @export
#' @importFrom shiny bootstrapPage
ui <- function() {
  shiny::bootstrapPage(
    
    geyserInput("geyser"), 
    
    geyserOutput("geyser"),
    
    # Display this only if the density is shown
    geyserUI("geyser")
  )
}
  