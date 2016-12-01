dump <- function(msg){
  print(msg)
  print(sprintf(
    '(a=%s, b=%s)', a$x, b$x
  ))
  print(sprintf(
    '(b->a=%s, a->b=%s)', b$i$x, a$i$x
  ))
}

a <- new.env()
b <- new.env()

a$x <- 1
b$x <- 2

a$i <- b
b$i <- a

dump('environment: original state')

b$x <- 99
dump('environment: b$x <- 99')

a <- list()
b <- list()

a$x <- 1
b$x <- 2

a$i <- b
b$i <- a

dump('environment: original state')

b$x <- 99
dump('environment: b$x <- 99')


a <- 2 # the value is immutable
b <- a
a <- 3 # this reassignment creates a new value, so now a != b
print(sprintf("a=%s b=%s", a, b))



f1 <- function(x=1){ x }
f2 <- function(FUN=f1){ FUN() } 
f3 <- f1
print(sprintf("f1->%s, f2->%s, f3->%s", f1(), f2(), f3()))
formals(f1)$x = 2
print(sprintf("f1->%s, f2->%s, f3->%s", f1(), f2(), f3()))

y <- 1
foo <- function(x=y) { y }
foo()
y <- 2
foo()


foo <- function(x=y) { function(z=x) { z } }

foo <- function(x=y) {
  bar <- function(){ x };
  formals(bar)$x <- substitute(x)
  bar
}
bar <- foo()
y=3
bar()
y=4
bar()
u=42
bar <- foo(u)
bar
