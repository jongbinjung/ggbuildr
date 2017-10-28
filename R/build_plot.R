build_plot <- function(p, filepath) {

}

p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_smooth() +
  geom_line()

layers <- p$layers

q <- p
q$layers <- NULL
q$layers <- layers[c(1, 2)]
q
