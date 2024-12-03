
library(sf)
library(dplyr)

# Read the polygon CSV file
polygons_data <- st_read("shapes_NA.csv")

# Read the stores CSV file
stores_data <- read.csv("stores_NA.csv")

# Convert polygons data to an sf object
polygons_sf <- st_as_sf(polygons_data, wkt = "geometry", crs = st_crs(stores_data))

# Initialize an empty column for microcodes in the stores data
stores_data$microcode <- NA

# Loop through each store and check if it lies within any polygon
for (i in seq_len(nrow(stores_data))) {
  store_point <- st_point(c(stores_data$Long[i], stores_data$Lat[i]))
  
  # Check if the store point is within any polygon
  within_polygon <- st_within(store_point, polygons_sf)
  
  # If within_polygon is not NA, assign the microcode
  if (length(within_polygon) > 0) {
    indices <- unlist(within_polygon)
    # Choose the first matching index
    chosen_index <- indices[1]
    stores_data$microcode[i] <- polygons_data$microcode[chosen_index]
  }
}

# Save the result to a new CSV file
write.csv(stores_data, "result.csv", row.names = FALSE)

