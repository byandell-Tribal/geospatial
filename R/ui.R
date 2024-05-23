#' Shiny UI for geospatial Package
#'
#' @param title title for app
#' @return reactive UI
#' @export
#' @importFrom shiny bootstrapPage
ui <- function(title) {
  shiny::bootstrapPage(
    
    geyserInput("geyser"), 
    
    geyserOutput("geyser"),
    
    # Display this only if the density is shown
    geyserUI("geyser")
  )
}
  