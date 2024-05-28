#' Shiny App of cities with HOLC data
#'
#' For now, this uses the default redlining GeoJSON URL to extract
#' cities from user-selected state(s). It is possible to put in your
#' own URL, but it is tricky to find these URLs.
#' 
#' @param id identifier for shiny reactive
#' @return reactive app
#' @export
#' @rdname redline
#' @importFrom dplyr filter
#' @importFrom shiny column fluidPage fluidRow isTruthy mainPanel NS
#'             observeEvent reactive renderPlot req selectInput shinyApp
#'             sidebarLayout sidebarPanel tagList textInput titlePanel
#'             updateCheckboxInput updateSelectInput
#' @importFrom DT dataTableOutput renderDataTable
redlineServer <- function(id) {
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
      shiny::selectInput(ns("city"), "City with Grades A,B,C,D:", choices = NULL)
    })
    # Table City State
    output$show_city_state <- shiny::renderUI({
      if(shiny::isTruthy(input$show_city_state))
         DT::dataTableOutput(ns("city_state"))
    })
    # Plot City
    city_data <- shiny::reactive({
      shiny::req(input$city)
      progress("Load City", load_city_redlining_data, input$city)
    })
    plot_city <- shiny::reactive({
      if(shiny::isTruthy(input$show_city_plot)) {
        citdata <- shiny::req(city_data())
        progress("Plot City", plot_city_redlining, citdata)
      }
    })
    output$city_plot <- shiny::renderUI({
      shiny::req(plot_city())
      shiny::renderPlot({
        if(shiny::isTruthy(input$grade_plot)) {
          print(plot_city_redlining_grade(plot_city()))
        } else {
          print(plot_city())
        }
      })
    })
    shiny::observeEvent(cities(), {
      citlist <- cities()
      if("Denver" %in% citlist) citlist <- unique(c("Denver", citlist))
      shiny::updateSelectInput(session, "city", choices = citlist)
    })
    shiny::observeEvent(input$city, {
      browser()
      shiny::updateCheckboxInput(session, "show_city_plot", value = FALSE)
    })
  })
}
#' Redline Input
#' @param id identifier for shiny reactive
#' @return reactive input
#' @export
#' @rdname redline
redlineInput <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::fluidRow(
      shiny::column(4, shiny::selectInput(ns("state"), "State:",
        choices = datasets::state.abb, selected = "CO", multiple = TRUE)),
      shiny::column(8, shiny::uiOutput(ns("city")))),
    shiny::fluidRow(
      shiny::column(4, shiny::checkboxInput(ns("show_city_state"), "Show Table?")),
      shiny::column(4, shiny::checkboxInput(ns("show_city_plot"), "Show plot?")),
      shiny::column(4, shiny::checkboxInput(ns("grade_plot"), "Plot by Grade?"))),
#    shiny::textInput(ns("url"), "GeoJSON URL (default redline if blank):")
    )
}
#' Redline Output
#' @param id identifier for shiny reactive
#' @return reactive input
#' @export
#' @rdname redline
redlineOutput <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("city_plot")),
    shiny::uiOutput(ns("show_city_state"))
  )
}
#' Redline App
#' @param title title of app
#' @return reactive app
#' @export
#' @rdname redline
redlineApp <- function(title = "Redlining") {
  ui <- shiny::fluidPage(
    shiny::titlePanel(title),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        redlineInput("redline")
      ),
      shiny::mainPanel(
        redlineOutput("redline")
        )))
  server <- function(input, output, server) {
    redlineServer("redline")
  }
  shiny::shinyApp(ui, server)
}
