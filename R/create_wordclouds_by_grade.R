#' Create word cloud per grade
#'
#' @param sf_object 
#' @param output_file 
#' @param title 
#' @param max_size 
#' @param col_select 
#'
#' @return
#' @export
#'
#' @examples
create_wordclouds_by_grade <- function(sf_object, output_file = "food_word_cloud_per_grade.png",title = "Healthy food place names word cloud", max_size =25, col_select = "name") {
  
  
  # Extract relevant data and prepare text data
  text_data <- sf_object %>%
    select(grade, col_select) %>%
    filter(!is.na(col_select)) %>%
    unnest_tokens(output = "word", input = col_select, token = "words") %>%
    count(grade, word, sort = TRUE) %>%
    ungroup() %>%
    filter(n() > 1)  # Filter to remove overly common or single-occurrence words
  
  # Ensure there are no NA values in the 'word' column
  text_data <- text_data %>% filter(!is.na(word))
  
  # Handle cases where text_data might be empty
  if (nrow(text_data) == 0) {
    stop("No data available for creating word clouds.")
  }
  
  # Create a word cloud using ggplot2 and ggwordcloud
  p <- ggplot( ) +
    geom_text_wordcloud_area(data=text_data, aes(label = word, size = n),rm_outside = TRUE) +
    scale_size_area(max_size = max_size) +
    facet_wrap(~ grade, nrow = 1) +
    scale_color_gradient(low = "darkred", high = "red") +
    theme_minimal() +
    theme(plot.background = element_rect(fill = "white", color = NA),
          panel.background = element_rect(fill = "white", color = NA),
          panel.spacing = unit(0.5, "lines"),
          plot.title = element_text(size = 16, face = "bold"),
          legend.position = "none") +
    labs(title = title)
  
  # Attempt to save the plot and handle any errors
  tryCatch({
    ggsave(output_file, p, width = 10, height = 4, units = "in", dpi = 600)
  }, error = function(e) {
    cat("Error in saving the plot: ", e$message, "\n")
  })
  
  return(p)
}
