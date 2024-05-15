#' Title
#'
#' @param redlining_sf 
#' @param background_raster 
#' @param roads 
#' @param rivers 
#'
#' @return
#' @export
create_mask_and_plot <- function(redlining_sf, background_raster = ndvi$raster, roads = NULL, rivers = NULL){
  start_time <- Sys.time()  # Start timing
  
  # Validate and prepare the redlining data
  redlining_sf <- redlining_sf |>
    dplyr::filter(grade != "") |>
    sf::st_make_valid()
  
  
  bbox <- sf::st_bbox(redlining_sf)  # Get original bounding box
  
  
  expanded_bbox <- basemapR::expand_bbox(bbox, 6000, 1000)  # 
  
  expanded_bbox_poly <- 
    sf::st_as_sfc(expanded_bbox, crs = sf::st_crs(redlining_sf)) |>
    sf::st_make_valid()
  
  # Initialize an empty list to store masks
  masks <- list()
  
  # Iterate over each grade to create masks
  unique_grades <- unique(redlining_sf$grade)
  for (grade in unique_grades) {
    # Filter polygons by grade
    grade_polygons <- redlining_sf[redlining_sf$grade == grade, ]
    
    # Create an "inverted" mask by subtracting these polygons from the background
    mask <- sf::st_difference(expanded_bbox_poly, sf::st_union(grade_polygons))
    
    # Store the mask in the list with the grade as the name
    masks[[grade]] <- sf::st_sf(geometry = mask, grade = grade)
  }
  
  # Combine all masks into a single sf object
  mask_sf <- do.call(rbind, masks)
  
  # Normalize the grades so that C.2 becomes C, but correctly handle other grades
  mask_sf$grade <- ifelse(mask_sf$grade == "C.2", "C", mask_sf$grade)
  
  # Prepare the plot
  plot <- ggplot2::ggplot() +
    tidyterra::geom_spatraster(data = background_raster, aes(fill = NDVI)) +
    ggplot2::scale_fill_viridis_c(name = "NDVI", option = "viridis", direction = -1) +
    
    ggplot2::geom_sf(data = mask_sf, aes(color = grade), fill = "white", size = 0.1, show.legend = FALSE) +
    ggplot2::scale_color_manual(
      values = c("A" = "white", "B" = "white", "C" = "white", "D" = "white"), name = "Grade") +
    ggplot2::facet_wrap(~ grade, nrow = 1) +
    ggplot2::geom_sf(data = roads, alpha = 1, lwd = 0.1, color="white") +
    ggplot2::geom_sf(data = rivers, color = "white", alpha = 0.5, lwd = 1.1) +
    ggplot2::labs(title = "NDVI: Normalized Difference Vegetation Index") +
    ggplot2::theme_minimal() +
    ggplot2::coord_sf(
      xlim = c(bbox["xmin"], bbox["xmax"]), 
      ylim = c(bbox["ymin"], bbox["ymax"]), 
      expand = FALSE) + 
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      legend.position = "bottom",
      axis.text = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank())
  
  # Save the plot
  ggplot2::ggsave("redlining_mask_ndvi.png", plot, width = 10, height = 4, dpi = 600)
  
  end_time <- Sys.time()  # End timing
  runtime <- end_time - start_time
  
  # Return the plot and runtime
  return(list(plot = plot, runtime = runtime, mask_sf = mask_sf))
}
