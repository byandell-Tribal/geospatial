process_city_inventory_data <- function(address, inner_file, polygon_layer, 
                                        output_filename,
                                        variable_label= 'Tree Density') {
  # Download and read the shapefile
  full_path <- glue::glue("/vsizip/vsicurl/{address}/{inner_file}")
  shape_data <- sf::st_read(full_path, quiet = TRUE) |> sf::st_as_sf()
  
  # Process the shape data with the provided polygon layer
  processed_data <- process_and_plot_sf_layers(polygon_layer, shape_data,
                                               paste0(output_filename, ".png"))
  
  # Extract trees from the processed data
  trees <- processed_data$sf
  denver_redlining_residential <- polygon_layer |> filter(grade != "")
  
  # Generate the density plot
  plot <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = roads, alpha = 0.05, lwd = 0.1) +
    ggplot2::geom_sf(data = rivers, color = "blue", alpha = 0.1, lwd = 1.1) +
    ggplot2::geom_sf(data = denver_redlining_residential, fill = "grey", color = "grey", size = 0.1) +
    ggplot2::facet_wrap(~ grade, nrow = 1) +
    ggplot2::stat_density_2d(
      data = trees, 
      mapping = ggplot2::aes(
        x = purrr::map_dbl(geometry, ~.[1]),
        y = purrr::map_dbl(geometry, ~.[2]),
        fill = ggplot2::after_stat(density)),
      geom = 'tile',
      contour = FALSE,
      alpha = 0.9) +
    ggplot2::scale_fill_gradientn(
      colors = c("transparent", "white", "limegreen"),
      values = scales::rescale(c(0, 0.1, 1)),  # Adjust these based on your density range
      guide = "colourbar") +
    ggplot2::theme_minimal() +
    ggplot2::labs(fill = variable_label) +
    ggthemes::theme_tufte() +
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
  ggplot2::ggsave(paste0(output_filename, "_density_plot.png"), plot, width = 10,
                  height = 4, units = "in", dpi = 600)
  
  # Return the plot and the tree layer
  return(list(plot = plot, layer = trees))
}
