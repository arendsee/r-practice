# =======================
# Simple case

# Return a function with a default value set
bar <- function(x){
  baz <- function(.x){
    .x
  }
  formals(baz)$.x <- x
  baz
}


foo <- function(...){
  bar(...)
}

y <- 1
(f <- foo(x=y))
f()

# This default value is constant, referring to the x in the bar environment
y <- 2
f()


# =======================
# Now what if I want the default value to be dynamic, evaluated in foo's scope?

# Just add substitute
bar <- function(x){
  baz <- function(.x){
    .x
  }
  formals(baz)$.x <- substitute(x)
  baz
}

y <- 1
(f <- foo(x=y))
f()

# This default value is constant, referring to the x in the bar environment
y <- 2
f()

# OK, all is well, but what if I put this in a function?


# ======================

a <- 3
bas <- foo(x=a)
bas()

bif <- function(){
  z <- 3
  bas <- foo(x=z)
  bas()
}
bif()

# Woah! What happened? This is an environmental problem.


# ======================
# lets print out the environments as we go along

# Return a function with a default value set
bar_ <- function(x){
  baz <- function(.x){
    .x
  }
  cat("bar environment = "); print(environment());
  formals(baz)$.x <- substitute(x)
  baz
}

foo_ <- function(...){
  cat("foo environment = "); print(environment());
  bar_(...)
}

bif <- function(){
  z <- 3
  bas <- foo_(x=z)
  bes <- function(){}

  cat("bif environment = "); print(environment());
  cat("bas environment = "); print(environment(bas));
  cat("bes environment = "); print(environment(bes));

  bas
}
bif()
bif()()

# But it does still work in the global environment
z <- 5
bif()()


# See bas is not really a member of 

bif <- function(){
  z <- 3
  bas <- foo(x=z)
  bes <- function(){}
  environment(bas) <- environment()

  bas
}
bif()
bif()()

# But now it ignores your input in the global environment
z <- 6
bif()()



# ==================================

# Just add substitute
bar <- function(g){
  baz <- function(.g){
    .g()
  }
  formals(baz)$.g <- substitute(g)
  baz
}

goo <- function() 1
(f <- foo(g=goo))
f()

# This default value is constant, referring to the x in the bar environment
y <- 2
f()


# ==================================



one   <- function() 1
two   <- function() 2
three <- function() 3

add <- function(x, y){
  x() + y()
}

bar <- function(f=one, g=three){
  fun <- function(.fun, .gun){
    add( .fun, .gun )
  }
  formals(fun)$.fun <- substitute(f)
  formals(fun)$.gun <- substitute(g)
  fun
}

#' @rdname node
#' @export
foo <- function(...){
  fun <- bar(...)
  fun
}

mybar <- foo(f=two, g=three)
mybar()


# ===============================

f <- function(){
  x='f'
  function() c(x, 'f')
}

g <- function(){
  x='g'
  function() c(x, 'g')
}

f_ <- f()
g_ <- g()

f_()
environment(f_) <- environment(g_)
f_()



# ===============================

x='global'

bar <- function(){
  x='bar'
  function() x
}

foo <- function(){
  x='foo'
  bar()
}

g <- foo()
g()

# Now if I want to return bar's closure, but evaluate it in the global context:

bar <- function(){
  x='bar'
  function() c(x, y)
}

foo <- function(){
  y='foo'
  g <- bar()
  parent.env(environment(g)) <- environment()
  # parent.env(environment(g)) <- parent.frame()
  # environment(g) <- parent.frame()
  g
}

x='global_x'
y='global_y'
h <- foo()
h()
