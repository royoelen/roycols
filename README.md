# roycols

small library to help with creating color palettes

## installation

You can install via github, no cran or bioconductor unfortunately

``` r
library(devtools)
install_github("https://github.com/royoelen/roycols");
```

## usage

you can get a vector of colors with a certain size

``` r
roycols::colours_to_use <- sample_many_colours(5)
```

you can also use random sampling

``` r
roycols::colours_to_use <- sample_many_colours(5, use_sampling = T)
```

you can see the available colors in a tile

``` r
roycols::get_available_colours_grid()
```

you can then also select colors that you like by index

``` r
roycols::colours_to_use <- sample_many_colours(5, use_sampling = F, color_indices = c(1,4,7,8,11))
```

if you want more than 72 colors, there is also another option

``` r
roycols::sample_tons_of_colors(120, T)
```

if you don't know then number of colours up front, or want a straight mapping to use for ggplot2::scale_fill_manual(), you could do the following

``` r
plot_frame <- data.frame(x_value = c('A', 'B', 'C'), y_value = c(5, 7, 6), colour_column = c('A1', 'B1', 'C1'))
plot_frame_colours <- roycols::get_color_list(plot_frame[['colour_column']])
p <- ggplot2::ggplot(data = plot_frame, mapping = ggplot2::aes(x = x_value, y = y_value, fill = colour_column)) + 
  ggplot2::geom_bar(stat = 'identity') +
  ggplot2::scale_fill_manual(values = plot_frame_colours)
```

you can also create colours that are shades of other colours. For example if you need a list of shades between red and orange, you can do this:

``` r
roycols::shades_between_red_yellow <- get_shades(10, c('yellow', 'orange', 'red'))
```

if you want to see first how these colours look, you can view them in a tile

``` r
roycols::plot_shades(10, c('yellow', 'orange', 'red'))
```

the 'get_colour_list' function also has a shading flavour:

``` r
plot_frame <- data.frame(x_value = c('A', 'B', 'C', 'D', 'E', 'F'), y_value = c(5, 7, 6), colour_column = c('A1', 'B1', 'C1', 'D1', 'E1', 'F1'))
plot_frame_colours <- roycols::get_color_list_shades(plot_frame[['colour_column']], c('lavender', 'purple', 'darkviolet'))
p <- ggplot2::ggplot(data = plot_frame, mapping = ggplot2::aes(x = x_value, y = y_value, fill = colour_column)) + 
  ggplot2::geom_bar(stat = 'identity') +
  ggplot2::scale_fill_manual(values = plot_frame_colours)
```
