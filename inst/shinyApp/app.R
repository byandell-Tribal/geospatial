devtools::install_github('Chrisjb/basemapR')
#devtools::install_github('byandell/geospatial')

title <- "Redlining"

ui <- shiny::fluidPage(
  shiny::titlePanel(title),
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      geospatial::redlineInput("redline")
    ),
    shiny::mainPanel(
      geospatial::redlineOutput("redline")
    )))

server <- function(input, output, server) {
  geospatial::redlineServer("redline")
}

shiny::shinyApp(ui, server)
