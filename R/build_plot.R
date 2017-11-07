#' Incrementally build and save layers of a ggplot object into numbered files
#'
#' \code{build_plot} save a ggplot object incrementally, adding geom layers in
#' the order specified with a list in the \code{build_order} argument.
#'
#' The graphic device is either automatically detected from the \code{filepath},
#' or can be set explicitly with \code{ext}. By default, the final, complete
#' plot is saved in \code{filepath}, and the incremental builds are saved in a
#' subdirectory specified with \code{subdir}, "builds" by default. Sometimes,
#' it's useful to also keep the full ggplot object as an rds file for future
#' edits, which can be done by setting the \code{save_rds} argument to TRUE.
#'
#' @param plot ggplot object. The final plot to build towards.
#' @param filepath character string specifying where to save the plot, with or
#'   without extensions. If the filepath is given without extension, the
#'   \code{ext} and/or \code{build_ext} arguments must be specified.
#'   Non-existing paths are created automatically.
#' @param build_order list of numerical vectors. The order in which to build
#'   each layer of the plot, where the first (lowest) layer is 1. Multiple
#'   layers can be built at a single increment by specifying the list element as
#'   a vector of two or more values.
#' @param subdir character string. Specifies where to save the incremental
#'   builds, as opposed to the final, full plot. (default: "builds")
#' @param ext character string. Extension for the full plot. Also used as
#'   extension for builds if \code{build_ext} is not specified
#' @param build_ext (Optional) character string. If specified, the incremental
#'   builds will be saved in this format (e.g., one could save the final plot as
#'   a pdf, but save the incremental builds as a png which might be easier to
#'   add to slides.)
#' @param save_full logical. Whether or not to save the full plot (default:
#'   TRUE)
#' @param save_rds logical. Whether or not to save the full ggplot object as an
#'   rds file with the same filepath. (default: FALSE)
#' @param preserve_order logical. Whether or not to keep the original order of
#'   the layers. Only relevant if the specified \code{build_order} is not
#'   monotonically increasing.
#' @param ... other arguments, passed to \code{\link[ggplot2]{ggsave}} (e.g.
#'   width/height)
#'
#' @return Saves plots to specified path.
#' @export
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_smooth
#' @importFrom ggplot2 geom_point
#'
#' @examples
#' X <- rnorm(20)
#' Y <- X + rnorm(20)
#'
#' pd <- data.frame(X, Y)
#' p <- ggplot(pd, aes(X, Y)) +
#'   geom_smooth() +
#'   geom_point()
#'
#' # Plot smooth, and then point
#' build_plot(p, build_order = list(1, 2))
#'
#' # Plot point, and then smooth, but preserve order (i.e, keep points on top)
#' build_plot(p, build_order = list(2, 1))
#'
#' # Plot point, and then smooth, and draw smooth layer on top of point
#' build_plot(p, build_order = list(2, 1), preserve_order = FALSE)
build_plot <-
  function(plot,
           filepath = NULL,
           build_order,
           subdir = "builds",
           ext = tools::file_ext(filepath),
           build_ext = ext,
           save_full = TRUE,
           save_rds = FALSE,
           preserve_order = TRUE,
           ...) {
  # Setup file paths and parameters
  n_builds <- length(build_order)
  max_digits <- ceiling(log10(n_builds))

  if (!is.null(filepath)) {
    # Deal with actual file path (e.g., setup directories and extensions)
    dir <- validate_path(filepath)
    filename <- basename(tools::file_path_sans_ext(filepath))
    buildpath <- file.path(dir, subdir,
                           paste0(filename, "_%0", max_digits, "d.", build_ext))
    builddir <-buildr:::.validate_path(buildpath)

    if (save_full) {
      write_plot(plot, file.path(dir, paste0(filename, ".", ext)), ...)
    }

    if (save_rds) {
      rdspath <- file.path(dir, "rds", paste0(filename, ".rds"))
      rdsdir <- validate_path(rdspath)
      readr::write_rds(plot, rdspath)
    }
  }

  canvas <- plot

  purrr::walk(1:length(build_order), function(i) {
    bo <- unlist(build_order[1:i])

    if (preserve_order) {
      bo <- sort(bo)
    }

    if (!is.null(filepath)) {
      buildfile <- sprintf(buildpath, as.numeric(i))
    } else {
      buildfile <- NULL
    }

    missing_layers <- setdiff(1:length(canvas$layers), bo)

    canvas$layers <- plot$layers[bo]

    ggbuildr:::.write_plot(canvas, buildfile, ...)
  })
}
