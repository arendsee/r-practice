foo <- function(){a}
formals(foo)$a <- 1
foo
foo()

bar <- function(a){a}
formals(bar)$a <- 1
bar
foo()

bar <- function(a){a}
formals(bar)[['a']] <- 1
bar
foo()


x <- 1

foo <- function(){a}
formals(foo)$a <- substitute(x)
foo
foo()

bar <- function(a){a}
formals(bar)$a <- substitute(x)
bar
bar()

bar <- function(a){a}
formals(bar)[['a']] <- substitute(x)
bar
bar()

run <- function(f) {x=2; print(f())}
run(foo)
run(bar)

x <- 1

`a<-` <- function(x, value){
  formals(x)[['a']] <- substitute(value)
  x
}

foo <- function(){}
a(foo) <- x
foo

bar <- function(a){}
a(bar) <- x
bar

foo_maker <- function() { foo <- function( ){}; a(foo) <- x; foo }
bar_maker <- function() { bar <- function(a){}; a(bar) <- x; bar }

foo_maker()

maker <- function(op) {
  fun <- if(op == 'foo') foo_maker() else bar_maker()
  parent.env(environment(fun)) <- parent.frame()
  fun
}

foo <- maker('foo')
bar <- maker('bar')

`b<-` <- function(x, value){
  formals(x)[['.b']] <- substitute(value)
  x
}

bar_maker <- function() { bar <- function(){c(a,.b)}; a(bar) <- x; b(bar) <- 2*x; bar }
bar <- bar_maker()
bar()
