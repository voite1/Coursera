best <- function(state, outcome) {
  # Read the data file
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  # Validate the outcomes and states
  outcomes = c("heart attack", "heart failure", "pneumonia")
  states <- unique(data[, 7])
  if( outcome %in% outcomes == FALSE ) {
    stop("invalid outcome")
  } else if (state %in% states == FALSE) {
    stop("invalid state")
  }

  # Simplify the data by shrinking the data size and naming
  # columns in the data.frame.  Found this approach on the web used by
  # many other folks to simply data and calculations. Works very well
  data <- data[c(2, 7, 11, 17, 23)]
  names(data)[1] <- "name"
  names(data)[2] <- "state"
  names(data)[3] <- "heart attack"
  names(data)[4] <- "heart failure"
  names(data)[5] <- "pneumonia"

  # Select the data pertaining to only the state variable passed to function
  # and furtehr reduce the size of the data.frame
  data <- data[data$state == state & data[outcome] != 'Not Available', ]
  
  # Determine the row containing the lowest death rate (already separeted
  # by state)
  row <- which.min(data[, outcome])
  
  # Print out the hospital name based on the row number.
  data[row,]$name
}
