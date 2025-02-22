# Wrapper function for as.triangle()


### Description

This is a wrapper function for the `ChainLadder::as.triangle()`
function. This is for those who have noticed column gaps when using
`as.triangle()` to convert claims data to the triangle format.

### Motivation

For example, this can occur when there are no claims in certain
development periods. This affects downstream functions such as
`incr2cum()` which may not take into account claims for some books with
long tails, say, claims don’t occur for a long time e.g. between 5 and 7
development period and then claims come in in the 10th development
period. This results in the cumulative triangle cutting off where you
don’t expect.

This function aims to make sure that the “Triangle” input for the
`as.triangle()` function has all the unique origin periods and all
development periods are taken into account resulting in a sort of
perfect half square.

This is done by creating a skeleton using the unique origin periods and
sequencing the length of these origin periods from 1. The data is then
merged with the skeleton then passed through the traditional skeleton
function:

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

### Limitations

I foresee a problem when you have "empty" origin periods. For example, a specific origin period between origin periods is not present in your data. The labelling of the development periods would not be accurate.