# Program:     opplot_demo.r
# Purpose:     Demonstrate making organ pipe plots
# Author:      Mary Prier, Biostat Global Consulting
#              Caitlin B. Clary, Biostat Global Consulting

# Delivered:   2017-01-28
# Updated:     2019-03-26
#              2020-08-05       Demo updated function
#              2024-10-08       Update demo examples, including new features

# Input Data:  testdata_indiv_level.csv
# Required Functions: opplot.R
# Required Packages: dplyr, stringr, ggplot2, doBy

# Note: see the end of this R file for comments explaining each argument to the
# opplot function

# Setup ----

# Get needed packages if not already installed
pkg_list <- c("dplyr", "stringr", "ggplot2", "doBy")
for(i in seq_along(pkg_list)){
  if (!pkg_list[i] %in% rownames(installed.packages())){install.packages(pkg_list[i])}
}

# Load required packages
library(dplyr); library(stringr); library(ggplot2); library(doBy)

# Define directory where organ pipe plot function and demo data are saved
# Modify this line to use the right path on your computer!
dir <- "C:/Users/clary/Biostat Global Dropbox/Caitlin Clary/CBC GitHub Repos/organ-pipe-plots-R/"

# Source the opplot.R function
source(paste0(dir, "opplot_dev.R"))

# Read in data for plotting
inData <- read.csv(file = paste0(dir, "Demo/testdata_indiv_level.csv"),
                   header = TRUE)

# Plot examples ----

## Example 1 ----
## Plot stratum A with default appearance options, output plot to screen

opplot(
  dat = inData, stratvar = "stratum", clustvar = "clusterid", yvar = "y",
  stratum = "Stratum A", output_to_screen = TRUE
)

## Example 2 ----
## Add title, subtitle, and footnote; add line showing # of respondents per cluster

opplot(
  dat = inData, stratvar = "stratum", clustvar = "clusterid", yvar = "y",
  stratum = "Stratum A", output_to_screen = TRUE,

  title = "Stratum A",
  subtitle = "Coverage and respondents per cluster",
  footnote = "Dashed line indicates respondents per cluster; see Y axis on the right side of the plot.",

  plotn = TRUE
)

## Example 3 ----
## Plot stratum C, defining high and low coverage thresholds

opplot(
  dat = inData, stratvar = "stratum", clustvar = "clusterid", yvar = "y",
  stratum = "Stratum C", output_to_screen = TRUE,

  title = "Stratum C",
  subtitle = "Coverage and respondents per cluster",
  footnote = "Dashed line indicates respondents per cluster; see Y axis on the right side of the plot.",

  plotn = TRUE,

  covgcategories = TRUE,
  lowcovgthreshold = 40,
  highcovgthreshold = 80
)

## Example 4 ----
## Add lines indicating coverage thresholds and customize line color. Note that
## colors can be specified as R color names or as hex color codes.

opplot(
  dat = inData, stratvar = "stratum", clustvar = "clusterid", yvar = "y",
  stratum = "Stratum C", output_to_screen = TRUE,

  title = "Stratum C",
  subtitle = "Coverage and respondents per cluster",
  footnote = "Dashed line indicates respondents per cluster; see Y axis on the right side of the plot.",

  plotn = TRUE,

  covgcategories = TRUE,
  lowcovgthreshold = 40,
  highcovgthreshold = 80,

  lowcovgthresholdline = TRUE,
  highcovgthresholdline = TRUE,
  lowcovgthresholdlinecolor = "darkred",
  highcovgthresholdlinecolor = "forestgreen"
)

## Example 5 ----
## Plotting clusters in *all* strata in dataset - because of the number of
## clusters, this plot is not very readable!

opplot(dat = inData, clustvar = "clusterid", yvar = "y",
       output_to_screen = TRUE)

## Example 6 ----
## Modify example 2, adding weightvar argument, customize colors and n line appearance

