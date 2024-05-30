#' Stream NDVI data
#'
#' Function to process satellite data based on an SF polygon's extent
#' @param polygon_layer 
#' @param start_date 
#' @param end_date 
#' @param assets 
#' @param fps 
#' @param output_file 
#' @param use_mask
#'
#' @return `difftime` object
#' @export
#' @importFrom colorspace sequential_hcl
#' @importFrom sf st_bbox
#' @importFrom rstac post_request stac stac_search
#' @importFrom gdalcubes animate apply_pixel cube_view image_mask
#'             raster_cube select_bands stac_image_collection
#'
process_satellite_data <- function(polygon_layer, start_date, end_date, assets, fps = 1, output_file = "anim.gif",
                                   use_mask = FALSE) {
  # Record start time
  start_time <- Sys.time()
  
  # Calculate the bbox from the polygon layer
  bbox <- sf::st_bbox(polygon_layer)
  
  # Use stacR to search for Sentinel-2 images within the bbox and date range
  items <- rstac::stac("https://earth-search.aws.element84.com/v0") |>
    rstac::stac_search(
      collections = "sentinel-s2-l2a-cogs",
      bbox = c(bbox["xmin"], bbox["ymin"], bbox["xmax"], bbox["ymax"]),
      datetime = paste(start_date, end_date, sep = "/"),
      limit = 500) |> 
    rstac::post_request()
  
  # Calculate NDVI and create an animation
  ndvi_col <- function(n) {
    rev(colorspace::sequential_hcl(n, "Green-Yellow"))
  }
  
  # Optional mask for Sentinel-2 image quality if `use_mask = TRUE`
  mask <- NULL
  if(use_mask)
    mask = gdalcubes::image_mask("SCL", values = c(3, 8, 9))
  
  outfile <- gdalcubes::raster_cube(
    # Create a collection of images filtering by cloud cover
    col <- gdalcubes::stac_image_collection(
      items$features,
      asset_names = assets,
      property_filter = function(x) {x[["eo:cloud_cover"]] < 30}),
    # Define a view for processing the data
    gdalcubes::cube_view(
      srs = "EPSG:4326", 
      extent = list(t0 = start_date, t1 = end_date,
                    left = bbox["xmin"], right = bbox["xmax"], 
                    top = bbox["ymax"], bottom = bbox["ymin"]),
      dx = 0.001, dy = 0.001, dt = "P1M", 
      aggregation = "median", resampling = "bilinear"),
    mask) |>
    gdalcubes::select_bands(c("B04", "B08")) |>
    gdalcubes::apply_pixel("(B08-B04)/(B08+B04)", "NDVI") |>
    gdalcubes::animate(col = ndvi_col, zlim = c(-0.2, 1), key.pos = 1, save_as = output_file, fps = fps)
  
  # Calculate processing time
  end_time <- Sys.time()
  processing_time <- difftime(end_time, start_time)
  
  list(timegif = outfile, processing_time = processing_time)
}
