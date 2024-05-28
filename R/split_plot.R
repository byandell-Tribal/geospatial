#' Plot the HOLC grades individually
#'
#' @param sf_data 
#' @param roads 
#' @param rivers 
#' @return ggplot object
#' @export
#' @importFrom ggplot2 element_blank element_rect facet_wrap geom_sf
#'             ggplot ggsave labs scale_fill_manual theme theme_minimal
#' @importFrom ggthemes theme_tufte
#'
split_plot <- function(sf_data, roads, rivers) {
  # Filter for grades A, B, C, and D
  sf_data_filtered <- sf_data |> 
    dplyr::filter(grade %in% c('A', 'B', 'C', 'D'))
  
  # Define a color for each grade
  grade_colors <- c("A" = "#76a865", "B" = "#7cb5bd", "C" = "#ffff00", "D" = "#d9838d")
  
  # Create the plot with panels for each grade
  plot <- ggplot2::ggplot(data = sf_data_filtered) +
    ggplot2::geom_sf(data = roads, alpha = 0.1, lwd = 0.1) +
    ggplot2::geom_sf(data = rivers, color = "blue", alpha = 0.1, lwd = 1.1) +
    ggplot2::geom_sf(ggplot2::aes(fill = grade)) +
    ggplot2::facet_wrap(~ grade, nrow = 1) +  # Free scales for different zoom levels if needed
    ggplot2::scale_fill_manual(values = grade_colors) +
    ggplot2::theme_minimal() +
    ggplot2::labs(fill = 'HOLC Grade') +
    ggthemes::theme_tufte() +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      legend.position = "none",  # Optionally hide the legend
      axis.text = ggplot2::element_blank(),     # Remove axis text
      axis.title = ggplot2::element_blank(),    # Remove axis titles
      axis.ticks = ggplot2::element_blank(),    # Remove axis ticks
      panel.grid.major = ggplot2::element_blank(),  # Remove major grid lines
      panel.grid.minor = ggplot2::element_blank())  
  
  ggplot2::ggsave(plot, filename = "HOLC_grades_individually.png", width = 10, height = 4, units = "in", dpi = 1200)
  return(plot)
}

