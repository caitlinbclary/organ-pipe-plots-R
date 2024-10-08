# Organ pipe plot function
# Produce a bar plot showing coverage in each cluster in a stratum

# Dependencies: dplyr, stringr, ggplot2, doBy

# Function to check color validity
vcqi_check_color <- function(color){
  res <- try(col2rgb(color), silent = TRUE)
  return(!"try-error" %in% class(res))
}

opplot <- function(
  # Required arguments: dat, clustvar, yvar
  dat,
  clustvar,
  yvar,

  # Optional arguments

  ## Define variables with information on weights and strata
  weightvar = NA,
  stratvar = NA,

  ## Specific stratum to plot results for
  stratum = "",

  barcolor1 = "hotpink",  # Color for portion of bar where yvar = 1
  barcolor2 = "white",    # Color for portion of bar where yvar = 1
  linecolor1 = "gray",    # Color for lines separating lower portion of bars
  linecolor2 = "gray",    # Color for lines separating upper portion of bars

  ylabel = "Percent of Cluster",  # Label for y axis
  ymin = 0,   # Minimum value for Y axis
  ymax = 100, # Maximum value for Y axis
  yby = 50,   # Increment for Y axis breaks

  title = "",    # Title of the plot
  subtitle = "", # Subtitle of the plot
  footnote = "", # Footnote of the plot

  plotn = FALSE,        # Plot a line showing the # of respondents in each cluster
  nlinecolor = "black", # Color of line indicating # of respondents
  nlinewidth = 0.75,    # Width of line indicating # of respondents
  nlinepattern = 2,     # Pattern of line indicating # of respondents
  ylabel2 = "Number of Respondents", # Label for secondary Y axis
  yround2 = 5,                       # Increment for secondary Y axis breaks

  covgcategories = FALSE, # Stratify plot into high, medium, & low coverage categories

  ## The numeric percent value (0-100) used to identify low coverage; clusters
  ## with coverage less than or equal to this number will be assigned to the low
  ## coverage category. Used when covgcategories = TRUE.
  lowcovgthreshold = NA,
  ## The numeric percent value (0-100) used to identify high coverage; clusters
  ## with coverage greater than or equal to this number will be assigned to the
  ## high coverage category. Used when covgcategories = TRUE.
  highcovgthreshold = NA,

  barcolorhigh1 = "#67A9CF", # Color for portion of high coverage bars where yvar = 1
  barcolormid1 = "#000080",  # Color for portion of medium coverage bars where yvar = 1
  barcolorlow1 = "#FF5B00",  # Color for portion of low coverage bars where yvar = 1
  barcolorhigh2 = "#f0f0f0", # Color for portion of high coverage bars where yvar = 0
  barcolormid2 = "#f0f0f0",  # Color for portion of medium coverage bars where yvar = 0
  barcolorlow2 = "#f0f0f0",  # Color for portion of low coverage bars where yvar = 0

  linecolorhigh1 = "gray", # Color for lines separating lower portion of high covg bars
  linecolormid1 = "gray",  # Color for lines separating lower portion of medium covg bars
  linecolorlow1 = "gray",  # Color for lines separating lower portion of low covg bars
  linecolorhigh2 = "gray", # Color for lines separating upper portion of high covg bars
  linecolormid2 = "gray",  # Color for lines separating upper portion of medium covg bars
  linecolorlow2 = "gray",  # Color for lines separating upper portion of low covg bars

  lowcovgthresholdline = FALSE,  # Show line indicating low coverage threshold
  highcovgthresholdline = FALSE, # Show line indicating high coverage threshold

  lowcovgthresholdlinecolor = "red",  # Color for lowcovgthresholdline
  highcovgthresholdlinecolor = "red", # Color for highcovgthresholdline

  output_to_screen = FALSE,  # Show the plot in plot window?
  filename = NA_character_,  # Path to save the plot
  platform = "png", # Type of plot file (may be png, pdf, or wmf)
  sizew = 7, # Width of the plot file in inches
  sizeh = 6, # Height of the plot file in inches

  savedata = NA_character_,  # Path to save underlying data (if NA, data will not be saved)
  savedatatype = "csv"       # File type for saving underlying data (may be csv or rds)
){

  # Ensure data is a data.frame object
  dat <- as.data.frame(dat)

  # Check variable name arguments
  if (clustvar != "1"){
    if (length(names(dat)[names(dat) == clustvar]) == 0){
      stop(paste0("Cannot find a variable called ", clustvar,
                  " in the dataset ", quote(dat), "."))
    }}

  if (length(names(dat)[names(dat) == yvar]) == 0){
    stop(paste0("Cannot find a variable called ", yvar,
                " in the dataset ", quote(dat), "."))
  }

  if (!is.na(stratvar) & stratvar != ""){
    if (length(names(dat)[names(dat) == stratvar]) == 0){
      stop(paste0("Cannot find a variable called ", stratvar,
                  " in the dataset ", quote(dat), "."))
    }
  }

  if (!is.na(weightvar) & weightvar != ""){
    if (length(names(dat)[names(dat) == weightvar]) == 0){
      stop(paste0("Cannot find a variable called ", weightvar,
                  " in the dataset ", quote(dat), "."))
    }
  }

  # Create variables
  dat$clustvar <- get(clustvar, dat)
  dat$yvar <- get(yvar, dat)

  if (!is.na(stratvar) & stratvar != ""){
    dat$stratvar <- get(stratvar, dat)
  } else {
    print("Warning: stratvar was not specified. Treating the entire dataset as one stratum.")
    dat$stratvar <- 1
  }

  if (!is.na(weightvar) & weightvar != ""){
    dat$weightvar = get(weightvar,dat)
  } else {
    dat$weightvar <- 1
  }

  # Check data and provide warnings if necessary
  dat_orig <- dat

  # Check "yvar" is either 0 or 1 -> records with yvar!= 0 or 1 will be ignored
  y_ind <- which(!(dat$yvar %in% c(0, 1)))
  if (length(y_ind) > 0) {
    print(paste(
      "Warning:", length(y_ind),
      "records had yvar without value 0 or 1, and therefore will be ignored."))
  }

  # Check "weightvar" -> records with weightvar=missing or weightvar=0 will be ignored
  wt_ind <- which(dat$weightvar %in% c(0, NA))
  if (length(wt_ind) > 0) {
    print(paste(
      "Warning:", length(wt_ind),
      "records had weightvar with value 0 or missing. These records will be ignored."))
  }

  # Check "clustvar" -> records with clustvar=missing will be ignored
  cl_ind <- which(is.na(dat$clustvar))
  if (length(cl_ind) > 0) {
    print(paste(
      "Warning:", length(cl_ind),
      "records had a missing clustvar value. These records will be ignored."))
  }

  # Subset data to ignore rows flagged above
  if (length(c(y_ind, wt_ind, cl_ind)) > 0) {
    dat <- dat[-c(y_ind, wt_ind, cl_ind),]
    print(paste(
      "Original dataset had", nrow(dat_orig),
      "rows. The dataset used to make OP plot has", nrow(dat), "rows."))
  }

  # Check if plot is saved to disk, that the platform specified is valid
  if (!is.na(filename)) {
    if (!platform %in% c("wmf", "pdf", "png")) {
      print(paste("Invalid platform specified: ", platform))
      print("Either set it to wmf or pdf or png. For now, it will be set to png")
      platform <- "png"
    }
  }

  # Check supplied colors
  if (covgcategories == TRUE){

    invalid_colors <- NULL

    if (!vcqi_check_color(barcolorhigh1)){
      invalid_colors <- c(invalid_colors, paste0("barcolorhigh1 = ", barcolorhigh1))
      barcolorhigh1 <- "#67A9CF"
    }

    if (!vcqi_check_color(barcolormid1)){
      invalid_colors <- c(invalid_colors, paste0("barcolormid1 = ", barcolormid1))
      barcolormid1 <- "#000080"
    }

    if (!vcqi_check_color(barcolorlow1)){
      invalid_colors <- c(invalid_colors, paste0("barcolorlow1 = ", barcolorlow1))
      barcolorlow1 <- "#FF5B00"
    }

    if (!vcqi_check_color(barcolorhigh2)){
      invalid_colors <- c(invalid_colors, paste0("barcolorhigh2 = ", barcolorhigh2))
      barcolorhigh2 <- "#f0f0f0"
    }

    if (!vcqi_check_color(barcolormid2)){
      invalid_colors <- c(invalid_colors, paste0("barcolormid2 = ", barcolormid2))
      barcolormid2 <- "#f0f0f0"
    }

    if (!vcqi_check_color(barcolorlow2)){
      invalid_colors <- c(invalid_colors, paste0("barcolorlow2 = ", barcolorlow2))
      barcolorlow2 <- "#f0f0f0"
    }

    if (!vcqi_check_color(linecolorhigh1)){
      invalid_colors <- c(invalid_colors, paste0("linecolorhigh1 = ", linecolorhigh1))
      linecolorhigh1 <- "gray"
    }

    if (!vcqi_check_color(linecolormid1)){
      invalid_colors <- c(invalid_colors, paste0("linecolormid1 = ", linecolormid1))
      linecolormid1 <- "gray"
    }

    if (!vcqi_check_color(linecolorlow1)){
      invalid_colors <- c(invalid_colors, paste0("linecolorlow1 = ", linecolorlow1))
      linecolorlow1 <- "gray"
    }

    if (!vcqi_check_color(linecolorhigh2)){
      invalid_colors <- c(invalid_colors, paste0("linecolorhigh2 = ", linecolorhigh2))
      linecolorhigh2 <- "gray"
    }

    if (!vcqi_check_color(linecolormid2)){
      invalid_colors <- c(invalid_colors, paste0("linecolormid2 = ", linecolormid2))
      linecolormid2 <- "gray"
    }

    if (!vcqi_check_color(linecolorlow2)){
      invalid_colors <- c(invalid_colors, paste0("linecolorlow2 = ", linecolorlow2))
      linecolorlow2 <- "gray"
    }

    if (!vcqi_check_color(nlinecolor)){
      invalid_colors <- c(invalid_colors, paste0("nlinecolor = ", nlinecolor))
      nlinecolor <- "black"
    }

    if (!vcqi_check_color(lowcovgthresholdlinecolor)){
      invalid_colors <- c(
        invalid_colors,
        paste0("lowcovgthresholdlinecolor = ", lowcovgthresholdlinecolor))

      lowcovgthresholdlinecolor <- "red"
    }

    if (!vcqi_check_color(highcovgthresholdlinecolor)){
      invalid_colors <- c(
        invalid_colors,
        paste0("highcovgthresholdlinecolor = ", highcovgthresholdlinecolor))

      highcovgthresholdlinecolor <- "red"
    }

  } else {

    invalid_colors <- NULL

    if (!vcqi_check_color(barcolor1)){
      invalid_colors <- c(invalid_colors, paste0("barcolor1 = ", barcolor1))
      barcolor1 <- "hotpink"
    }

    if (!vcqi_check_color(barcolor2)){
      invalid_colors <- c(invalid_colors, paste0("barcolor2 = ", barcolor2))
      barcolor2 <- "white"
    }

    if (!vcqi_check_color(linecolor1)){
      invalid_colors <- c(invalid_colors, paste0("linecolor1 = ", linecolor1))
      linecolor1 <- "gray"
    }

    if (!vcqi_check_color(linecolor2)){
      invalid_colors <- c(invalid_colors, paste0("linecolor2 = ", linecolor2))
      linecolor2 <- "gray"
    }

    if (!vcqi_check_color(nlinecolor)){
      invalid_colors <- c(invalid_colors, paste0("nlinecolor = ", nlinecolor))
      nlinecolor <- "black"
    }

  }

  if (!is.null(invalid_colors)){
    warning(paste0(
      "Some opplot colors were not valid: ", paste(invalid_colors, collapse = "; "), ". ",
      "Invalid colors have been replaced with default values."
    ))
  }

  # Create the filename
  filenamesave <- paste0(filename, ".", platform)

  # Generate barwidth variable

  ## 1. Create variable with unique stratum/cluster combinations
  dat <- within(
    dat, {stratum_cluster_factor <- factor(paste(dat$stratvar, dat$clustvar))})

  ## 2. Calculate the sum of the the weights by unique stratum/cluster combination
  wclust_temp <- doBy::summaryBy(weightvar ~ stratum_cluster_factor,
                                 data = dat, FUN = sum)
  colnames(wclust_temp)[2] <- "wclust"

  ## 3. Merge sum of weights with dat
  dat2 <- merge(dat, wclust_temp, sort = FALSE)

  ## 4. Calculate the sum of the the weights by unique stratum
  wstrat_temp <- doBy::summaryBy(weightvar ~ stratvar, data = dat, FUN = sum)
  colnames(wstrat_temp)[2] <- "wstrat"

  ## 5. Merge sum of weights with dat2
  dat3 <- merge(dat2, wstrat_temp, sort=FALSE)

  ## 6. Calculate barwidth variable
  dat3$barwidth <- 100 * dat3$wclust/dat3$wstrat

  # Generate barheight variable
  dat3$yweight <- dat3$yvar * dat3$weightvar
  yweight_sum_df <- doBy::summaryBy(
    yweight ~ stratum_cluster_factor, data = dat3, FUN = sum)
  colnames(yweight_sum_df)[2] <- "wsum1"

  # Merge sum of weights with dat3
  dat4 <- merge(dat3, yweight_sum_df, sort = FALSE)
  dat4$barheight <- round(100*dat4$wsum1/dat4$wclust)

  # Calculate the sum of the the respondents by unique stratum/cluster combination
  # Note: This variable will only be used if plotn == TRUE
  dat4$one <- 1 # make a col of 1's for summing in the next line...
  nresp_temp <- doBy::summaryBy(one ~ stratum_cluster_factor, data = dat4, FUN = sum)
  colnames(nresp_temp)[2] <- "nresp"

  # Merge sum of respondents per stratum/cluster with dat
  dat5 <- merge(dat4, nresp_temp, sort = FALSE)

  # Organize data for plotting

  ## Keep 1 observation for each stratum/cluster
  dat5_sorted <- dat5[order(dat5$stratvar, dat5$clustvar),]
  one_obs <- dat5_sorted[!duplicated(dat5_sorted[names(dat5_sorted) == "stratum_cluster_factor"]),]

  ## Keep stratum of interest
  if (stratum!="") {
    if (!is.na(stratvar) & stratvar != ""){
      one_obs_subset <- one_obs[which(one_obs$stratvar == stratum),]
    } else {
      print(paste0(
        "Warning: cannot show results for stratum = ", stratum,
        " because stratvar is not defined. All observations are used in plot."))
      one_obs_subset <- one_obs
    }
  } else {
    print("Warning: stratum not specified so all observations are used in plot")
    one_obs_subset <- one_obs
  }

  ## Sort data (descending) by barheight then by barwidth
  to_plot <- one_obs_subset[order(
    -one_obs_subset$barheight,
    -one_obs_subset$barwidth,
    -one_obs_subset$nresp,
    one_obs_subset$clustvar),]

  to_plot$barheight2 <- 100 - to_plot$barheight

  ## Add left point and right point to the dataset
  left <- c(rep(0, nrow(to_plot)))
  width <- to_plot$barwidth
  right <- c(width[1], rep(0, (nrow(to_plot) - 1)))

  if (nrow(to_plot) > 1){
    for (i in 2:nrow(to_plot)){
      left[i] = right[i - 1]
      right[i] = left[i] + width[i]
    }
  }

  to_plot <- dplyr::mutate(to_plot, left = left, right = right)

  opplot_footnote <- stringr::str_wrap(footnote, width = 100)

  # Make organ pipe plot
  if (plotn == TRUE) {
    par(mar = c(5, 4, 4, 4) + 0.3)  # Leave space for second y axis

    ymax2_temp <- max(one_obs_subset$nresp)
    ymax2 <- yround2 * ceiling((ymax2_temp+1)/yround2)

    # creating new dataset for the geom_step
    pointdata <- data.frame(
      xpoint = c(to_plot$left,
                 to_plot$right[nrow(to_plot)]),
      ypoint = c(to_plot$nresp*(ymax/ymax2),
                 to_plot$nresp[nrow(to_plot)]*(ymax/ymax2)))

  }

  plot_result <- ggplot2::ggplot(to_plot) +
    {if (covgcategories == FALSE) geom_rect(
      aes(xmin = left, xmax = right, ymin = 0, ymax = barheight),
      fill = barcolor1, color = linecolor1
    )} +
    {if (covgcategories == FALSE) geom_rect(
      aes(xmin = left, xmax = right, ymin = barheight, ymax = 100),
      fill = barcolor2, color = linecolor2
    )} +
    # Categorized coverage: high, medium, and low bars - upper and lower
    {if (covgcategories == TRUE) geom_rect(
      data = filter(to_plot, barheight >= highcovgthreshold),
      aes(xmin = left, xmax = right, ymin = 0, ymax = barheight),
      fill = barcolorhigh1, color = linecolorhigh1
    )} +
    {if (covgcategories == TRUE) geom_rect(
      data = filter(to_plot, barheight >= highcovgthreshold),
      aes(xmin = left, xmax = right, ymin = barheight, ymax = 100),
      fill = barcolorhigh2, color = linecolorhigh2
    )} +
    {if (covgcategories == TRUE) geom_rect(
      data = filter(to_plot, barheight < highcovgthreshold & barheight > lowcovgthreshold),
      aes(xmin = left, xmax = right, ymin = 0, ymax = barheight),
      fill = barcolormid1, color = linecolormid1
    )} +
    {if (covgcategories == TRUE) geom_rect(
      data = filter(to_plot, barheight < highcovgthreshold & barheight > lowcovgthreshold),
      aes(xmin = left, xmax = right, ymin = barheight, ymax = 100),
      fill = barcolormid2, color = linecolormid2
    )} +
    {if (covgcategories == TRUE) geom_rect(
      data = filter(to_plot, barheight <= lowcovgthreshold),
      aes(xmin = left, xmax = right, ymin = 0, ymax = barheight),
      fill = barcolorlow1, color = linecolorlow1
    )} +
    {if (covgcategories == TRUE) geom_rect(
      data = filter(to_plot, barheight <= lowcovgthreshold),
      aes(xmin = left, xmax = right, ymin = barheight, ymax = 100),
      fill = barcolorlow2, color = linecolorlow2
    )} +
    {if (covgcategories == TRUE & lowcovgthresholdline == TRUE) geom_hline(
      aes(yintercept = lowcovgthreshold), color = lowcovgthresholdlinecolor
    )} +
    {if (covgcategories == TRUE & highcovgthresholdline == TRUE) geom_hline(
      aes(yintercept = highcovgthreshold), color = highcovgthresholdlinecolor
    )} +

    labs(title = title,
         subtitle = subtitle,
         caption = opplot_footnote) +
    theme_bw() +
    theme(panel.border = element_rect(color = "black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          plot.caption = element_text(hjust = 0)
    ) +
    {if (plotn == FALSE) scale_y_continuous(name = ylabel, breaks = seq(ymin, ymax, by = yby))} +
    {if (plotn == TRUE) scale_y_continuous(
      name = ylabel, breaks = seq(ymin, ymax, by = yby),
      sec.axis = sec_axis(~./(ymax/ymax2), name = ylabel2,
                          breaks = seq(0, ymax2, yround2)))} +
    {if (plotn == TRUE) geom_step(
      pointdata, mapping = aes(x = xpoint, y = ypoint),
      color = nlinecolor, linewidth = nlinewidth,linetype = nlinepattern)} +
    {if (plotn == TRUE) theme(axis.title.y.right = element_text(angle = 90))}

  if (!is.na(filename)){
    ggsave(filenamesave, plot_result, width = sizew, height = sizeh, units = "in")
  }

  # If the user has asked for underlying data to be saved, then trim down to a
  # small dataset that summarizes what is shown in the bars; this is to help
  # users identify the clusterid of a particular bar in the figure; the order in
  # which clusterids appear in the saved dataset is the same order they appear
  # in the plot

  if (!is.na(savedata)) {
    # First, save 10 variables as vectors
    yvar_rep <- rep(yvar, length(to_plot$yvar))
    stratvar_rep <- rep(stratvar, length(to_plot$yvar))
    stratum_rep <- rep(stratum, length(to_plot$yvar))
    cluster_rep <- rep(clustvar, length(to_plot$yvar))
    clusterid <- to_plot$clustvar
    n_respondents <- to_plot$nresp
    barorder <- c(1:length(to_plot$yvar))
    barwidth <- to_plot$barwidth
    cumulative_barwidth <- cumsum(to_plot$barwidth)
    barheight <- to_plot$barheight

    # Now, put those 10 variables in a data.frame
    to_save <- data.frame(yvar_rep, stratvar_rep, stratum_rep, cluster_rep,
                          clusterid, n_respondents, barorder,
                          barwidth, cumulative_barwidth,barheight)

    # Drop the final row, which is not a cluster but only present for plotting purposes
    to_save <- to_save[!is.na(to_save$clusterid),]

    # Re-name the *_rep variables
    colnames(to_save)[colnames(to_save) == "yvar_rep"] <- "yvar"
    colnames(to_save)[colnames(to_save) == "stratvar_rep"] <- "stratvar"
    colnames(to_save)[colnames(to_save) == "stratum_rep"] <- "stratum"
    colnames(to_save)[colnames(to_save) == "cluster_rep"] <- "cluster"

    # Save data.frame to disk (as a .csv or a .rds)
    if (savedatatype == "rds") {
      saveRDS(to_save, file = file.path(paste0(savedata, ".rds")))
    } else if (savedatatype == "csv") {
      write.csv(to_save, file = file.path(paste0(savedata, ".csv")),
                row.names = FALSE)
    } else {
      print("The savedatatype argument must be either csv or rds. Defaulting to saving as a CSV.")
      write.csv(to_save, file = file.path(paste0(savedata, ".csv")),
                row.names = FALSE)
    }
  }

  if (output_to_screen %in% TRUE){
    plot_result
  }

}
