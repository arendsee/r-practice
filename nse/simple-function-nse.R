foo <- function(x) { 2 * x }

class(foo)

run <- function(f, ...) {
  print(class(f))
  print(f)
  print( f(...) )

  # Now we get the 'name' of the function
  sf <- substitute(f)
  print(class(sf))
  print(sf)
  #sf(...) # won't work since sf is a name not a function

  esf <- eval(sf)
  print(class(esf))
  print(esf)
  print( esf(...) )

  fcall <- substitute(f(...))
  print(class(fcall))
  print(fcall)
  print(eval(fcall))
}

run(foo, 2)
