#' @title   formatDT_ui and formatDT_server
#'
#' @description
#'
#' A shiny Module.
#'
#' See `DT` package homepage for more details about styling tables.
#' If no style is precised, this module show the raw data.
#' If any style is given, then the dataset must be well configured (I.e. it
#' must contain the correct columns )
#'
#'
#' @param id shiny id
#' @param data A `data.frame`
#' @param data_nostyle A data.frame() to be bind to the main data with no
#' custom style
#' @param withDLBtns A boolean to indicate whether to display download
#' buttons or not.
#' @param showRownames A boolean to indicate whether to show rownames.
#' @param dt_style A `list` composed of:
#' * data : a data.frame
#' * colors : a named vector
#' @param filename A `character(1)` which is the default filename for download.
#' @param selection A `character(1)` which indicates the type of selection. 
#' Default is 'single'.
#'
#' @name format_DT
#' 
#' 
#' @examples
#' \dontrun{
#'   data(vdata)
#'   formatDT(vdata)
#' }
#'
#' @return NA
#' 
NULL



#' @importFrom shiny shinyApp reactive NS tagList tabsetPanel tabPanel fluidRow 
#' column uiOutput radioButtons reactive moduleServer reactiveValues observeEvent 
#' renderUI req selectInput isolate uiOutput tagList fluidPage div p
#' numericInput observe plotOutput renderImage renderPlot selectizeInput 
#' sliderInput textInput updateSelectInput updateSelectizeInput wellPanel 
#' withProgress h3 br actionButton addResourcePath h4 helpText imageOutput
#' @importFrom shinyjs useShinyjs hidden toggle
#' @importFrom htmlwidgets JS
#' @importFrom DT dataTableProxy replaceData renderDataTable datatable JS
#' formatStyle styleEqual dataTableOutput
#' 
#' @rdname format_DT
#' @return NA
#' @export
#'
formatDT_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shinyjs::useShinyjs(),
    # shinyjs::hidden(div(id = ns("dl_div"), dl_ui(ns("DL_btns")))),
    fluidRow(
      column(
        width = 12,
        DT::dataTableOutput(ns("StaticDataTable"))
      )
    )
  )
}




#' @importFrom shiny shinyApp reactive NS tagList tabsetPanel tabPanel fluidRow 
#' column uiOutput radioButtons reactive moduleServer reactiveValues observeEvent 
#' renderUI req selectInput isolate uiOutput tagList fluidPage div p
#' numericInput observe plotOutput renderImage renderPlot selectizeInput 
#' sliderInput textInput updateSelectInput updateSelectizeInput wellPanel 
#' withProgress h3 br actionButton addResourcePath h4 helpText imageOutput
#' @importFrom shinyjs useShinyjs hidden toggle
#' @importFrom htmlwidgets JS
#' @importFrom DT dataTableProxy replaceData renderDataTable datatable JS
#' formatStyle styleEqual dataTableOutput
#' @rdname format_DT
#' @return NA
#' @export
#'
formatDT_server <- function(id,
  data = reactive({NULL}),
  data_nostyle = reactive({NULL}),
  withDLBtns = FALSE,
  showRownames = FALSE,
  dt_style = reactive({NULL}),
  filename = "Prostar_export",
  selection = "single") {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    proxy <- DT::dataTableProxy(ns("StaticDataTable"), session)

    rv <- reactiveValues(
      data = NULL,
      tgt2hide = NULL,
      dataOUt = NULL
    )


    checkValidity <- reactive({
      passed <- TRUE

      #passed <- passed && !is.null(dt_style()$data)

      passed <- passed &&
        (inherits(data(), "data.frame") ||
          inherits(data(), "matrix"))

      if(!is.null(dt_style())){
        passed <- passed &&
        (inherits(dt_style()$data, "data.frame") ||
          inherits(dt_style()$data, "matrix")||
            inherits(dt_style()$data, "DataFrame"))

      passed <- passed &&
        nrow(data()) == nrow(dt_style()$data)
      }

      passed
    })


    observe({
      req(data())
      rv$data <- data()
      DT::replaceData(proxy, rv$data, resetPaging = FALSE)
    })

    observeEvent(input$StaticDataTable_rows_selected, {
      rv$dataOut <- input$StaticDataTable_rows_selected
    })



    prepareDataset <- reactive({
      df <- data()

      .data <- as.data.frame(dt_style()$data)
      if (!is.null(dt_style()) && checkValidity()) {
        df <- cbind(df, .data)
        rv$tgt2hide <- ncol(data()) - 1 + seq(ncol(.data))
      }

      if (!is.null(data_nostyle())) {
        df <- cbind(df, data_nostyle())
      }

      df
    })


    output$StaticDataTable <- DT::renderDataTable(server = TRUE, {
      req(length(rv$data) > 0)
      .jscode <- DT::JS("$.fn.dataTable.render.ellipsis( 30 )")

      dt <- DT::datatable(
        prepareDataset(),
        escape = FALSE,
        selection = selection,
        rownames = showRownames,
        plugins = "ellipsis",
        options = list(
          initComplete = initComplete(),
          dom = "Bt",
          autoWidth = TRUE,
          columnDefs = if (is.null(dt_style())) {
            list(list(
              targets = "_all",
              className = "dt-center",
              render = .jscode
            ))
          } else {
            list(
              list(
                targets = "_all",
                className = "dt-center",
                render = .jscode
              ),
              list(
                targets = rv$tgt2hide,
                visible = FALSE,
                className = "dt-center",
                render = .jscode
              )
            )
          }
        )
      )


      if (!is.null(dt_style())) {
        dt <- dt %>%
          DT::formatStyle(
            columns = colnames(data()),
            valueColumns = colnames(dt_style()$data),
            backgroundColor = DT::styleEqual(
              names(dt_style()$colors),
              unique(dt_style()$colors)
            )
          )
      }

      dt
    })

    initComplete <- function() {
      return(htmlwidgets::JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': 'darkgrey',",
        "'color': 'black'});",
        "}"
      ))
    }


    return(reactive({
      rv$dataOut
    }))
  })
}




#' @export
#' @rdname format_DT
#' @return NA
#'
formatDT <- function(data) {
  stopifnot(inherits(data, "MultiAssayExperiment"))
  
  ui <- formatDT_ui("table")

  server <- function(input, output, session) {
    formatDT_server("table",
      data = reactive({data})
    )
  }

  app <- shinyApp(ui, server)
}
