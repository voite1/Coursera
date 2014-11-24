rankhospital <- function(state, outcome, num = "best") {
  # Read the data file
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  # Validate the outcomes, states, and rank (num)
  outcomes = c("heart attack", "heart failure", "pneumonia")
  states <- unique(data[, 7]) 

  if( outcome %in% outcomes == FALSE) {
    stop("invalid outcome")
  } else if (state %in% states == FALSE) {
    stop("invalid state")
  } else if (num != "best" && num != "worst" && num < 1) {
    stop("invalid num")
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

  # Reduce the size of data: filter by state and remove 'Not Availalbe'
  # from corresponding outcome
  data <- data[data$state == state & data[outcome] != 'Not Available', ]

  # Convert outcome to numeric
  data[, outcome] <- as.numeric(data[, outcome])
  
  # Order the data
  data <- data[order(data$name), ]
  data <- data[order(data[outcome]), ]
  
  # Determine the row to extract the name from, from within the data frame
  ranks <- data[, outcome]
  if(num == "best") {
    row <- which.min(ranks)
  } else if(num == "worst") {
    row <- which.max(ranks)
  } else {
    row <- num
  }

  ## Return hospital ranked by the num, best, or wors
  data[row, ]$name
}