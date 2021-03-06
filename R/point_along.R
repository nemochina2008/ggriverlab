#' Point along
#'
#' Find a point along a path
#'
#' @param d linear distance of the researched point along the path from the first point.
#' @param x vector of the x-position of the points along the path.
#' @param y vector of the y-position of the points along the path.
#'
#' @return vector of (x,y) coordinates of the reasearch point. Returns extremities if the distance in negative or null, or too long.
#' @export
#'
#' @examples
#'
#' x <- c(1,1,1,2,2)
#' y <- 1:5
#'
#' d <- 1
#' point_along(d, x, y)
#' d <- 4.123
#' point_along(d, x, y)
#' d <- 5
#' point_along(d, x, y)

point_along <- function(d, x, y){
  df <- data.frame(x,y)

  # compute segment lengths
  df2 <- df %>% mutate(xn = lag(x, 1),
                      yn = lag(y, 1),
                      l = sqrt((xn-x)^2 + (yn-y)^2)) %>%
    filter(!is.na(l)) %>%
    mutate(cuml= cumsum(l))


  # print(c(dx, dy))
  if (d <= 0){
    return(c(df[1,1], df[1,2]))
  } else if (d > max(df2$cuml)){
    L <- length(df$x)
    return(c(df[L,1], df[L,2]))
  } else {

  # identify the segment containing the point separated from the first point by linear distance along the path of d
  s <- df2  %>% filter(cuml >= d & (cuml - l) < d)

  # compute the mean of the segment's extremities weighted by the relative distance of the searched point.
  w <- (d - (s$cuml - s$l)) / s$l
  dx <- (s$x * (1 - w) + s$xn * w)
  dy <- (s$y * (1 - w) + s$yn * w)
  return(c(dx, dy))
  }
}
