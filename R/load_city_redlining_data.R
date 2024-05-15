#' Load and filter redlining data by city
#'
#' @param city_name 
#'
#' @return
#' @export
#'
#' @examples
load_city_redlining_data <- function(city_name) {
  # URL to the GeoJSON data
  url <- "https://raw.githubusercontent.com/americanpanorama/mapping-inequality-census-crosswalk/main/MIv3Areas_2010TractCrosswalk.geojson"
  
  # Read the GeoJSON file into an sf object
  redlining_data <- sf::read_sf(url)
  
  # Filter the data for the specified city and non-empty grades
  city_redline <- redlining_data |>
    dplyr::filter(city == city_name)
  
  # Return the filtered data
  return(city_redline)
}
