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
