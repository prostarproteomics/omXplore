
#' @return A boxplot
#' @author Samuel Wieczorek, Anais Courtier, Enora Fremy
#' @import highcharter
#' 
#' @rdname intensity-plots
#' 
#' @export
boxPlot <- function(
    obj,
  conds,
  legend = NULL,
  pal = NULL,
  subset = NULL) {
  pkgs.require(c('stats', "grDevices", "RColorBrewer"))
  

  if (is.null(obj)) {
    warning("The dataset is NULL and cannot be shown")
    return(NULL)
  } else if (nrow(obj) == 0) {
    warning("The dataset is empty and cannot be shown")
    return(NULL)
  } else {
    qData <- SummarizedExperiment::assay(obj)
  }
  
  
  pkgs.require('highcharter')
  
  if (missing(conds)) {
    stop("'conds' is missing.")
  }
  
  if (length(subset) == 0) {
    subset <- NULL
  }
  
  if (is.null(legend)) {
    legend <- conds
    for (i in unique(conds)) {
      legend[which(conds == i)] <- paste0(i, "_",
        seq_len(length(which(conds == i))))
    }
  }
  
  myColors <- NULL
  if (is.null(pal)) {
    warning("Color palette set to default.")
    myColors <- GetColorsForConditions(conds,
      ExtendPalette(length(unique(conds))))
  } else {
    if (length(pal) != length(unique(conds))) {
      warning("The color palette has not the same dimension as
                the number of samples")
      myColors <- GetColorsForConditions(conds,
        ExtendPalette(length(unique(conds))))
    } else {
      myColors <- GetColorsForConditions(conds, pal)
    }
  }
  
  keyId <- MultiAssayExperiment::metadata(obj)$proteinId
  
  # if (!is.null(subset)) {
  #   if (is.null(keyId) || missing(keyId)) {
  #     stop("'keyId' is missing.")
  #   }
  # }
  
  
  
  add_variable_to_series_list <- function(x,
    series_list,
    key_vector,
    value_vector) {
    stopifnot(length(key_vector) == length(value_vector))
    stopifnot(length(series_list) == length(key_vector))
    series_list[[x]][length(series_list[[x]]) + 1] <- value_vector[x]
    names(series_list[[x]])[length(series_list[[x]])] <- key_vector[x]
    return(series_list[[x]])
  }
  
  
  # From highcharter github pages:
  hc_add_series_bwpout <- function(hc, value, by, ...) {
    z <- lapply(levels(by), function(x) {
      bpstats <- grDevices::boxplot.stats(value[by == x])$stats
      outliers <- c()
      for (y in stats::na.exclude(value[by == x])) {
        if ((y < bpstats[1]) | (y > bpstats[5])) {
          outliers <- c(outliers, list(which(levels(by) == x) - 1, y))
        }
      }
      outliers
    })
    hc %>%
      hc_add_series(data = z, type = "scatter", ...)
  }
  
  
  gen_key_vector <- function(variable, num_times) {
    return(rep(variable, num_times))
  }
  
  
  gen_boxplot_series_from_df <- function(value, by, ...) {
    value <- base::as.numeric(value)
    by <- factor(by, levels = unique(by))
    box_names <- levels(by)
    
    z <- lapply(box_names, function(x) {
      grDevices::boxplot.stats(value[by == x])$stats
    })
    tmp <- lapply(seq_along(z), function(x) {
      var_name_list <- list(box_names[x])
      # tmp0<- list(names(df)[x])
      names(var_name_list) <- "name"
      index <- x - 1
      tmp <- list(c(index, z[[x]]))
      tmp <- list(tmp)
      names(tmp) <- "data"
      tmp_out <- c(var_name_list, tmp)
      # tmp<- list(tmp)
      return(tmp_out)
    })
    return(tmp)
  }
  
  
  
  ## Boxplot function:
  make_highchart_boxplot_with_colored_factors <- function(value,
    by,
    chart_title = "Boxplots",
    chart_x_axis_label = "Values",
    show_outliers = FALSE,
    boxcolors = NULL,
    box_line_colors = NULL) {
    # by <- as.factor(by)
    # box_names_to_use <- levels(by)
    by <- factor(by, levels = unique(by))
    box_names_to_use <- levels(by)
    series <- gen_boxplot_series_from_df(value = value, by = by)
    
    if (is.null(boxcolors)) {
      cols <- rep("#FFFFFF", ncol(qData))
      # Keeping alpha in here! (COLORS FOR BOXES ARE SET HERE)
      # cols<- viridisLite::viridis(n= length(series), alpha = 0.5) 
    } else {
      cols <- boxcolors
    }
    
    
    if (is.null(box_line_colors)) {
      if (nchar(cols[[1]]) == 9) {
        # no alpha, pure hex truth, for box lines
        cols2 <- substr(cols, 0, 7)
      } else {
        cols2 <- cols
      }
    } else {
      cols2 <- box_line_colors
    }
    
    # Injecting value 'fillColor' into series list
    kv <- gen_key_vector(variable = "fillColor", length(series))
    series2 <- lapply(seq_along(series), function(x) {
      add_variable_to_series_list(x = x, series_list = series,
        key_vector = kv, value_vector = cols)
    })
    
    
    hc <- highcharter::highchart() %>%
      highcharter::hc_chart(type = "boxplot", inverted = FALSE) %>%
      highcharter::hc_title(text = chart_title) %>%
      highcharter::hc_legend(enabled = FALSE) %>%
      highcharter::hc_xAxis(type = "category",
        categories = box_names_to_use,
        title = list(text = chart_x_axis_label)) %>%
      highcharter::hc_yAxis(title = list(text = "Log (intensity)")) %>%
      highcharter::hc_add_series_list(series2) %>%
      hc_plotOptions(series = list(
        marker = list(symbol = "circle"),
        grouping = FALSE
      )) %>%
      highcharter::hc_colors(cols2) %>%
      highcharter::hc_exporting(enabled = TRUE)
    
    
    
    if (show_outliers == TRUE) {
      hc <- hc %>%
        hc_add_series_bwpout(
          value = value,
          by = by,
          name = "Outliers",
          colorByPoint = TRUE
        )
    }
    
    hc
  }
  
  
  
  df <- data.frame(cbind(
    categ = rep(colnames(qData), nrow(qData)),
    value = as.vector(apply(qData, 1, function(x) as.vector(x)))
  ))
  df$value <- as.numeric(df$value)
  
  hc <- make_highchart_boxplot_with_colored_factors(
    value = df$value,
    by = df$categ,
    chart_title = "",
    chart_x_axis_label = "Samples",
    show_outliers = TRUE,
    boxcolors = myColors,
    box_line_colors = "black"
  )
  
  # Display of rows to highlight (index of row in subset)
  if (!is.null(subset)) {
    idVector <- keyId
    pal <- ExtendPalette(length(subset), "Dark2")
    n <- 0
    for (i in subset) {
      n <- n + 1
      dfSubset <- data.frame(
        y = as.vector(qData[i, ], mode = "numeric"),
        x = as.numeric(factor(names(qData[i, ]))) - 1,
        stringsAsFactors = FALSE)
      

      hc <- hc %>%
        highcharter::hc_add_series(
          type = "line",
          data = dfSubset,
          color = pal[n],
          dashStyle = "shortdot",
          name = SummarizedExperiment::rowData(obj)[i, keyId],
          tooltip = list(enabled = TRUE,
            headerFormat = "",
            pointFormat = "{point.series.name} : {point.y: .2f} ")
        )
    }
  }
  
  hc
}