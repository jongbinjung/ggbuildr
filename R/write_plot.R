#' @importFrom ggplot2 ggsave
.write_plot <- function(p, plotpath, ...) {
  if (is.null(plotpath)) {
    print(p)
  } else {
    message("Saving:", plotpath)
    ggsave(plotpath,
           plot = p,
           ...)
  }
}
