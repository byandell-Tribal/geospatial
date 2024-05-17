#' List cities where HOLC data are available
#'
#' Function to get a list of unique cities and states from the redlining data
#' @return
#' @export
#'
#' @examples
get_city_state_list_from_redlining_data <- function() {
  # URL to the GeoJSON data
  url <- "https://raw.githubusercontent.com/americanpanorama/mapping-inequality-census-crosswalk/main/MIv3Areas_2010TractCrosswalk.geojson"
  
  # Read the GeoJSON file into an sf object
  redlining_data <- tryCatch({
    read_sf(url)
  }, error = function(e) {
    stop("Error reading GeoJSON data: ", e$message)
  })
  
  # Check for the existence of 'city' and 'state' columns
  if (!all(c("city", "state") %in% names(redlining_data))) {
    stop("The required columns 'city' and/or 'state' do not exist in the data.")
  }
  
  # Extract a unique list of city and state pairs without the geometries
  city_state_df <- redlining_data %>%
    select(city, state) %>%
    st_set_geometry(NULL) %>%  # Drop the geometry to avoid issues with invalid shapes
    distinct(city, state) %>%
    arrange(state, city )  # Arrange the list alphabetically by state, then by city
  
  # Return the dataframe of unique city-state pairs
  return(city_state_df)
}
