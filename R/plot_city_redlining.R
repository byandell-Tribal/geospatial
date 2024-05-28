#' Plot POI over HOLC grades
#'
#' @param redlining_data 
#' @param roads,rivers amenities from redlining_data
#'
#' @return ggplot object
#' @export
#' @importFrom dplyr filter
#' @importFrom ggplot2 aes element_blank element_rect geom_sf
#'             ggplot ggsave labs scale_fill_manual theme
#' @importFrom ggthemes theme_tufte
#'
plot_city_redlining <- function(redlining_data,
                                roads = get_places(redlining_data, type = "roads"),
                                rivers = get_places(redlining_data, type = "rivers")) {

  # Filter residential zones with valid grades and where city survey is TRUE
  # Colors for the grades
  colors <- c("#76a865", "#7cb5bd", "#ffff00", "#d9838d")
  
  # Plot the data using ggplot2
  ggplot2::ggplot(dplyr::filter(redlining_data, city_survey == TRUE & grade != "")) +
    ggplot2::geom_sf(data = roads, alpha = 0.5, lwd = 0.1) +
    ggplot2::geom_sf(data = rivers, color = "blue", alpha = 0.5, lwd = 1.1) +
    ggplot2::geom_sf(ggplot2::aes(fill = grade), alpha = 0.5) +
    ggthemes::theme_tufte() +
    ggplot2::scale_fill_manual(values = colors) +
    ggplot2::labs(fill = 'HOLC Grade') +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      legend.position = "right")
}
#' @param object ggplot object
#' @return ggplot object
#' @export
#' @rdname plot_city_redlining
plot_city_redlining_grade <- function(object) {
  object +
    ggplot2::facet_wrap(~grade, nrow = 1) +
    ggplot2::theme(
      legend.position = "none",  # Optionally hide the legend
      axis.text = ggplot2::element_blank(),     # Remove axis text
      axis.title = ggplot2::element_blank(),    # Remove axis titles
      axis.ticks = ggplot2::element_blank())    # Remove axis ticks
}
