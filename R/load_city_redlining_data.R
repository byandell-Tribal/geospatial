#' Stream HOLC data from a city
#' 
#' Load and filter redlining data by city
#'
#' @param city_name 
#' @param url URL for data (redline default if `NULL`)
#' @param year year for data extraction (if `url` is `NULL`)
#' @param graded limit to graded cities if `TRUE`
#' @return object of class `sf`
#' @export
#' @importFrom dplyr filter mutate
#' @importFrom rlang .data
#' @importFrom sf read_sf
#'
load_city_redlining_data <- function(city_name,
                                     url = NULL,
                                     year = c("2010","2020"),
                                     graded = TRUE) {
  # Read the GeoJSON file into an sf object
  redlining_data <- sf::read_sf(url_crosswalk(url, year))
  
  # Filter the data for the specified city and non-empty grades
  city_redline <- redlining_data |>
    dplyr::filter(.data$city == city_name) |>
    dplyr::mutate(grade = stringr::str_trim(.data$grade))
  if(graded)
    city_redline <- dplyr::filter(city_redline,
                                  !is.na(.data$grade), .data$grade != "")
  
  # Return the filtered data
  return(city_redline)
}
# URL to the GeoJSON data
url_crosswalk <- function(url = NULL, year = c("2010","2020")) {
  if(!is.null(url))
    return(url)
  
  year <- match.arg(year)
  file.path(
    "https://raw.githubusercontent.com",
    "americanpanorama",
    "mapping-inequality-census-crosswalk",
    paste0("main/MIv3Areas_", year, "TractCrosswalk.geojson"))
}
