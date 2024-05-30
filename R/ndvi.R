#' Shiny App to Stream NDVI data
#'
#' For now, this uses the default redlining GeoJSON URL to extract
#' cities from user-selected state(s). It is possible to put in your
#' own URL, but it is tricky to find these URLs.
#' 
#' @param id identifier for shiny reactive
#' @return reactive app
#' @export
#' @rdname ndvi
#' @importFrom dplyr filter
#' @importFrom shiny column fluidPage fluidRow isTruthy mainPanel NS
#'             observeEvent reactive renderPlot req selectInput shinyApp
#'             sidebarLayout sidebarPanel tagList textInput titlePanel
#'             updateCheckboxInput updateSelectInput
#' @importFrom DT dataTableOutput renderDataTable
ndviServer <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
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
    
    output$city <- shiny::renderUI({
      shiny::selectInput(ns("city"), "Graded City:", choices = NULL)
    })
    # City Date 
    city_data <- shiny::reactive({
      shiny::req(input$city)
      progress("Load City", load_city_redlining_data, input$city)
    })
    year_ndvi <- shiny::reactive({
      citdata <- shiny::req(city_data(), input$dx, input$dy)
      progress("Year NDVI", yearly_average_ndvi, citdata, input$dx, input$dy)
    })
    output$year_ndvi <- shiny::renderUI({
      shiny::req(year_ndvi())
      shiny::renderPlot({
        print(year_ndvi()$plot)
      })
    })
    # *** Don't know exactly how to render animated GIF. ***
    # *** Check out redlining_teacher.qmd on cyverse. ***
    output$stream_ndvi <- shiny::renderUI({
      if(shiny::isTruthy(input$show_city_plot)) {
        citdata <- shiny::req(city_data())
        shiny::req(input$start_date, input$end_date)
        progress("Stream NDVI", process_satellite_data, citdata, input$start_date, input$end_date,
                 assets = c("B04", "B08"))
        #https://forum.posit.co/t/how-to-embed-videos-in-shiny/38937
      }
    })
    shiny::observeEvent(cities(), {
      citlist <- cities()
      if("Denver" %in% citlist) citlist <- unique(c("Denver", citlist))
      shiny::updateSelectInput(session, "city", choices = citlist)
    })
  })
}
#' ndvi Input
#' @param id identifier for shiny reactive
#' @return reactive input
#' @export
#' @rdname ndvi
ndviInput <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::fluidRow(
      shiny::column(4, shiny::selectInput(ns("state"), "State:",
        choices = datasets::state.abb, selected = "CO", multiple = TRUE)),
      shiny::column(8, shiny::uiOutput(ns("city")))),
    shiny::fluidRow(
      shiny::column(4, shiny::dateInput(ns("start_date"), "Start Date", "2022-05-31", "2020-01-01", "2024-01-01")),
      shiny::column(4, shiny::dateInput(ns("end_date"), "End Date", "2023-05-31", "2020-01-01", "2024-01-01")),
      shiny::column(4, shiny::checkboxInput(ns("show_city_plot"), "Show plot?"))),
    #    shiny::textInput(ns("url"), "GeoJSON URL (default ndvi if blank):")
    )
}
#' ndvi Output
#' @param id identifier for shiny reactive
#' @return reactive input
#' @export
#' @rdname ndvi
ndviOutput <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("stream_ndvi")),
    shiny::fluidRow(
      shiny::column(6, shiny::numericInput(ns("dx"), "DX", 0.01, 0.001, 0.01)),
      shiny::column(6, shiny::numericInput(ns("dy"), "DY", 0.01, 0.001, 0.01))),
    shiny::uiOutput(ns("year_ndvi"))
  )
}
#' ndvi App
#' @param title title of app
#' @return reactive app
#' @export
#' @rdname ndvi
ndviApp <- function(title = "Stream NDVI") {
  ui <- shiny::fluidPage(
    shiny::titlePanel(title),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        ndviInput("ndvi")
      ),
      shiny::mainPanel(
        ndviOutput("ndvi")
        )))
  server <- function(input, output, server) {
    ndviServer("ndvi")
  }
  shiny::shinyApp(ui, server)
}
