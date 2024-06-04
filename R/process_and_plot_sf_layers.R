#' Map an amenity over each grade
#'
#' @param object sf object 
#' @param layer2 name of amenity
#' @param amenity list of amenities 
#' @param plot previous plot if not `NULL`
#' @param color_amenity color of amenity in plot
#'
#' @return list with `ggplot` object and polygon `sf` object
#' @export
#' @importFrom dplyr filter
#' @importFrom ggplot2 element_blank element_rect geom_sf
#'             ggplot ggsave labs theme theme_minimal 
#' @importFrom ggthemes theme_tufte
#' @importFrom sf st_buffer st_intersects st_make_valid st_simplify
#'
process_and_plot_sf_layers <- function(object, layer2, amenity, plot = NULL,
                                       color_amenity = "orange") {
  # layer2 is character string, find it in `amenity` list
  if(is.character(layer2))
    layer2 <- amenity[[layer2]]
  
  # Make geometries valid
  object <- sf::st_make_valid(object)
  layer2 <- sf::st_make_valid(layer2)
  
  # Optionally, simplify geometries to remove duplicate vertices
  object <- sf::st_simplify(object, preserveTopology = TRUE) |>
    dplyr::filter(grade != "")
  
  # Prepare a list to store results
  results <- list()
  
  # Loop through each grade and perform operations
  for (grade in c("A", "B", "C", "D")) {
    # Filter object for current grade
    object_grade <- object[object$grade == grade, ]
    
    # Buffer the geometries of the current grade
    buffered_object_grade <- sf::st_buffer(object_grade, dist = 500)
    
    # Intersect with the second layer
    intersections <- sf::st_intersects(layer2, buffered_object_grade, sparse = FALSE)
    selected_polygons <- layer2[rowSums(intersections) > 0, ]
    
    # Add a new column to store the grade information
    selected_polygons$grade <- grade
    
    # Store the result
    results[[grade]] <- selected_polygons
  }
  
  # Combine all selected polygons from different grades into one sf object
  final_selected_polygons <- do.call(rbind, results)
  
  if(is.null(plot)) {
    # Define colors for the grades
    grade_colors <- c("A" = "grey", "B" = "grey", "C" = "grey", "D" = "grey")
    
    # Create the plot
    plot <- ggplot2::ggplot() +
      ggplot2::geom_sf(data = amenity$roads, alpha = 0.05, lwd = 0.1) +
      ggplot2::geom_sf(data = amenity$rivers, color = "blue", alpha = 0.1, lwd = 1.1) +
      ggplot2::geom_sf(data = object, fill = "grey", color = "grey", size = 0.1) +
      facet_wrap(~ grade, nrow = 1) +
      facet_wrap(~ grade, nrow = 1) +
      #scale_fill_manual(values = grade_colors) +
      #scale_color_manual(values = grade_colors) +
      ggplot2::theme_minimal() +
      ggplot2::labs(fill = 'HOLC Grade') +
      ggthemes::theme_tufte() +
      ggplot2::theme(
        plot.background = ggplot2::element_rect(fill = "white", color = NA),
        panel.background = ggplot2::element_rect(fill = "white", color = NA),
        legend.position = "none",
        axis.text = ggplot2::element_blank(),
        axis.title = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank(),
        panel.grid.major = ggplot2::element_blank(),
        panel.grid.minor = ggplot2::element_blank())
  }
  plot <- plot +
    ggplot2::geom_sf(data = final_selected_polygons,
                     fill = color_amenity,
                     color = color_amenity,
                     size = 0.1)
    
  # Return the plot for optional further use
  return(list(plot=plot, sf = final_selected_polygons))
}
