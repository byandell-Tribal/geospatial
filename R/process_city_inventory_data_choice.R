#' Choose dataset and pass patial polygon for analysis
#'
#' The function process_city_inventory_data_choice allows users to select from a predefined set of datasets for processing. It takes two arguments: choice, an integer that specifies the dataset to process, and polygon_layer, an sf object that represents the geographic area to be analyzed. The choice argument should be a number between 1 and 7, each corresponding to different types of city data:
#' \enumerate{
#'   \item **Tree Density** - Tree inventory data.
#'   \item **Traffic Accidents Density** - Traffic accidents data.
#'   \item **Instream Sampling Sites Density** - Environmental sampling sites data.
#'   \item **Soil Samples Density** - Soil sample data.
#'   \item **Public Art Density** - Public art locations.
#'   \item **Liquor Licenses Density** - Liquor license data.
#'   \item **Crime Density** - City crime data.
#' }
#' 
#' @param choice 
#' @param polygon_layer 
#' @param source 
#' @return list with `ggplot` object and trees `sf` object
#' @export
#' 
process_city_inventory_data_choice <- function(choice, polygon_layer,
  source = "https://www.denvergov.org/media/gis/DataCatalog") {
  # Define the dataset choices
  datasets <- list(
    list(address = file.path(source, "tree_inventory/shape/tree_inventory.zip"),
         inner_file = "tree_inventory.shp",
         output_filename = "Denver_tree_inventory_2023",
         variable_label = "Tree Density"),
    list(address = file.path(source, "traffic_accidents/shape/traffic_accidents.zip"),
         inner_file = "traffic_accidents.shp",
         output_filename = "Denver_traffic_accidents",
         variable_label = "Traffic Accidents Density"),
    list(address = file.path(source, "instream_sampling_sites/shape/instream_sampling_sites.zip"),
         inner_file = "instream_sampling_sites.shp",
         output_filename = "instream_sampling_sites",
         variable_label = "Instream Sampling Sites Density"),
    list(address = file.path(source, "soil_samples/shape/soil_samples.zip"),
         inner_file = "soil_samples.shp",
         output_filename = "Soil_samples",
         variable_label = "Soil Samples Density"),
    list(address = file.path(source, "public_art/shape/public_art.zip"),
         inner_file = "public_art.shp",
         output_filename = "Public_art",
         variable_label = "Public Art Density"),
    list(address = file.path(source, "liquor_licenses/shape/liquor_licenses.zip"),
         inner_file = "liquor_licenses.shp",
         output_filename = "liquor_licenses",
         variable_label = "Liquor Licenses Density"),
    list(address = file.path(source, "crime/shape/crime.zip"),
         inner_file = "crime.shp",
         output_filename = "Crime",
         variable_label = "Crime Density")
  )
  
  # Validate input
  if (choice < 1 || choice > length(datasets)) {
    stop("Invalid choice. Please enter a number between 1 and 7.")
  }
  
  # Get the selected dataset information
  dataset <- datasets[[choice]]
  
  # Call the original function
  result <- process_city_inventory_data(
    address = dataset$address,
    inner_file = dataset$inner_file,
    polygon_layer = polygon_layer,
    output_filename = dataset$output_filename,
    variable_label = dataset$variable_label
  )
  
  return(result)
}
