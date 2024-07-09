#' get a vector of as distinct possible colours
#' 
#' @param number_of_colours how many colours to return
#' @param use_sampling whether or not to randomly extract the colours instead of grabbing the first n colours
#' @param color_indices (optional, not used by default) if specific colours are needed, supply the indices of the colours here. Use 'get_available_colours_grid' to get the colours and their indices
#' @returns a vector of colours
#' 
#' @examples 
#' colours_to_use <- sample_many_colours(5, F, c(1,4,7,8,11))
#' colours_to_use <- sample_many_colours(5, T)
#' @export
sample_many_colours <- function(number_of_colours, use_sampling=F, color_indices=NULL) {
  # get all colours from the 'quality' palettes
  quality_colour_palettes <-  RColorBrewer::brewer.pal.info[RColorBrewer::brewer.pal.info[['category']] == 'qual', ]
  # save each palette
  colours_per_palette <- list()
  # apply over each palette
  for (i in 1:nrow(quality_colour_palettes)) {
    # get the name of the palette
    palette_name <- rownames(quality_colour_palettes)[i]
    # get the number of colours in the palette
    palette_max_colours <- quality_colour_palettes[i, 'maxcolors']
    # use brewer.pal to get all colours
    colours_palette <- RColorBrewer::brewer.pal(palette_max_colours, palette_name)
    # put result in the list
    colours_per_palette[[palette_name]] <- colours_palette
  }
  # merge all palettes
  all_colours <- do.call('c', colours_per_palette)
  # randomly get colours from the palette
  max_possible_colours <- length(all_colours)
  if (is.null(number_of_colours)) {
    message('no number of colors supplied, assuming color indices have been')
  }
  else if (number_of_colours > max_possible_colours) {
    message(paste('requesting more colours than is possible: ', as.character(number_of_colours), ' vs ', max_possible_colours, ', returning max possible', sep = ''))
    number_of_colours <- max_possible_colours
  }
  colours_to_return <- NULL
  # specific colours we like (the indices)
  if (!is.null(color_indices)) {
    colours_to_return <- all_colours[color_indices]
  }
  # or use sampling
  else if (use_sampling) {
    # get sample indices
    sample_indices <- sample(1 : length(all_colours), number_of_colours)
    print(paste('color indices sampled:', paste(sample_indices, collapse = ',')))
    colours_to_return <- all_colours[sample_indices]
  }
  # or the first x colours
  else {
    colours_to_return <- all_colours[1 : number_of_colours]
  }
  return(colours_to_return)
}

#' get a vector of as distinct possible colours, but with more possibilities ()
#' 
#' @param number_of_colours how many colours to return
#' @param use_sampling whether or not to randomly extract the colours instead of grabbing the first n colours
#' @param color_indices (optional, not used by default) if specific colours are needed, supply the indices of the colours here. Use 'get_available_colours_grid' to get the colours and their indices
#' @returns a vector of colours
#' 
#' @examples 
#' colours_to_use <- sample_tons_of_colors(5, F, c(1,4,7,8,11))
#' colours_to_use <- sample_tons_of_colors(120, T)
#' @export
sample_tons_of_colors <- function(number_of_colours, use_sampling=F, color_indices=NULL) {
  # get colours available to device
  all_colours <- grDevices::colors()
  # remove gray
  all_colours <- all_colours[grep('gr(a|e)y', all_colours, invert = T)]
  # check how many are possible
  max_possible_colours <- length(all_colours)
  if (is.null(number_of_colours)) {
    message('no number of colors supplied, assuming color indices have been')
  }
  else if (number_of_colours > max_possible_colours) {
    message(paste('requesting more colours than is possible: ', as.character(number_of_colours), ' vs ', max_possible_colours, ', returning max possible', sep = ''))
    number_of_colours <- max_possible_colours
  }
  colours_to_return <- NULL
  # specific colours we like (the indices)
  if (!is.null(color_indices)) {
    colours_to_return <- all_colours[color_indices]
  }
  # or use sampling
  else if (use_sampling) {
    colours_to_return <- sample(all_colours, number_of_colours)
  }
  # or the first x colours
  else {
    colours_to_return <- all_colours[1 : number_of_colours]
  }
  return(colours_to_return)
}


