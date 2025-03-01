## This file shows how to Tetrad searches interactively in R using the
## TetradSearch class for a discrete example.
##
## Please make your own copy of this R file if you want to make sure your
## changes don't get overwritten by future `git pull's.
##
## You will need to adjust this path to your path for py-tetrad.
##
## For purposes of these example scripts, we will assume that in RStudio one
## has loaded the py-tetrad directory as the project, so that the project
## directory is the py-tetrad/pytetrad directory. For your own scripts, these 
## paths can be adjusted.
if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here")
}

library(here)
project_root <- here()
setwd(project_root)

library(reticulate)

## It's best to change hyphens and periods in variable names to underscores
## for reading data into R.
data <- read.csv("pytetrad/resources/bridges.data.version211_rev.txt", colClasses = "character", sep="\t", header=TRUE)

# ## The read.table function will read decimal columns as real ('numeric')
# ## and integer columns as discrete. When passing data from R into Python,
# ## integer columns will still be interpreted as discrete, so we have to
# ## specify in the data frame for this data that they are to be interpreted
# ## as continuous (i.e., 'numeric').
 # i <- c(1, 11)
# data[ , i] <- apply(data[ , i], 2, function(x) as.integer(x))

## Make a TetradSearch object.
source_python("pytetrad/tools/TetradSearch.py")
ts <- TetradSearch(data)

ts$use_bdeu()
ts$use_chi_square()

# RIVER	ERECTED	PURPOSE	LENGTH	LANES	CLEAR_G	T_OR_D	MATERIAL	SPAN	REL_L	TYPE

# Set some knowledge--let's try to predict TYPE
ts$add_to_tier(0, "RIVER")
ts$add_to_tier(0, "ERECTED")
ts$add_to_tier(0, "PURPOSE")
ts$add_to_tier(0, "LENGTH")
ts$add_to_tier(0, "LANES")
ts$add_to_tier(0, "CLEAR_G")
ts$add_to_tier(0, "T_OR_D")
ts$add_to_tier(0, "MATERIAL")
ts$add_to_tier(0, "SPAN")
ts$add_to_tier(0, "REL_L")
ts$add_to_tier(1, "TYPE")

ts$set_forbidden("RIVER", "ERECTED")
ts$set_required("LANES", "MATERIAL")

# Run the search
ts$run_grasp()

## Print the graph and grab the DOT format string (for Grasphviz)
print(ts$get_string())
dot <- ts$get_dot()

# ## Allows RStudio to render graphs in the Viewer window.
library('DiagrammeR')
grViz(dot)