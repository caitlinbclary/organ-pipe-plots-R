####################################################################################
# Program:     opplot_demo.r
# Purpose:     Demonstrate making organ pipe plots
# Author:      Mary Prier, Biostat Global Consulting
#              Caitlin Clary, Biostat Global Consulting
# Delivered:   2017-01-28
# Updated:     2019-03-26
#              2020-07-30       Demo with updated function
# 
# Input Data:  testdata_indiv_level.csv or testdata_indiv_level_stratum_numeric.csv
# Required Functions: opplot.R
# Required Packages: doBy
####################################################################################

# Get needed packages if not already installed
if("doBy" %in% rownames(installed.packages()) == FALSE){
        install.packages("doBy")}

# Load required packages 
library(doBy) 

# Source the opplot.R function 
# Change this file path to point to the program's location on your computer
source('C:/Documents/opplot.R')

# Set file paths: 
  # inPath = directory holding the data 
  # outPath = directory for saved output 
inPath <- file.path("C:/Documents/Data")
outPath <- file.path("C:/Documents/Output")

# Read in data
inData <- read.csv(file = file.path(inPath,"testdata_indiv_level.csv"), header = TRUE)

## Plotting Examples 

# Example 1 ---- 
# All function options are listed, default appearance options selected 
# Plot to screen, do not save plot to disk 

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
# Minimal example, plotting all strata (because of the number of clusters in the example data, this plot isn't very readable)

opplot(dat = inData, clustvar = "clusterid", yvar = "y")

# Example 4 ----
# Minimal example, plotting a single stratum 

opplot(dat = inData, clustvar = "clusterid", yvar = "y", 
       stratvar = "stratum", stratum = "Stratum A")

# Example 5 ----
# Saving PDF plot to disk

opplot(dat = inData, clustvar = "clusterid", yvar = "y", 
       stratvar = "stratum", stratum = "Stratum B", 
       filename = "StratumB", platform = "pdf",
       output_to_screen = FALSE)

# Example 6 ----
# Saving plot to disk as a PNG & changing some appearance options

opplot(dat = inData, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
       stratvar = "stratum", stratum = "Stratum B", 
       filename = "StratumB", platform = "png",
       output_to_screen = FALSE,
       plotn = TRUE, nlinecolor = "black", nlinewidth = 1, nlinepattern = 2,
       barcolor1 = "#004709",
       barcolor2 = "#e1e1e1",
       title = "Test Title: Stratum B")

# Example 7 ----
# Changing bar and line colors, line pattern
opplot(dat = inData, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
       stratvar = "stratum", stratum = "Stratum C", 
       output_to_screen = TRUE,
       plotn = TRUE, nlinecolor = "grey20", nlinewidth = 1, nlinepattern = 3,
       barcolor1 = "lightcoral",
       barcolor2 = "floralwhite",
       linecolor1 = "white", linecolor2 = "white",
       title = "Stratum C")

# Example 8 ----
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

# Example 9 ----
# Instead of providing stratvar and stratum arguments, instead 
# providing a filtered dataset with only the stratum of interest. 

subset_data <- inData[inData$stratum == "Stratum D",]

opplot(dat = subset_data, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
       output_to_screen = TRUE,
       plotn = TRUE, nlinecolor = "grey20", nlinewidth = 1, nlinepattern = 3,
       sizew = 9, sizeh = 6,
       barcolor1 = "lightcoral",
       barcolor2 = "white",
       linecolor1 = "white", linecolor2 = "white",
       title = "Stratum D")

# Example 10 ----
# Specifying the savedata argument, which creates a .csv dataset
# with information on each bar (cluster) in the plot. 
# In this example the plot is neither saved nor output to the screen

opplot(dat = inData, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
       stratvar = "stratum", stratum = "Stratum D", 
       output_to_screen = FALSE,
       savedata = "Stratum_D_data")

# Read in the dataset just saved  
strat_D <- read.csv("Stratum_D_data.csv")

# View the dataset 
View(strat_D)

# End of demo ----

# Close all graphics printed to the screen
graphics.off()

# Remove data and other objects 
rm(list = "inPath", "outPath", "inData", "subset_data", "strat_D")