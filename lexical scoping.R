makeCacheMatrix <- function(x = matrix) {
  ##creates a special 'matrix' object that can cache its inverse
  m <- NULL #set an empty inverse matrix
  set <- function(y) {
    ##sets the value of the matrix (x==y) to the parent env (<<-)
    x <<- y
    m <<- NULL #set an empty inverse matrix in the parent env (<<-)
  }
  get <- function() x #gets the value of the matrix
  setInv <- function(inverse) m <<- inverse
  ##sets the value of the inverse matrix (m) in the parent env (<<-)
  getInv <- function() m #gets the value of the inverse matrix
  list(set = set, get = get, setInv = setInv, getInv = getInv)
}
