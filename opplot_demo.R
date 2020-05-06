####################################################################################
# Program:     demo_opplot.r
# Purpose:     Demonstrate making organ pipe plots
# Author:      Mary Prier, Biostat Global Consulting
# Delivered:   2017-01-28
# Updated:     2019-03-26
# Input Data:  testdata_indiv_level.csv or testdata_indiv_level_stratum_numeric.csv
# Required Functions: opplot (source it in)
# Required Packages: doBy
####################################################################################

rm(list=ls())

#install.packages("doBy")
library(doBy) # If this lines errors, uncomment & run the install package doBy first (previous line)
source('Q:/Papers - Organ Pipe Plots/R programs/opplot.R')

# Set file paths
inPath <- file.path("Q:/Papers - Organ Pipe Plots/Test data")
outPath <- file.path("Q:/Papers - Organ Pipe Plots/R output")

# Read in data
inData <- read.csv(file=file.path(inPath,"testdata_indiv_level.csv"),header=T)

# Example 1: All options listed (default outputs plot to screen...plot NOT saved to disk)
#            Note: option "plotn=TRUE" for this example, but it's default is "plotn=FALSE"
opplot(dat=inData, stratvar="stratum", clustvar="clusterid",
       weightvar="svyweight", yvar="y", stratum="Stratum A",
       barcolor1="hot pink", barcolor2="white",
       linecolor1="gray", linecolor2="gray",
       ylabel="Percent of Cluster", 
       ymin=0, ymax=100, yby=50,
       title="This is the title line", subtitle="This is the subtitle line", footnote="Footnote",
       output_to_screen=T, filename=file.path(outPath,"test2"),
       platform="pdf", sizew=7, sizeh=6, savedata="opplot_stratumA_dataset",
       plotn=TRUE, nlinecolor="black", nlinewidth=1, nlinepattern=2,
       ytitle2="Number of Respondents", yround2=5)

# Let's break it down...

# Example 2: Minimum inputs for this dataset with multiple strata (specifies stratvar & stratum)
#            Note: Outputs plot to screen...plot NOT saved to disk
opplot(dat=inData, stratvar="stratum", clustvar="clusterid",
        weightvar="svyweight", yvar="y", stratum="Stratum A")

# Example 3: Save plot as .wmf (plot not output to screen)
opplot(dat=inData, stratvar="stratum", clustvar="clusterid",
       weightvar="svyweight", yvar="y", stratum="Stratum A",
       title="This is the title line",
       output_to_screen=F, filename=file.path(outPath,"stratumA"),
       platform="wmf")

# Example 4: Save plot as .pdf (plot not output to screen)
#            & save dataset of the opplot (includes 1 row per bar in the plot)
opplot(dat=inData, stratvar="stratum", clustvar="clusterid",
       weightvar="svyweight", yvar="y", stratum="Stratum A",
       title="This is the title line",
       output_to_screen=F, filename=file.path(outPath,"stratumA"),
       platform="pdf", savedata="opplot_stratumA_dataset")

# Example 5: Save plot as .png (plot not output to screen)
opplot(dat=inData, stratvar="stratum", clustvar="clusterid",
       weightvar="svyweight", yvar="y", stratum="Stratum A",
       title="This is the title line",
       output_to_screen=F, filename=file.path(outPath,"stratumA"),
       platform="png")

# Example 6: Output plot to screen & change bar colors & add titles
opplot(dat=inData, stratvar="stratum", clustvar="clusterid",
       weightvar="svyweight", yvar="y", stratum="Stratum A",
       barcolor1="blue", barcolor2="gray",
       linecolor1="black", linecolor2="black", 
       ylabel="This is the y-axis title line", title="This is the title line", 
       subtitle="This is the subtitle line", footnote="This is the footnote line")

# Example 7: Output plot to screen & change plot aspect ratio & y-axis increments
opplot(dat=inData, stratvar="stratum", clustvar="clusterid",
       weightvar="svyweight", yvar="y", stratum="Stratum A",
       title="Test Data", yby=20,
       output_to_screen=T, sizew=5, sizeh=5)

# Example 8: Output plot to screen & add number of respondents line
opplot(dat=inData, stratvar="stratum", clustvar="clusterid",
       weightvar="svyweight", yvar="y", stratum="Stratum A",
       title="This is the title line", output_to_screen=T, 
       plotn=T)

# Example 9: Output plot to screen & add number of respondents line & change its appearance
opplot(dat=inData, stratvar="stratum", clustvar="clusterid",
       weightvar="svyweight", yvar="y", stratum="Stratum A",
       title="This is the title line", output_to_screen=T, 
       plotn=T, nlinecolor="green", nlinewidth=3, nlinepattern=3,
       ytitle2="Number of Respondents", yround2=2)

# Example 10: Using a dataset with only one stratum
#            Output plot to screen & "stratvar" & "stratum" not provided 
# First, subset dataset to only one stratum...
inData2 <- inData[inData$stratum=="Stratum A",]

# Now "stratvar" & "stratum" do not need to be specified
opplot(dat=inData2, clustvar="clusterid",
        weightvar="svyweight", yvar="y",
        title="This is the title line",
        output_to_screen=T)

# Example 11: Output plot to screen & stratum variable is numeric
#             In this case, the "stratum" input is now "1" or 1 (as opposed to "Stratum A")
#             Or could call stratum="2" or stratum=2 or so on...
inData3 <- read.csv(file=file.path(inPath,"testdata_indiv_level_stratum_numeric.csv"),header=T)
opplot(dat=inData3, stratvar="stratum", clustvar="clusterid",
       weightvar="svyweight", yvar="y", stratum=1,
       title="This is the title line",
       output_to_screen=T)

# Close all graphics printed to the screen
graphics.off()
