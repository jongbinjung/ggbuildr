library("ggplot2")
context("build_plot")

test_that("build_plot creates correct number of files", {
  filepath <- paste0(tempfile(), ".pdf")

  dir <- ggbuildr:::.validate_path(filepath)

  filename <- basename(tools::file_path_sans_ext(filepath))
  buildpath <- file.path(dir, "builds", paste0(filename, "_%01d.pdf"))
  builddir <- ggbuildr:::.validate_path(buildpath)

  build01 <- sprintf(buildpath, 1)
  build02 <- sprintf(buildpath, 2)

  on.exit(unlink(filepath))
  on.exit(unlink(build01))
  on.exit(unlink(build02))

  p <- ggplot(mpg, aes(displ, hwy)) +
    geom_point() +
    geom_line()

  expect_false(file.exists(filepath))
  expect_false(file.exists(build01))
  expect_false(file.exists(build02))

  build_plot(p, filepath, build_order = list(1, 2))

  expect_true(file.exists(filepath))
  expect_true(file.exists(build01))
  expect_true(file.exists(build02))
})
