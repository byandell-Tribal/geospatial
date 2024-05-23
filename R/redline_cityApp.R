#' Shiny App of cities with HOLC data
#'
#' For now, this uses the default redlining GeoJSON URL to extract
#' cities from user-selected state(s). It is possible to put in your
#' own URL, but it is tricky to find these URLs.
#' 
#' @return reactive app
#' @export
#' @importFrom dplyr filter
#' @importFrom shiny bootstrapPage isTruthy reactive renderPlot req selectInput
#'             shinyApp textInput
#' @importFrom DT dataTableOutput renderDataTable
redline_cityApp <- function() {
  ui <- shiny::bootstrapPage(
    shiny::selectInput("state", "State:",
                       choices = datasets::state.abb,
                       selected = "CO", multiple = TRUE),
    DT::dataTableOutput("city_state"),
    shiny::uiOutput("city_plot"),
    shiny::textInput("url", "GeoJSON URL (default redline if blank):")
  )
  server <- function(input, output, session) {
    # City and State from URL
    city_state <- shiny::reactive({
      if(shiny::isTruthy(input$url))
        progress("City-State URL", get_city_state_list_from_redlining_data, input$url)
      else
        progress("City-State", get_city_state_list_from_redlining_data)
    })
    city_states <- shiny::reactive({
      dplyr::filter(shiny::req(city_state()),
                    state %in% input$state)
    })
    cities <- shiny::reactive({
      shiny::req(city_states())$city
    })
    output$city_state <- DT::renderDataTable(
      shiny::req(city_states()),
      escape = FALSE,
      options = list(scrollX = TRUE, pageLength = 10))
    
    # Plot City
    output$city_plot <- shiny::renderUI({
      shiny::tagList(
        shiny::selectInput("city", "City:", choices = NULL),
        shiny::renderPlot({
          citdata <- shiny::req(city_data())
          progress("Plot City", plot_city_redlining, citdata)
        })
      )
    })
    shiny::observeEvent(cities(), {
      citlist <- cities()
      if("Denver" %in% citlist) citlist <- unique(c("Denver", citlist))
      shiny::updateSelectInput(session, "city", choices = citlist)
    })
    city_data <- shiny::reactive({
      load_city_redlining_data(shiny::req(input$city))
    })
  }
  shiny::shinyApp(ui, server)
}
