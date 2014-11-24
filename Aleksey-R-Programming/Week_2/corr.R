corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0
  
  ## Return a numeric vector of correlations
  
  # it is assumed that the directory name is always correct
  
  # Read the list of files
  v_files <- as.character(list.files(directory))
  
  # Constrcut filepath
  v_filepath <- paste(directory, v_files, sep="/")
  
  # vector to hold results
  v_return <- vector()
  
  # Process list of files
  for(i in v_filepath) {
    # read i-th file corresponding to id
    temp_file <- read.csv(i, header = T)
    
    # get complete cases for the temp_file
    completeCases <- temp_file[complete.cases(temp_file), ]
    
    # add correlations to the return vector
    if(nrow(completeCases) > threshold) {
      v_return <- c(v_return, round(cor(completeCases$nitrate, completeCases$sulfate), 5)) 
    }
  }
  v_return
}