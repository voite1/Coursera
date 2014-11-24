# Rewriting initial functions to work with matrix
# Construct a metrix that holds its inverse
makeCacheMatrix <- function(mat = matrix()) {
  
  # variable to hold matrix inverse
  inv <- NULL
  
  # Setting matrix to mtrx and inv to NULL
  setMatrix <- function(mtrx) {
    mat <<- mtrx
    inv <<- NULL
  }
  
  # Returns the original matrix
  getMatrix <- function() { mat }
  
  # Setting matrix inverse, the argument inverse is a type of matrix
  setInverse <- function(inverse) { inv <<- inverse }
  
  # Getting matrix inverse
  getInverse <- function() { inv }
  
  # Retuns list of methods available in makeCacheMatrix
  list(setMatrix = setMatrix, getMatrix = getMatrix,
       setInverse = setInverse, getInverse = getInverse)
}



# Obtaining an inverse of the matrix m_matrix produced by makeCacheMatrix
cacheSolve <- function(m_matrix, ...) {
  
  # Test if m_matrix already has an inverse storred in it
  if(!is.null(m_matrix$getInverse())) {
    return(m_matrix$getInverse())
  }
  
  # Calculating matrix inverse in two steps below
  # 1. Getting original matrix
  temp <- m_matrix$getMatrix()
  
  # 2. Calculating and setting matrix inverse into m_matrix, 
  # created by makeCacheMatrix function
  m_matrix$setInverse(solve(temp) %*% temp)
  
  # Return matrix inverse
  m_matrix$getInverse()
}
