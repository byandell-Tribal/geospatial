#' List cities where HOLC data are available
#'
#' Function to get a list of unique cities and states from the redlining data
#' 
#' @param url URL to the GeoJSON data
#' 
#' @return object of class `sf`
#' @export
#' @importFrom dplyr arrange distinct select
#' @importFrom sf read_sf st_set_geometry
#' 
get_city_state_list_from_redlining_data <- function(
    url = "https://raw.githubusercontent.com/americanpanorama/mapping-inequality-census-crosswalk/main/MIv3Areas_2010TractCrosswalk.geojson") {
  
  # Read the GeoJSON file into an sf object
  redlining_data <- tryCatch({
    sf::read_sf(url)
  }, error = function(e) {
    stop("Error reading GeoJSON data: ", e$message)
  })
  
  # Check for the existence of 'city' and 'state' columns
  if (!all(c("city", "state") %in% names(redlining_data))) {
    stop("The required columns 'city' and/or 'state' do not exist in the data.")
  }
  
  # Extract a unique list of city and state pairs without the geometries
  city_state_df <- redlining_data |>
    dplyr::select(city, state) |>
    sf::st_set_geometry(NULL) |>  # Drop the geometry to avoid issues with invalid shapes
    dplyr::distinct(city, state) |>
    dplyr::arrange(state, city )  # Arrange the list alphabetically by state, then by city
  
  # Return the dataframe of unique city-state pairs
  return(city_state_df)
}
#' Shiny App of cities with HOLC data
#'
#' For now, this uses the default redlining GeoJSON URL to extract
#' cities from user-selected state(s). It is possible to put in your
#' own URL, but it is tricky to find these URLs.
#' 
#' @return reactive app
#' @export
#' @rdname get_city_state_list_from_redlining_data
#' @importFrom dplyr filter
#' @importFrom shiny bootstrapPage reactive selectInput shinyApp textInput
#' @importFrom DT dataTableOutput renderDataTable
redline_city_stateApp <- function() {
  ui <- shiny::bootstrapPage(
    shiny::selectInput("state", "State:",
                       choices = datasets::state.abb,
                       selected = "CO", multiple = TRUE),
    DT::dataTableOutput("city_state"),
    shiny::textInput("url", "GeoJSON URL (default redline if blank):")
  )
  server <- function(input, output, session) {
    city_state <- shiny::reactive({
      if(shiny::isTruthy(input$url))
        get_city_state_list_from_redlining_data(input$url)
      else
        get_city_state_list_from_redlining_data()
    })
    output$city_state <- DT::renderDataTable(
      dplyr::filter(shiny::req(city_state()),
                    state %in% input$state),
      escape = FALSE,
      options = list(scrollX = TRUE, pageLength = 10))
  }
  shiny::shinyApp(ui, server)
}
