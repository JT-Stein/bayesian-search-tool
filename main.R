library(raster)

# This is the probability of detecting the object given that it is actually in the 
# square being searched
prob_detect = 0.25

# Determines the colors used in the heat map and their relationship with probability
# of location
#                 Low P   Medium P  High P
color_palette = c("blue", "yellow", "green")

revised_prob = function(p_contain, p_detect) {
  # Returns the probability of the item being in the sector given that the sector was searched and the item was not found

  # p_contain' = p_contain * (1 - p_detect) / (1 - p_contain * p_detect) < p_contain

  numerator = 1 - p_detect
  denominator = 1 - p_contain * p_detect

  return(p_contain * numerator / denominator)

}

posterior_prob = function(p_contain, p_detect) {
  # p_contain' = p_contain / (1 - p_contain * p_detect) > p_contain

  numerator = p_contain
  denominator = 1 - p_contain * p_detect

  return(numerator / denominator)

}

matrix_sum = function(m) {
  # Returns the sum of all of the elements in a matrix m
  return(sum(m))
}

matrix_update = function(m, searched_square) {
  # m is the matrix of positions updated based on the searched_square
  
  # Loops through all positions in the map
  # Applies the revised probability to only the searched square and the posterior probaility to all other squares

  updated_matrix = m

  for (x in 1:nrow(m)) {
    for (y in 1:ncol(m)) {
      if (all(c(x,y) == searched_square)) {
        # Runs revised_prob() as this is the searched square

        updated_matrix[x, y] = revised_prob(m[x, y], prob_detect)

      } else {
        # Runs posterior_prob() as this is not the searched square

        updated_matrix[x, y] = posterior_prob(m[x, y], prob_detect)
      }
    }
  }

  return(updated_matrix)

}

# The following 5x5 matrix is set with example probabilities. The number of rows can be increased
# or decreased alongside an adjustment of map_matrix = rbind(row_1...

row_1 = c(0.034, 0.037, 0.041, 0.039, 0.03)
row_2 = c(0.038, 0.042, 0.045, 0.043, 0.038)
row_3 = c(0.041, 0.045, 0.050, 0.045, 0.041)
row_4 = c(0.039, 0.043, 0.045, 0.042, 0.038)
row_5 = c(0.036, 0.038, 0.041, 0.038, 0.031)

map_matrix = rbind(row_1, row_2, row_3, row_4, row_5)
print(map_matrix)

# The user is warned if their given probabilities do not add to 1 because they must if the
# probability mass function is properly specified

if (abs(matrix_sum(map_matrix) - 1) > 1e-8) {
  print("WARNING: The location given probabilities do not sum to 1")
  print(paste("Sum:", matrix_sum(map_matrix)))
}

# Provides a visualization of the search area
heat_map = raster(xmn = 0, xmx = ncol(map_matrix), ymn = 0, ymx = nrow(map_matrix), nrows = nrow(map_matrix), ncols=ncol(map_matrix))
colors = colorRampPalette(color_palette)

# Displays the heat map of the probability mass function for the assumptions of
# the situation

heat_map[] = map_matrix
plot(heat_map, col=colors(100))

while (TRUE) {
  row_search = readline(prompt = "Row Searched: ")
  col_search = readline(prompt = "Column Searched: ")

  # Converts the row and column inputs into integers
  updated_matrix = matrix_update(map_matrix, c(row_search, col_search))
  
  # After finding the updated probability mass function, sets the new map_matrix
  # equal to that
  
  map_matrix = updated_matrix
  print(round(updated_matrix, 3))
  
  heat_map[] = map_matrix
  plot(heat_map, col=colors(100))

}