opplot(
  dat = inData, stratvar = "stratum", clustvar = "clusterid", yvar = "y",
  weightvar = "svyweight",
  stratum = "Stratum A", output_to_screen = TRUE,

  barcolor1 = "#0b5394",
  barcolor2 = "#cfe2f3",
  linecolor1 = "#eeeeee",
  linecolor2 = "#eeeeee",

  title = "Stratum A",
  subtitle = "Coverage and respondents per cluster",
  footnote = "Dashed line indicates respondents per cluster; see Y axis on the right side of the plot.",

  plotn = TRUE,
  nlinecolor = "#fff469",
  nlinewidth = 0.8,
  nlinepattern = 2
)

## Example 7 ----
## Plot Stratum D, save to disk as PNG and plot to screen

opplot(
  dat = inData, stratvar = "stratum", clustvar = "clusterid", yvar = "y",
  stratum = "Stratum D", output_to_screen = TRUE,
  filename = "Q:/opplot_test_example_7",
  platform = "png",

  title = "Stratum D",
  subtitle = "Coverage and respondents per cluster",
  footnote = "Dashed line indicates respondents per cluster; see Y axis on the right side of the plot.",

  plotn = TRUE
)

## Example 8 ----
## Update example 7, this time saving as PDF, changing plot dimensions, and
## changing Y axis increments, and changing main Y axis title

opplot(
  dat = inData, stratvar = "stratum", clustvar = "clusterid", yvar = "y",
  stratum = "Stratum D", output_to_screen = TRUE,
  filename = "Q:/opplot_test_example_8",
  platform = "pdf",
  sizew = 12,
  sizeh = 8,

  ylabel = "Cluster Coverage (%)",
  yby = 25,

  title = "Stratum D",
  subtitle = "Coverage and respondents per cluster",
  footnote = "Dashed line indicates respondents per cluster; see Y axis on the right side of the plot.",

  plotn = TRUE
)

## Example 9 ----
## Instead of providing stratvar and stratum arguments, filter the input dataset
## to contain only the stratum of interest. This approach produces the same plot
## as example 8.

subset_data <- inData[inData$stratum == "Stratum D",]

opplot(
  dat = subset_data, clustvar = "clusterid", yvar = "y",
  output_to_screen = TRUE,

  ylabel = "Cluster Coverage (%)",
  yby = 25,

  title = "Stratum D",
  subtitle = "Coverage and respondents per cluster",
  footnote = "Dashed line indicates respondents per cluster; see Y axis on the right side of the plot.",

  plotn = TRUE
)

## Example 10 ----
## The stratum variable can be numeric rather than character. This plot of
## stratum 4 is the same as the plot of stratum D in examples 8 and 9

# Recode stratum variable as numeric
inDataNumeric <- inData
inDataNumeric$stratum <- as.numeric(as.factor(inDataNumeric$stratum))

opplot(
  dat = inDataNumeric, stratvar = "stratum", clustvar = "clusterid", yvar = "y",
  stratum = 4, output_to_screen = TRUE,

  ylabel = "Cluster Coverage (%)",
  yby = 25,

  title = "Stratum D",
  subtitle = "Coverage and respondents per cluster",
  footnote = "Dashed line indicates respondents per cluster; see Y axis on the right side of the plot.",

  plotn = TRUE
)

## Example 11 ----
## Specifying the savedata argument, which creates a dataset with
## information on each bar (cluster) in the plot.

opplot(
  dat = inData, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
  stratvar = "stratum", stratum = "Stratum D",
  output_to_screen = TRUE,
  savedata = "Q:/opplot_test_example_11_stratum_D_data",
  savedatatype = "csv"
)

# Read in and view the dataset just created
strat_D <- read.csv("Q:/opplot_test_example_11_stratum_D_data.csv")
View(strat_D)

## Example 12 ----
## Saving data as a .rds file instead of a .csv

opplot(
  dat = inData, clustvar = "clusterid", yvar = "y", weightvar = "svyweight",
  stratvar = "stratum", stratum = "Stratum D",
  output_to_screen = TRUE,
  savedata = "Q:/opplot_test_example_11_stratum_D_data",
  savedatatype = "rds"
)

# Read in and view the dataset just created
strat_D <- readRDS("Q:/opplot_test_example_11_stratum_D_data.rds")
View(strat_D)

# Clean up ----

