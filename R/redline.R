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
#' @importFrom shiny checkboxGroupInput column fluidPage fluidRow
#'             isTruthy mainPanel NS observeEvent reactive
#'             reactiveVal renderPlot req selectInput shinyApp
#'             sidebarLayout sidebarPanel tagList textInput
#'             titlePanel updateSelectInput
#' @importFrom DT dataTableOutput renderDataTable
redlineServer <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # City and State from URL
    city_state <- shiny::reactive({
      progress("City-State URL", get_city_state_list_from_redlining_data,
               geourl(), shiny::req(input$year))
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
               geourl(), input$year)
    })
    
    # The `amenities()` has currently examined amenities.
    # These take time to generate, so want to update only as needed.
    amenities <- shiny::reactiveVal()
    amenity <- shiny::reactiveVal()
    reset_amenity <- function() {
      amenities(c("roads", "rivers"))
      amenity(progress("Amenity roads & rivers", get_amenities, city_data(), amenities(), NULL))
    }
    shiny::observeEvent(city_data(), {
      reset_amenity()
    })
    output$layer_choice <- shiny::renderUI({
      shiny::selectInput(ns("layer_choice"), "Amenity Layer:",
        c("food", "processed_food", "natural_habitats", "roads", "rivers", "government_buildings"))
    })
    # Plot City
    plot_city <- shiny::reactive({
      shiny::req(city_data())
      if(!all(c("roads", "rivers") %in% names(amenity())))
        reset_amenity()
      progress("Plot City", plot_city_redlining, city_data(), amenity())
    })
    plot_city_grade <- shiny::reactive({
      if("grade_plot" %in% input$checks) {
        plot_city_redlining_grade(plot_city())
      } else {
        plot_city()
      }
    })
    output$city_plot <- shiny::renderUI({
      shiny::tagList(
        shiny::h3(paste(shiny::req(input$city), "Grades")),
        shiny::renderPlot({
          if("amenity" %in% input$checks) {
            shiny::req(sflayer())
            print(sflayer()$plot)
          } else {
            print(shiny::req(plot_city_grade()))
          }
        })
      )
    })
    sflayer <- shiny::reactive({
      shiny::req(city_data(), input$layer_choice, plot_city())
      if(all(c("roads", "rivers") %in% names(amenity()))) {
        if(!(input$layer_choice %in% names(amenity()))) {
          # Update amenities() character vector
          amenities(unique(c(input$layer_choice, amenities())))
          # Update amenity() list
          amenity(progress(paste("Amenity", input$layer_choice),
                           get_amenities, city_data(), amenities(), amenity()))
        }
        progress(paste("SF Layer", input$layer_choice),
                 process_and_plot_sf_layers, city_data(), input$layer_choice, amenity(),
                 plot_city_grade())
      }
    })
    output$plot_sflayer <- shiny::renderUI({
      if("amenity" %in% input$checks) {
        shiny::req(sflayer())
        shiny::tagList(
          shiny::h3(paste("Amenity", input$layer_choice, "Plot")),
          shiny::renderPlot({
            print(sflayer()$plot)
          }))
      }
    })
    output$word_sflayer <- shiny::renderUI({
      if("wordcloud" %in% input$checks) {
        shiny::req(sflayer())
        shiny::tagList(
          shiny::h3(paste("Amenity", input$layer_choice, "Word")),
          shiny::renderPlot({
            print(create_wordclouds_by_grade(sflayer()$sf))
          }))
      }
    })
    shiny::observeEvent(cities(), {
      citlist <- cities()
      if("Denver" %in% citlist) citlist <- unique(c("Denver", citlist))
      shiny::updateSelectInput(session, "city", choices = citlist)
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
      shiny::column(3, shiny::selectInput(ns("year"), "Year:",
        choices = c("2010","2020"), selected = "2010")),
      shiny::column(3, shiny::selectInput(ns("state"), "State:",
        choices = datasets::state.abb, selected = "CO", multiple = TRUE)),
      shiny::column(6, shiny::uiOutput(ns("city")))),
    shiny::fluidRow(
      shiny::column(6, shiny::uiOutput(ns("layer_choice"))),
      shiny::column(6, shiny::checkboxGroupInput(ns("checks"), NULL, inline = TRUE,
        choices = c("By Grade?" = "grade_plot", "Amenity?" = "amenity", "WordCloud?" = "wordcloud")))),
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
#    shiny::uiOutput(ns("plot_sflayer")),
    shiny::uiOutput(ns("word_sflayer"))
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
