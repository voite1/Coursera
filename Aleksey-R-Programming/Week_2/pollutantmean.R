pollutantmean <- function(directory, pollutant = "sulfate", id = 1:332) {

  # The directory name is assumed to be correct every single time
  
  # Create vector to hold mean of monitors
  v_mean <- c()
  
  # Read the list of files
  v_files <- as.character(list.files(directory))
  
  # Constrcut filepath
  v_filepath <- paste(directory, v_files, sep="/")
  
  # Process list of files
  for(i in id) {
    # read i-th file corresponding to id
    temp_file <- read.csv(v_filepath[i], header = T)
    
    # remove NA's
    bad <- is.na(temp_file[, pollutant])
    removed_na <- temp_file[!bad, pollutant]
    
    # populate the vector of means
    v_mean <- c(v_mean, removed_na)
  }
  
  # Return mean accross selected monitors (in id for a given pollutant)
  return(round(mean(v_mean), 3))  
}