title <- "Geospatial Shiny"

ui <- geospatial::ui(title)

server <- function(input, output, session) {
  geospatial::server(input, output, session)
  
  # Allow reconnect with Shiny Server.
  session$allowReconnect(TRUE)
}

shiny::shinyApp(ui = ui, server = server)
