#' @title Variance plot
#'
#' @description
#' A shiny module which plots the variance of samples
#'
#' @name plot-variance
#'
#' @param id A `character(1)` which is the id of the shiny module.
#' @param obj An instance of the class `MultiAssayExperiment`
#' @param i An integer which is the index of the assay in the param obj
#' @param conds A vector indicating the name of each sample.
#' @param pal.name A `character(1)` which is the name of the palette from the
#' package `RColorBrewer` from which the colors are taken.
#' Default value is 'Set1'.
#'
#' 
#' @examples
#' if (interactive()) {
#'   data(vdata)
#'   omXplore_variance(vdata, 1)
#' }
#'
NULL




#' @importFrom shiny shinyApp reactive NS tagList tabsetPanel tabPanel fluidRow 
#' column uiOutput radioButtons reactive moduleServer reactiveValues observeEvent 
#' renderUI req selectInput isolate uiOutput tagList fluidPage div p
#' numericInput observe plotOutput renderImage renderPlot selectizeInput 
#' sliderInput textInput updateSelectInput updateSelectizeInput wellPanel 
#' withProgress h3 br actionButton addResourcePath h4 helpText imageOutput
#' @importFrom shinyjs useShinyjs hidden toggle
#' @importFrom RColorBrewer brewer.pal
#' @import highcharter
#' @importFrom DT JS
#' @importFrom stats var
#' 
#' 
#' @rdname plot-variance
#' @export
#' @return NA
#'
omXplore_variance_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shinyjs::useShinyjs(),
    shinyjs::hidden(div(id = ns("badFormatMsg"), 
      h3(globals()$bad_format_txt))),
    uiOutput(ns("helpTxt")),
    highcharter::highchartOutput(ns("viewDistCV"), width = 600, height = 600)
  )
}





#' @importFrom shiny shinyApp reactive NS tagList tabsetPanel tabPanel fluidRow 
#' column uiOutput radioButtons reactive moduleServer reactiveValues observeEvent 
#' renderUI req selectInput isolate uiOutput tagList fluidPage div p
#' numericInput observe plotOutput renderImage renderPlot selectizeInput 
#' sliderInput textInput updateSelectInput updateSelectizeInput wellPanel 
#' withProgress h3 br actionButton addResourcePath h4 helpText imageOutput
#' @importFrom shinyjs useShinyjs hidden toggle
#' @importFrom RColorBrewer brewer.pal
#' @import highcharter
#' @importFrom DT JS
#' @importFrom stats var
#' 
#' 
#' 
#' @rdname plot-variance
#' @export
#' @return NA
#'
omXplore_variance_server <- function(
    id,
    obj,
    i,
    pal.name = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    rv <- reactiveValues(data = NULL)

    observe(
      {
        is.mae <- inherits(obj(), "MultiAssayExperiment")
        if(is.mae) {
          rv$data <- obj()
        }

        shinyjs::toggle("badFormatMsg", condition = !isTRUE(is.mae))
      },
      priority = 1000
    )

    output$viewDistCV <- renderHighchart({
      req(rv$data)
      withProgress(message = "Making plot", value = 100, {
        varDist <- CVDist(obj = assay(rv$data, i()),
          conds = get_group(obj()),
          pal.name)
      })
    })

    output$helpTxt <- renderUI({
      req(rv$data)
      tagList(
        helpText("Display the condition-wise distributions of the
          log-intensity CV (Coefficient of Variation) of the
                   protein/peptides."),
        helpText("For better visualization, it is possible to zoom in by
            click-and-drag.")
      )
    })
  })
}




#' @importFrom stats density var
#' @import highcharter
#' 
#' 
#' @export
#'
#' @param obj An matrix
#' @param pal.name A `character(1)` which is the name of the palette from
#' the package [RColorBrewer] from which the colors are taken. Default
#' value is 'Set1'.
#'
#'
#' @rdname plot-variance
#'
#' @return A plot
#'
CVDist <- function(
    obj,
  conds,
    pal.name = NULL) {
  stopifnot(inherits(obj, "matrix"))


  if (is.null(conds) || length(conds)==0) {
    stop("obj contains no conds.")
  }

  u_conds <- unique(conds)
  myColors <- SampleColors(u_conds)

  h1 <- highcharter::highchart() %>%
    customChart(chartType = "spline", zoomType = "x") %>%
    highcharter::hc_colors(myColors) %>%
    highcharter::hc_legend(
      enabled = TRUE,
      categories = u_conds
    ) %>%
    highcharter::hc_xAxis(title = list(text = "CV(log(Intensity))")) %>%
    highcharter::hc_yAxis(title = list(text = "Density")) %>%
    highcharter::hc_tooltip(
      headerFormat = "",
      pointFormat = "<b>{series.name}</b>: {point.y} ",
      valueDecimals = 2
    ) %>%
    customExportMenu(fname = "logIntensity") %>%
    highcharter::hc_plotOptions(
      series = list(
        connectNulls = TRUE,
        marker = list(
          enabled = FALSE
        )
      )
    )

  minX <- maxX <- 0
  maxY <- 0
  for (i in seq_len(length(u_conds))) {
    if (length(which(conds == u_conds[i])) > 1) {
      t <- apply(
        obj[, which(conds == u_conds[i])], 1,
        function(x) {
          100 * stats::var(x, na.rm = TRUE) / mean(x, na.rm = TRUE)
        }
      )
      tmp <- data.frame(
        x = stats::density(t, na.rm = TRUE)$x,
        y = stats::density(t, na.rm = TRUE)$y
      )

      ymaxY <- max(maxY, tmp$y)
      xmaxY <- tmp$x[which(tmp$y == max(tmp$y))]
      minX <- min(minX, tmp$x)
      maxX <- max(maxX, 10 * (xmaxY - minX))

      h1 <- h1 %>% hc_add_series(data = tmp, name = u_conds[i])
    }
  }

  h1 <- h1 %>%
    hc_chart(
      events = list(
        load = DT::JS(paste0("function(){
                         var chart = this;
                         this.xAxis[0].setExtremes(", minX, ",", maxX, ");
                         this.showResetZoom();}"))
      )
    )

  return(h1)
}




#' @rdname plot-variance
#' @export
#' @return A shiny app
#'
omXplore_variance <- function(obj, i) {
  stopifnot(inherits(obj, "MultiAssayExperiment"))
  
  ui <- fluidPage(
    omXplore_variance_ui("plot")
    )

  server <- function(input, output, session) {
    omXplore_variance_server("plot", 
      obj = reactive({obj}),
      i = reactive({i})
      )
  }

  app <- shinyApp(ui, server)
}
