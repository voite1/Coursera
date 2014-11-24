rankall <- function(outcome, num = "best") {
  # Read the data file
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  # Validate the outcomes, states, and rank (num)
  outcomes = c("heart attack", "heart failure", "pneumonia")
  if( outcome %in% outcomes == FALSE) {
    stop("invalid outcome")
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
  
    # Select rows with outcome data filed != 'Not Available'
  data <- data[data[outcome] != 'Not Available', ]
  
  # convert outcome filed to numberic and Order the data
  data[, outcome] <- as.numeric(data[, outcome])
  data <- data[order(data$name), ]
  data <- data[order(data[outcome]), ]
  
  # A function to get the best file per state
  # takes in data frame, state, and rank
  # copied from rankhospital.R and pasted into function
  getHospital <- function(d_frame, s_state, rank) {
    # Filter data.frame per state == s_state
    d_frame <- d_frame[d_frame$state == s_state, ]
    
    # Hold the vector of rankes per state
    temp <- d_frame[, outcome]
    
    # Determine the rank
    if(rank == "best") {
      row <- which.min(temp)
    } else if(rank == "worst") {
      row <- which.max(temp)
    } else {
      row <- rank
    }
    
    # return the name of the ranked hospital per state
    d_frame[row, ]$name
  }
  
  # Isolate unique states
  states <- data[, "state"]
  states <- unique(states)
  
  # Creating empty data frame to return once populated
  ret_data <- data.frame("hospital"=character(0), "state"=character(0))
  
  # Iterate through the states to find the num hospital in per state
  # and add the results to the ret_data data.fram
  for(s in states) {
    h <- getHospital(data, s, num)
    ret_data <- rbind(ret_data, data.frame(hospital=h, state=s))
  }
  
  # Return a data frame with the hospital names and the (abbreviated) state name
  # ret_data is also being storted by state in decsending order
  ret_data <- ret_data[order(ret_data["state"]), ]
  
  # Return the list of hospitals and states
  ret_data
}