#' get a grid showing the available colours and their indices
#' 
#' @param many use the 'many' method to get the colours
#' @param tons use the 'tons' method to get the colours
#' @returns a ggplot grid showing the available colours and their indices
#' 
#' @examples 
#' get_available_colours_grid()
#' @export
get_available_colours_grid <- function(many=T, tons=F) {
  colours_possible <- NULL
  # get from the many method
  if (many) {
    # ask for unreasonable amount
    colours_possible <- sample_many_colours(1000)
  }
  else if(tons) {
    colours_possible <- sample_tons_of_colors(1000)
  }
  # get how many colours we actually have
  available_colours <- length(colours_possible)
  # we need to put that into a square grid, so we need to get the square root, to know how many rows and columns
  nrow_and_ncol <- sqrt(available_colours)
  # and we need to round that up of course
  nrow_and_ncol <- ceiling(nrow_and_ncol)
  # so we'll have a total number of blocks
  total_cells <- nrow_and_ncol * nrow_and_ncol
  # let's see how many colours we are off from that number of cells
  cells_no_colour_number <- total_cells - available_colours
  # we will just add white for those
  cells_no_colour <- rep('white', times = cells_no_colour_number)
  # add that to the colours we have
  colours_possible <- c(colours_possible, cells_no_colour)
  # create each combination of x and y
  indices_grid <- expand.grid(as.character(1 : nrow_and_ncol), as.character(1 : nrow_and_ncol))
  # add the index and colour name
  indices_grid[['index_colour']] <- paste(c(1:total_cells), colours_possible, sep = '\n')
  # make mapping of colours
  colours_to_use <- as.list(colours_possible)
  names(colours_to_use) <- indices_grid[['index_colour']]
  # now plot
  p <- ggplot2::ggplot(data = indices_grid, mapping = aes(x = Var1, y = Var2, fill = index_colour)) + 
    ggplot2::geom_tile() + 
    ggplot2::geom_text(aes(label=index_colour)) + 
    ggplot2::scale_fill_manual(values = colours_to_use) + 
    ggplot2::theme(legend.position = 'none')
  return(p)
}

#' get a vector of as distinct possible colours, but with more possibilities ()
#' 
#' @param vector_of_names a vector of values for which you want colours
#' @param use_sampling whether or not to randomly extract the colours instead of grabbing the first n colours
#' @param color_indices (optional, not used by default) if specific colours are needed, supply the indices of the colours here. Use 'get_available_colours_grid' to get the colours and their indices
#' @returns a vector of colours
#' 
#' @examples 
#' get_color_list(c('A', 'B', 'A', 'C', 'B'), F, c(3,4,5))
#' get_color_list(c('A', 'B', 'A', 'C', 'B'), T)
#' @export
get_color_list <- function(vector_of_names, use_sampling=F, color_indices=NULL) {
  # get the unique entries
  vector_unique <- unique(vector_of_names)
  # remove any NA
  vector_unique <- vector_unique[!is.na(vector_unique)]
  # get some colors
  colors_to_use <- NULL
  if (length(vector_of_names) > 74) {
    colors_to_use <- sample_tons_of_colors(length(vector_unique), use_sampling = use_sampling, color_indices = color_indices)
  }
  else{
    colors_to_use <- sample_many_colours(length(vector_unique), use_sampling = use_sampling, color_indices = color_indices)
  }
  # turn into a list
  colors_to_use_list <- as.list(colors_to_use)
  # and add the names
  names(colors_to_use_list) <- vector_unique
  return(colors_to_use_list)
}