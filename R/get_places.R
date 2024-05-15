#' Title
#'
#' @param polygon_layer 
#' @param type 
#'
#' @return
#' @export
#'
#' @examples
get_places <- function(polygon_layer, type = "food") {
  # Check if the input is an sf object
  if (!inherits(polygon_layer, "sf")) {
    stop("The provided object is not an sf object.")
  }
  
  # Create a bounding box from the input sf object
  bbox_here <- sf::st_bbox(polygon_layer) |>
    sf::st_as_sfc()
  
  if (type == "roads") {
    my_layer <- "lines"
    my_query <- "SELECT * FROM lines WHERE (
                 highway IN ('motorway', 'trunk', 'primary', 'secondary', 'tertiary'))"
    title <- "Major roads"
  }
  
  if (type == "rivers") {
    my_layer <- "lines"
    my_query <- "SELECT * FROM lines WHERE (
                 waterway IN ('river'))"
    title <- "Major rivers"
  }
  
  # Use the bbox to get data with oe_get(), specifying the desired layer and a custom SQL query for fresh food places
  tryCatch({
    places <- osmextract::oe_get(
      place = bbox_here,
      layer = my_layer,
      query = my_query,
      quiet = TRUE
    )
    
    places <- sf::st_make_valid(places)
    
    # Crop the data to the bounding box
    cropped_places <- sf::st_crop(places, bbox_here)
    
    # Plotting the cropped fresh food places
    plot <- ggplot2::ggplot(data = cropped_places) +
      ggplot2::geom_sf(fill="cornflowerblue", color="cornflowerblue") +
      ggplot2::ggtitle(title) +
      ggthemes::theme_tufte() +
      ggplot2::theme(
        legend.position = "none",  # Optionally hide the legend
        axis.text = ggplot2::element_blank(),     # Remove axis text
        axis.title = ggplot2::element_blank(),    # Remove axis titles
        axis.ticks = ggplot2::element_blank(),    # Remove axis ticks
        plot.background = ggplot2::element_rect(fill = "white", color = NA),  # Set the plot background to white
        panel.background = ggplot2::element_rect(fill = "white", color = NA),  # Set the panel background to white
        panel.grid.major = ggplot2::element_blank(),  # Remove major grid lines
        panel.grid.minor = ggplot2::element_blank()) 
    
    # Save the plot as a PNG file
    png_filename <- paste0(title, "_", Sys.Date(), ".png")
    ggplot2::ggsave(png_filename, plot, width = 10, height = 8, units = "in")
    
    # Return the cropped dataset
    return(cropped_places)
  }, error = function(e) {
    stop("Failed to retrieve or plot data: ", e$message)
  })
}
