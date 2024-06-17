#' List cities where HOLC data are available
#'
#' Function to get a list of unique cities and states from the redlining data.
#' See <https://github.com/americanpanorama/mapping-inequality-census-crosswalk>
#' for panorama files.
#' 
#' @param url URL to the GeoJSON data (redline default if `NULL`)
#' @param year year for GeoJSON data ("2010" or "2020")
#' @param graded limit to graded cities if `TRUE`
#' 
#' @return object of class `sf`
#' @export
#' @importFrom dplyr arrange as_tibble count distinct filter select
#' @importFrom sf read_sf st_set_geometry
#' @importFrom rlang .data
#' 
get_city_state_list_from_redlining_data <- function(
    url = NULL,
    year = c("2010","2020"),
    graded = TRUE) {
  
  # Read the GeoJSON file into an sf object
  redlining_data <- tryCatch({
    sf::read_sf(url_crosswalk(url, year))
  }, error = function(e) {
    stop("Error reading GeoJSON data: ", e$message)
  })
  
  # Check for the existence of 'city' and 'state' columns
  if (!all(c("city", "state") %in% names(redlining_data))) {
    stop("The required columns 'city' and/or 'state' do not exist in the data.")
  }
  
  # Extract a unique list of city and state pairs without the geometries
  city_state_df <- redlining_data |>
    sf::st_set_geometry(NULL) |>  # Drop the geometry to avoid issues with invalid shapes
    # Includes grades A,B,C,D only
    select(city, state, grade) |>
    dplyr::mutate(grade = ifelse(is.na(.data$grade), "", .data$grade),
                  grade = stringr::str_trim(.data$grade)) |>
    dplyr::distinct(.data$city, .data$state, .data$grade) |>
    dplyr::group_by(.data$city, .data$state) |>
    dplyr::summarize(grade = paste(sort(.data$grade), collapse = "")) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$state, .data$city )  # Arrange the list alphabetically by state, then by city
  
  if(graded)
    city_state_df <- dplyr::filter(city_state_df, .data$grade != "")
  
  # Return the dataframe of unique city-state pairs
  return(city_state_df)
}
