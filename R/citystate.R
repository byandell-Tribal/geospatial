#' Shiny App of cities with HOLC data
#'
#' For now, this uses the default redlining GeoJSON URL to extract
#' cities from user-selected state(s). It is possible to put in your
#' own URL, but it is tricky to find these URLs.
#' 
#' @param id identifier for shiny reactive
#' @return reactive app
#' @export
#' @rdname citystate
#' @importFrom dplyr filter
#' @importFrom shiny checkboxGroupInput column fluidPage fluidRow
#'             isTruthy mainPanel NS observeEvent reactive
#'             reactiveVal renderPlot req selectInput shinyApp
#'             sidebarLayout sidebarPanel tagList textInput
#'             titlePanel updateSelectInput
#' @importFrom DT dataTableOutput renderDataTable
citystateServer <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # City and State from URL
    city_state <- shiny::reactive({
      progress("City-State URL", get_city_state_list_from_redlining_data,
               geourl(), shiny::req(input$year), graded = FALSE)
    })
    city_states <- shiny::reactive({
      dplyr::filter(shiny::req(city_state()),
                    state %in% input$state)
    })
    cities <- shiny::reactive({
      shiny::req(city_states())$city
    })
    
    output$city <- shiny::renderUI({
      shiny::selectInput(ns("city"), "City:", choices = NULL)
    })
    shiny::observeEvent(cities(), {
      citlist <- cities()
      if("Denver" %in% citlist) citlist <- unique(c("Denver", citlist))
      shiny::updateSelectInput(session, "city", selected = "", choices = citlist)
    })
    geourl <- shiny::reactive({
      if(shiny::isTruthy(input$url))
        input$url
      else
        NULL
    })
    # City Data
    city_data <- shiny::reactive({
      shiny::req(input$city, input$year)
      progress(paste("Load", input$city), load_city_redlining_data, input$city,
               geourl(), input$year, graded = FALSE)
    })
    
    # The `amenities()` has currently examined amenities.
    # These take time to generate, so want to update only as needed.
    amenities <- shiny::reactiveVal()
    amenity <- shiny::reactiveVal()
    reset_amenity <- function() {
      amenities(c("roads", "rivers"))
      amenity(progress("Amenity roads & rivers", get_amenities,
                       shiny::req(city_data()), amenities(), NULL))
    }
    shiny::observeEvent(city_data(), {
      reset_amenity()
    })
    # Plot City
    plot_city <- shiny::reactive({
      shiny::req(city_data())
      if(!all(c("roads", "rivers") %in% names(amenity())))
        reset_amenity()
      progress("Plot City", plot_city_redlining, city_data(), amenity())
    })
    output$city_plot <- shiny::renderPlot({
      print(shiny::req(plot_city()))
    })
    output$city_state <- DT::renderDataTable(
      shiny::req(city_states()),
      escape = FALSE,
      options = list(scrollX = TRUE, pageLength = 10))
    output$outstuff <- shiny::renderUI({
      shiny::tagList(
        shiny::h3("City Table"),
        DT::dataTableOutput(ns("city_state")),
        if(shiny::isTruthy(input$showplot)) {
          shiny::tagList(
            shiny::h3("City Plot"),
            shiny::plotOutput(ns("city_plot"))
          )
        }
      )
    })
  })
}
#' citystate Input
#' @param id identifier for shiny reactive
#' @return reactive input
#' @export
#' @rdname citystate
citystateInput <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::fluidRow(
      shiny::column(3, shiny::selectInput(ns("year"), "Year:",
        choices = c("2010","2020"), selected = "2010")),
      shiny::column(3, shiny::selectInput(ns("state"), "State:",
        choices = datasets::state.abb, selected = "CO", multiple = TRUE)),
      shiny::column(6, shiny::uiOutput(ns("city")))
    ),
    shiny::checkboxInput(ns("showplot"), "Plot?")
  )
}
#' citystate Output
#' @param id identifier for shiny reactive
#' @return reactive input
#' @export
#' @rdname citystate
citystateOutput <- function(id) {
  ns <- shiny::NS(id)
  shiny::uiOutput(ns("outstuff"))
}
#' citystate App
#' @param title title of app
#' @return reactive app
#' @export
#' @rdname citystate
citystateApp <- function(title = "Redlining") {
  ui <- shiny::fluidPage(
    shiny::titlePanel(title),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        citystateInput("citystate")
      ),
      shiny::mainPanel(
        citystateOutput("citystate")
        )))
  server <- function(input, output, server) {
    citystateServer("citystate")
  }
  shiny::shinyApp(ui, server)
}
