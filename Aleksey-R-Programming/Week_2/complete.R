complete <- function(directory, id = 1:332) {
  # it is assumed that the directory name is always correct
  
  # Read the list of files
  v_files <- as.character(list.files(directory))
  
  # Constrcut filepath
  v_filepath <- paste(directory, v_files, sep="/")
  
  # Temp vector to hold complete cases per fector passed in as id
  v_tdata <- (rep(0, length(id)))
  
  # count variable to refer to v_tdata vector to store nobs - one record per file
  case_count <- 1
  
  # Process list of files
  for(i in id) {
    # read i-th file corresponding to id
    temp_file <- read.csv(v_filepath[i], header = T)
    
    # populated v_tdata vector with sum of nobs per file
    v_tdata[case_count] <- sum(complete.cases(temp_file))
    
    # increase reference to position in v_tdata
    case_count <- case_count + 1
  }
  
  # returned namded data frame with only two columns: id and nobs
  return(data.frame(id = id, nobs = v_tdata))
}