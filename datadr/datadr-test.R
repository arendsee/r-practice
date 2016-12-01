library(datadr)
library(trelliscope)
library(housingData)
library(lattice)

byCounty <- divide(housing, c('county', 'state'), update=TRUE)

byCounty

summary(byCounty)

# Function to be applied across all subsets
lmCoef <- function(x)
  coef(lm(medListPriceSqft ~ time, data = x))[2]

# Apply function, but this is lazy, won't actually be computed until recombined
byCountySlope <- addTransform(byCounty, lmCoef)

countySlops <- recombine(byCountySlope, combRbind)

vdbConn("vdb", name = "yolo", autoYes = TRUE)

timePanel <- function(x) {
  xyplot(medListPriceSqft + medSoldPriceSqft ~ time,
    data = x, auto.key = TRUE, ylab = "Price / Sq. Ft.")
}

timePanel(byCounty[[20]]$value)

priceCog <- function(x) { list(
  slope     = cog(lmCoef(x), desc = "list price slope"),
  meanList  = cogMean(x$medListPriceSqft),
  listRange = cogRange(x$medListPriceSqft),
  nObs      = cog(length(which(!is.na(x$medListPriceSqft))),
    desc = "number of non-NA list prices")
)}

priceCog(byCounty[[1]]$value)

makeDisplay(
  byCounty,
  name    = "list_sold_vs_time_datadr_tut",
  desc    = "List and sold price over time",
  panelFn = timePanel,
  cogFn   = priceCog,
  width   = 400, height = 400,
  lims    = list(x = "same")
)

# http://deltarho.org/docs-datadr/#distributed_data_objects