# Close all graphics printed to the screen
graphics.off()

# Remove data and other objects
rm(list = "inData", "inDataNumeric", "subset_data", "strat_D", "dir", "i",
   "pkg_list", "opplot", "vcqi_check_color")


# Notes: function arguments ----

# # Required arguments: dat, clustvar, yvar
# dat,
# clustvar,
# yvar,
#
# # Optional arguments
#
# ## Define variables with information on weights and strata
# weightvar = NA,
# stratvar = NA,
#
# ## Specific stratum to plot results for
# stratum = "",
#
# barcolor1 = "hotpink",  # Color for portion of bar where yvar = 1
# barcolor2 = "white",    # Color for portion of bar where yvar = 1
# linecolor1 = "gray",    # Color for lines separating lower portion of bars
# linecolor2 = "gray",    # Color for lines separating upper portion of bars
#
# ylabel = "Percent of Cluster",  # Label for y axis
# ymin = 0,   # Minimum value for Y axis
# ymax = 100, # Maximum value for Y axis
# yby = 50,   # Increment for Y axis breaks
#
# title = "",    # Title of the plot
# subtitle = "", # Subtitle of the plot
# footnote = "", # Footnote of the plot
#
# plotn = FALSE,        # Plot a line showing the # of respondents in each cluster
# nlinecolor = "black", # Color of line indicating # of respondents
# nlinewidth = 0.75,    # Width of line indicating # of respondents
# nlinepattern = 2,     # Pattern of line indicating # of respondents
# ytitle2 = "Number of Respondents", # Label for secondary Y axis
# yround2 = 5,                       # Increment for secondary Y axis breaks
#
# covgcategories = FALSE, # Stratify plot into high, medium, & low coverage categories
#
# ## The numeric percent value (0-100) used to identify low coverage; clusters
# ## with coverage less than or equal to this number will be assigned to the low
# ## coverage category. Used when covgcategories = TRUE.
# lowcovgthreshold = NA,
#
# ## The numeric percent value (0-100) used to identify high coverage; clusters
# ## with coverage greater than or equal to this number will be assigned to the
# ## high coverage category. Used when covgcategories = TRUE.
# highcovgthreshold = NA,
#
# barcolorhigh1 = "#67A9CF", # Color for portion of high coverage bars where yvar = 1
# barcolormid1 = "#000080",  # Color for portion of medium coverage bars where yvar = 1
# barcolorlow1 = "#FF5B00",  # Color for portion of low coverage bars where yvar = 1
# barcolorhigh2 = "#f0f0f0", # Color for portion of high coverage bars where yvar = 0
# barcolormid2 = "#f0f0f0",  # Color for portion of medium coverage bars where yvar = 0
# barcolorlow2 = "#f0f0f0",  # Color for portion of low coverage bars where yvar = 0
#
# linecolorhigh1 = "gray", # Color for lines separating lower portion of high covg bars
# linecolormid1 = "gray",  # Color for lines separating lower portion of medium covg bars
# linecolorlow1 = "gray",  # Color for lines separating lower portion of low covg bars
# linecolorhigh2 = "gray", # Color for lines separating upper portion of high covg bars
# linecolormid2 = "gray",  # Color for lines separating upper portion of medium covg bars
# linecolorlow2 = "gray",  # Color for lines separating upper portion of low covg bars
#
# lowcovgthresholdline = FALSE,  # Show line indicating low coverage threshold
# highcovgthresholdline = FALSE, # Show line indicating high coverage threshold
#
# lowcovgthresholdlinecolor = "red",  # Color for lowcovgthresholdline
# highcovgthresholdlinecolor = "red", # Color for highcovgthresholdline
#
# output_to_screen = FALSE,  # Show the plot in plot window?
# filename = NA_character_,  # Path to save the plot
# platform = "png", # Type of plot file (may be png, pdf, or wmf)
# sizew = 7, # Width of the plot file in inches
# sizeh = 6, # Height of the plot file in inches
#
# savedata = NA_character_,  # Path to save underlying data (if NA, data will not be saved)
# savedatatype = "csv"       # File type for saving underlying data (may be csv or rds)
