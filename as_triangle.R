# Wrapper function around as.triangle() from chainladder
as_triangle <- function(data, origin, dev, value, start = 1, delay = 1) {
  # create skeleton
  unique_origins <- unique(data[[origin]])
  dev_period <- seq(from = start, to = length(unique_origins), by = delay)
  triangle_skeleton <- expand.grid(unique_origins, dev_period, stringsAsFactors = FALSE)
  colnames(triangle_skeleton) <- c(origin, dev)

  complete_skeleton <- merge(triangle_skeleton, data[, c(origin, dev, value)], by = c(origin, dev), all.x = TRUE)
  incremental_triangle <- ChainLadder::as.triangle(
    Triangle = complete_skeleton, 
    origin = origin,
    dev = dev,
    value = value
  )

  return(incremental_triangle)
}
