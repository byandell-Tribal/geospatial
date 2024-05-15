#' Title
#'
#' @param layer1 
#' @param layer2 
#' @param output_file 
#'
#' @return
#' @export
#'
#' @examples
process_and_plot_sf_layers <- function(layer1, layer2, output_file = "output_plot.png") {
  # Make geometries valid
  layer1 <- sf::st_make_valid(layer1)
  layer2 <- sf::st_make_valid(layer2)
  
  # Optionally, simplify geometries to remove duplicate vertices
  layer1 <- sf::st_simplify(layer1, preserveTopology = TRUE) |>
    dplyr::filter(grade != "")
  
  # Prepare a list to store results
  results <- list()
  
  # Loop through each grade and perform operations
  for (grade in c("A", "B", "C", "D")) {
    # Filter layer1 for current grade
    layer1_grade <- layer1[layer1$grade == grade, ]
    
    # Buffer the geometries of the current grade
    buffered_layer1_grade <- sf::st_buffer(layer1_grade, dist = 500)
    
    # Intersect with the second layer
    intersections <- sf::st_intersects(layer2, buffered_layer1_grade, sparse = FALSE)
    selected_polygons <- layer2[rowSums(intersections) > 0, ]
    
    # Add a new column to store the grade information
    selected_polygons$grade <- grade
    
    # Store the result
    results[[grade]] <- selected_polygons
  }
  
  # Combine all selected polygons from different grades into one sf object
  final_selected_polygons <- do.call(rbind, results)
  
  # Define colors for the grades
  grade_colors <- c("A" = "grey", "B" = "grey", "C" = "grey", "D" = "grey")
  
  # Create the plot
  plot <- ggplot() +
    ggplot2::geom_sf(data = roads, alpha = 0.05, lwd = 0.1) +
    ggplot2::geom_sf(data = rivers, color = "blue", alpha = 0.1, lwd = 1.1) +
    ggplot2::geom_sf(data = layer1, fill = "grey", color = "grey", size = 0.1) +
    facet_wrap(~ grade, nrow = 1) +
    ggplot2::geom_sf(data = final_selected_polygons,fill = "green", color = "green", size = 0.1) +
    facet_wrap(~ grade, nrow = 1) +
    #scale_fill_manual(values = grade_colors) +
    #scale_color_manual(values = grade_colors) +
    theme_minimal() +
    labs(fill = 'HOLC Grade') +
    ggthemes::theme_tufte() +
    theme(plot.background = element_rect(fill = "white", color = NA),
          panel.background = element_rect(fill = "white", color = NA),
          legend.position = "none",
          axis.text = element_blank(),
          axis.title = element_blank(),
          axis.ticks = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
  
  # Save the plot as a high-resolution PNG file
  ggsave(output_file, plot, width = 10, height = 4, units = "in", dpi = 1200)
  
  # Return the plot for optional further use
  return(list(plot=plot, sf = final_selected_polygons))
}
