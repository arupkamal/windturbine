source("R/credentials.R")
source("R/helper_functions.R")
library(gridExtra)
library(ggplot2)

turbine_data <- NULL

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
calculate_outliers <- function(data, measure_name, starting_row) {
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  outlier_name = paste0("outlier_",measure_name)

  lower_bound <- quantile(unlist(data[measure_name]) , 0.05)
  upper_bound <- quantile(unlist(data[measure_name]) , 0.95)

  if (nrow(data[data[measure_name] < lower_bound,])>0) {
    data[data[measure_name] < lower_bound,][outlier_name] <- "Y"
    data[data[measure_name] > upper_bound,][outlier_name] <- "Y"
  }
  data
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_outlier_data <- function(){
  turbine_data <- get_data_from_db()
  turbine_data <- calculate_outliers(turbine_data, "wind_speed", starting_row)
  turbine_data <- calculate_outliers(turbine_data, "wind_direction", starting_row)

  turbine_data
  }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_outlier_chart <- function(){
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  turbine_data <- get_data_from_db()
  turbine_data <- calculate_outliers(turbine_data, "wind_speed", starting_row)
  turbine_data <- calculate_outliers(turbine_data, "wind_direction", starting_row)

  plot_wind_speed <- ggplot2::ggplot(turbine_data, ggplot2::aes(x=time, y=wind_speed, color=turbine_data$outlier_wind_speed)) +
    ggplot2::geom_point(size=2) +
    ggplot2::theme(legend.position="none") +
    ggplot2::scale_colour_manual(values = c("gray", "red")) +
    ggplot2::ggtitle("Wind Speed") +
    ggplot2::ylab("meter/second")


  plot_wind_direction <- ggplot2::ggplot(turbine_data, ggplot2::aes(x=time, y=wind_direction, color=turbine_data$outlier_wind_direction)) +
    ggplot2::geom_point(size=2) +
    ggplot2::theme(legend.position="none") +
    ggplot2::scale_colour_manual(values = c("gray", "red")) +
    ggplot2::ggtitle("Wind Direction") +
    ggplot2::ylab("° Degree")

  gridExtra::grid.arrange(plot_wind_speed, plot_wind_direction, nrow=2)

}
