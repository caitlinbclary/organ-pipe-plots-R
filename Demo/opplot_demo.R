##############################################################################
# Program:     opplot_demo.r
# Purpose:     Demonstrate making organ pipe plots
# Author:      Mary Prier, Biostat Global Consulting
#              Caitlin Clary, Biostat Global Consulting
# Delivered:   2017-01-28
# Updated:     2019-03-26
#              2020-07-30       Demo with updated function
#
# Input Data:  testdata_indiv_level.csv
# Required Functions: opplot.R
# Required Packages: doBy
###############################################################################

# Get needed packages if not already installed
if("doBy" %in% rownames(installed.packages()) == FALSE){
  install.packages("doBy")}

# Load required packages
library(doBy)

# Source the opplot.R function
# Change this file path to point to the program's location on your computer
source("C:/Documents/organ-pipe-plots-R/opplot.R")

# Set file paths (change paths to point to directories on your computer)
  # inPath = directory holding the data
  inPath <- file.path("C:/Documents/organ-pipe-plots-R/Demo")
  # outPath = where to save output
  outPath <- file.path("C:/Documents/organ-pipe-plots-R/Demo")

  # To save output in the right location, set working directory to outPath
  setwd(outPath)

  # Read in data for plotting
  inData <- read.csv(file = file.path(inPath,"testdata_indiv_level.csv"),
                     header = TRUE)

  ## Plotting Examples

  # Example 1 ----
  # All function options are listed, default appearance options selected
  # Plots to screen, does not save plot to disk

  opplot(dat = inData, stratvar = "stratum", clustvar = "clusterid",
         weightvar = "svyweight", yvar = "y", stratum = "Stratum A",
         barcolor1 = "hot pink", barcolor2 = "white",
         linecolor1 = "gray", linecolor2 = "gray",
         ylabel = "Percent of Cluster",
         ymin = 0, ymax = 100, yby = 50,
         title = "This is the title line",
         subtitle = "This is the subtitle line",
         footnote = "Footnote",
         output_to_screen = TRUE, filename = file.path(outPath, "test2"),
         platform = "pdf", sizew = 7, sizeh = 6, savedata = "",
         plotn = FALSE, nlinecolor = "black", nlinewidth = 1, nlinepattern = 2,
         ytitle2 = "Number of Respondents", yround2 = 5)

  # Example 2 ----
  # Same as example 1, but with sample size plotted (plotn = TRUE)

  opplot(dat = inData, stratvar = "stratum", clustvar = "clusterid",
         weightvar = "svyweight", yvar = "y", stratum = "Stratum A",
         barcolor1 = "hot pink", barcolor2 = "white",
         linecolor1 = "gray", linecolor2 = "gray",
         ylabel = "Percent of Cluster",
         ymin = 0, ymax = 100, yby = 50,
         title = "This is the title line",
         subtitle = "This is the subtitle line",
         footnote = "Footnote",
         output_to_screen = TRUE, filename = file.path(outPath, "test2"),
         platform = "pdf", sizew = 7, sizeh = 6, savedata = "",
         plotn = TRUE, nlinecolor = "black", nlinewidth = 1, nlinepattern = 2,
         ytitle2 = "Number of Respondents", yround2 = 5)

  # Example 3 ----
  # Minimal example, plotting clusters in all strata in dataset
  # Because of the number of clusters, this plot is not very readable

  opplot(dat = inData, clustvar = "clusterid", yvar = "y")

  # Example 4 ----
  # Same as example 3, but increasing plot dimensions to improve plot legibility

  opplot(dat = inData, clustvar = "clusterid", yvar = "y",
         sizew = 20, sizeh = 12)

  # Example 5 ----
  # Minimal example, plotting a single stratum

  opplot(dat = inData, clustvar = "clusterid", yvar = "y",
         stratvar = "stratum", stratum = "Stratum A")

  # Example 6 ----
  # Saving plot to disk as a PDF

  opplot(dat = inData, clustvar = "clusterid", yvar = "y",
         stratvar = "stratum", stratum = "Stratum B",
         filename = "StratumB", platform = "pdf",
         output_to_screen = FALSE)

  # Example 7 ----
  # Saving plot to disk as a PNG, adding cluster size line, changing colors

  opplot(dat = inData, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
         stratvar = "stratum", stratum = "Stratum B",
         filename = "StratumB", platform = "png",
         output_to_screen = FALSE,
         plotn = TRUE, nlinecolor = "black", nlinewidth = 1, nlinepattern = 2,
         barcolor1 = "#004709",
         barcolor2 = "#e1e1e1",
         title = "Organ Pipe Plot: Stratum B")

  # Example 8 ----
  # Changing bar colors, line color, line pattern

  opplot(dat = inData, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
         stratvar = "stratum", stratum = "Stratum C",
         output_to_screen = TRUE,
         plotn = TRUE, nlinecolor = "grey20", nlinewidth = 1, nlinepattern = 3,
         barcolor1 = "lightcoral",
         barcolor2 = "floralwhite",
         linecolor1 = "white", linecolor2 = "white",
         title = "Stratum C")

  # Example 9 ----
  # Changing the plot dimensions

  opplot(dat = inData, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
         stratvar = "stratum", stratum = "Stratum D",
         output_to_screen = TRUE,
         plotn = TRUE, nlinecolor = "grey20", nlinewidth = 1, nlinepattern = 3,
         sizew = 9, sizeh = 6,
         barcolor1 = "lightcoral",
         barcolor2 = "white",
         linecolor1 = "white", linecolor2 = "white",
         title = "Stratum D")

  # Example 10 ----
  # Instead of providing stratvar and stratum arguments, instead providing a
  # filtered dataset with only the stratum of interest. Produces the same plot
  # as example 9.

  subset_data <- inData[inData$stratum == "Stratum D",]

  opplot(dat = subset_data, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
         output_to_screen = TRUE,
         plotn = TRUE, nlinecolor = "grey20", nlinewidth = 1, nlinepattern = 3,
         sizew = 9, sizeh = 6,
         barcolor1 = "lightcoral",
         barcolor2 = "white",
         linecolor1 = "white", linecolor2 = "white",
         title = "Stratum D")

  # Example 11 ----
  # Specifying the savedata argument, which creates a .csv dataset with
  # information on each bar (cluster) in the plot.

  opplot(dat = inData, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
         stratvar = "stratum", stratum = "Stratum D",
         output_to_screen = TRUE,
         savedata = "Stratum_D_data")

  # Read in and view the dataset just created
  strat_D <- read.csv("Stratum_D_data.csv")
  View(strat_D)

  # Clean up ----

  # Close all graphics printed to the screen
  graphics.off()

  # Remove data and other objects
  rm(list = "inPath", "outPath", "inData", "subset_data", "strat_D")