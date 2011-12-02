#' An interval represented by a vertical line, with a point in the middle.
#' 
#' @seealso
#'  \code{\link{geom_errorbar}} for error bars,
#'  \code{\link{geom_linerange}} for range indicated by straight line, + examples,
#'  \code{\link{geom_crossbar}} for hollow bar with middle indicated by horizontal line,
#'  \code{\link{stat_summary}} for examples of these guys in use,
#'  \code{\link{geom_smooth}} for continuous analog"
#' @export
#' @examples
#' # See geom_linerange for examples
geom_pointrange <- function (mapping = NULL, data = NULL, stat = "identity", position = "identity", ...) { 
  GeomPointrange$new(mapping = mapping, data = data, stat = stat, position = position, ...)
}

GeomPointrange <- proto(Geom, {
  objname <- "pointrange"

  icon <- function(.) {
    gTree(children=gList(
      segmentsGrob(c(0.3, 0.7), c(0.1, 0.2), c(0.3, 0.7), c(0.7, 0.95)),
      pointsGrob(c(0.3, 0.7), c(0.4, 0.6), pch=19, gp=gpar(col="black", cex=0.5), default.units="npc")
    ))
  }
  
  default_stat <- function(.) StatIdentity
  default_aes <- function(.) aes(colour = "black", size=0.5, linetype=1, shape=16, fill=NA, alpha = 1)
  guide_geom <- function(.) "pointrange"
  required_aes <- c("x", "y", "ymin", "ymax")

  draw <- function(., data, scales, coordinates, ...) {
    if (is.null(data$y)) return(GeomLinerange$draw(data, scales, coordinates, ...))
    ggname(.$my_name(),gTree(children=gList(
      GeomLinerange$draw(data, scales, coordinates, ...),
      GeomPoint$draw(transform(data, size = size * 4), scales, coordinates, ...)
    )))
  }

  draw_legend <- function(., data, ...) {
    data <- aesdefaults(data, .$default_aes(), list(...))
    
    grobTree(
      GeomPath$draw_legend(data, ...),
      GeomPoint$draw_legend(transform(data, size = size * 4), ...)
    )
  }
  
})
