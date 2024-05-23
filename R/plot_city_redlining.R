#' Plot POI over HOLC grades
#'
#' @param redlining_data 
#' @param filename 
#'
#' @return ggplot object
#' @export
#' @importFrom dplyr filter
#' @importFrom ggplot2 aes element_blank element_rect geom_sf
#'             ggplot ggsave labs scale_fill_manual theme
#' @importFrom ggthemes theme_tufte
#'
plot_city_redlining <- function(redlining_data, filename = "redlining_plot.png") {
  # Fetch additional geographic data based on redlining data
  roads <- get_places(redlining_data, type = "roads")
  rivers <- get_places(redlining_data, type = "rivers")
  
  # Filter residential zones with valid grades and where city survey is TRUE
  residential_zones <- redlining_data |>
    dplyr::filter(city_survey == TRUE & grade != "") 
  
  # Colors for the grades
  colors <- c("#76a865", "#7cb5bd", "#ffff00", "#d9838d")
  
  # Plot the data using ggplot2
  plot <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = roads, lwd = 0.1) +
    ggplot2::geom_sf(data = rivers, color = "blue", alpha = 0.5, lwd = 1.1) +
    ggplot2::geom_sf(data = residential_zones,
                     ggplot2::aes(fill = grade),
                     alpha = 0.5) +
    ggthemes::theme_tufte() +
    ggplot2::scale_fill_manual(values = colors) +
    ggplot2::labs(fill = 'HOLC Categories') +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      legend.position = "right"
    )
  
  # Save the plot as a high-resolution PNG file
  ggplot2::ggsave(filename, plot, width = 10, height = 8, units = "in", dpi = 600)
  
  # Return the plot object if needed for further manipulation or checking
  return(plot)
}
