#' Stream year average NDVI
#'
#' @param polygon_layer 
#' @param output_file 
#' @param dx 
#' @param dy 
#'
#' @return
#' @export
yearly_average_ndvi <- function(polygon_layer, output_file = "ndvi.png", dx = 0.01, dy = 0.01) {
  # Record start time
  start_time <- Sys.time()
  
  # Calculate the bbox from the polygon layer
  bbox <- sf::st_bbox(polygon_layer)
  
  s = rstac::stac("https://earth-search.aws.element84.com/v0")
  
  # Search for Sentinel-2 images within the bbox for June
  items <- s |> rstac::stac_search(
    collections = "sentinel-s2-l2a-cogs",
    bbox = c(bbox["xmin"], bbox["ymin"], bbox["xmax"], bbox["ymax"]),
    datetime = "2023-01-01/2023-12-31",
    limit = 500) |> 
    rstac::post_request()
  
  # Create a collection of images filtering by cloud cover
  col <- gdalcubes::stac_image_collection(
    items$features, asset_names = c("B04", "B08"),
    property_filter = function(x) {x[["eo:cloud_cover"]] < 80})
  
  # Define a view for processing the data specifically for June
  v <- gdalcubes::cube_view(
    srs = "EPSG:4326", 
    extent = list(t0 = "2023-01-01", t1 = "2023-12-31",
                  left = bbox["xmin"], right = bbox["xmax"], 
                  top = bbox["ymax"], bottom = bbox["ymin"]),
    dx = dx, dy = dy, dt = "P1Y", 
    aggregation = "median", resampling = "bilinear")
  
  # Process NDVI
  ndvi_rast <- gdalcubes::raster_cube(col, v) |>
    gdalcubes::select_bands(c("B04", "B08")) |>
    gdalcubes::apply_pixel("(B08-B04)/(B08+B04)", "NDVI") |>
    gdalcubes::write_tif() |>
    terra::rast()
  
  
  # Convert terra Raster to ggplot using tidyterra
  ndvi_plot <- ggplot2::ggplot() +
    tidyterra::geom_spatraster(data = ndvi_rast,
                               ggplot2::aes(fill = NDVI)) +
    ggplot2::scale_fill_viridis_c(option = "viridis", direction = -1, name = "NDVI") +
    ggplot2::labs(title = "NDVI mean for 2023") +
    ggplot2::theme_minimal() +
    ggplot2::coord_sf() +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      legend.position = "right",
      axis.text = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank()) 
  
  # Save the plot as a high-resolution PNG file
  ggplot2::ggsave(output_file, ndvi_plot, width = 10, height = 8, dpi = 600)
  
  # Calculate processing time
  end_time <- Sys.time()
  processing_time <- difftime(end_time, start_time)
  
  # Return the plot and processing time
  return(list(plot = ndvi_plot, processing_time = processing_time, raster = ndvi_rast))
}
