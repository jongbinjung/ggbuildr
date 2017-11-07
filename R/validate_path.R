.validate_path <- function(path) {
  # Check if the directory for path exists, and if not create

  # Args:
  #   path: full path (including filename)

  # Returns:
  #   file path to directory, sans filename (returned from dirname)
  dir <- dirname(path)

  if (!dir.exists(dir)) {
    message("Creating:", dir)
    dir.create(dir, recursive = TRUE)
  }

  return(dir)
}
