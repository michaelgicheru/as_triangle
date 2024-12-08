# Wrapper function around as.triangle() from chainladder
as_triangle <- function(data, origin, dev, value) {
  # create skeleton
  unique_origins <- unique(data[[origin]])
  dev_period <- 1:(length(unique_origins))
  triangle_skeleton <- expand.grid(unique_origins, dev_period, stringsAsFactors = FALSE)
  colnames(triangle_skeleton) <- c(origin, dev)

  complete_skeleton <- merge(triangle_skeleton, data[, c(origin, dev)], by = c(origin, dev), all.x = TRUE)
  incremental_triangle <- ChainLadder::as.triangle(
    Triangle = complete_skeleton, 
    origin = origin,
    dev = dev,
    value = value
  )

  return(incremental_triangle)
}