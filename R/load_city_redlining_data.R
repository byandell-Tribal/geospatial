#' Stream HOLC data from a city
#' 
#' Load and filter redlining data by city
#'
#' @param city_name 
#' @return object of class `sf`
#' @export
#' @importFrom dplyr filter mutate
#' @importFrom rlang .data
#' @importFrom sf read_sf
#'
load_city_redlining_data <- function(city_name) {
  # URL to the GeoJSON data
  url <- "https://raw.githubusercontent.com/americanpanorama/mapping-inequality-census-crosswalk/main/MIv3Areas_2010TractCrosswalk.geojson"
  
  # Read the GeoJSON file into an sf object
  redlining_data <- sf::read_sf(url)
  
  # Filter the data for the specified city and non-empty grades
  city_redline <- redlining_data |>
    dplyr::filter(.data$city == city_name) |>
    dplyr::mutate(grade = stringr::str_trim(.data$grade)) |>
    dplyr::filter(!is.na(.data$grade), .data$grade != "")
  
  # Return the filtered data
  return(city_redline)
}
