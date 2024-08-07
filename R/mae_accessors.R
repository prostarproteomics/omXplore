#' @title Accessors functions
#' @description Functions used to access the additional plots in the instances 
#' of the class `MultiAssayExperiment`.
#' @return See individual method description for the return value.
#' @param object An object of
#' @param ... Additional parameters
#' @name accessors
#'
#' @importFrom SummarizedExperiment rowData colData assays 
#' @importFrom methods setGeneric setMethod
#'
#' @return If exists, the slot value requested.
#' @examples
#'
#' ## -----------------------------------
#' ## Accessing slots from a MSnSet dataset
#' ## -----------------------------------
#' data(sub_R25)
#' se1 <- sub_R25[[1]]
#' parentProtId <- get_parentProtId(se1)
#' colID <- get_colID(se1)
#' type <- get_type(se1)
#' metacell <- get_metacell(se1)
#' conds <- get_group(sub_R25)
#'
NULL


#' @rdname accessors
#' @exportMethod get_adjacencyMatrix
setGeneric(
  "get_adjacencyMatrix",
  function(object, ...) standardGeneric("get_adjacencyMatrix")
)



#' @param object An instance of class `SummarizedExperiment`.
#' @rdname accessors
#' @return A DataFrame containing the adjacency matrix of the dataset
#'
setMethod("get_adjacencyMatrix", signature = "SummarizedExperiment",
  function(object) {
    tryCatch(
      {
        SummarizedExperiment::rowData(object)[, 'adjacencyMatrix']
      },
      warning = function(w) {
        message(w)
        NULL},
      error = function(e) {
        message(e)
        NULL}
    )
  }
)




#' @rdname accessors
#' @exportMethod get_design
setGeneric(
  "get_design",
  function(object, ...) standardGeneric("get_design")
)



#' @param object An instance of class `SummarizedExperiment`.
#' @rdname accessors
#' @return A data.frame containing the metadata of the dataset
#'
setMethod("get_design", signature = "MultiAssayExperiment",
  function(object) {
    tryCatch(
      {
        design <- MultiAssayExperiment::colData(object)
        if(is.null(design))
          design <- MultiAssayExperiment::colData(object)
        
        design
      },
      warning = function(w) {NULL},
      error = function(e) {NULL}
    )
  }
)




#' @rdname accessors
#' @exportMethod get_group
setGeneric(
  "get_group",
  function(object, ...) standardGeneric("get_group")
)



#' @param object An instance of class `SummarizedExperiment`.
#' @rdname accessors
#' @return A data.frame containing the metadata of the dataset
#'
setMethod("get_group", signature = "MultiAssayExperiment",
  function(object) {
    tryCatch(
      {
        grp <- MultiAssayExperiment::colData(object)$group
        if(is.null(grp))
          grp <- MultiAssayExperiment::colData(object)$Condition
        
        grp
      },
      warning = function(w) {NULL},
      error = function(e) {NULL}
    )
  }
)



#' @rdname accessors
#' @exportMethod get_metacell
setGeneric(
  "get_metacell",
  function(object, ...) standardGeneric("get_metacell")
)



#' @param object An instance of class `SummarizedExperiment`.
#' @param slot.name The name of the slot dedicated to cell metadata to search. 
#' Default values are 'metacell' and 'qMetacell'
#' @rdname accessors
#' @return A data.frame containing the metadata of the dataset
#'
setMethod("get_metacell", signature = "SummarizedExperiment",
  function(object, slot.name = c('metacell', 'qMetacell')) {
    tryCatch(
      {
        meta <- NULL
        .rowdata <- SummarizedExperiment::rowData(object)
        for(i in slot.name){
          found <- match(i, colnames(.rowdata))
          if (!is.na(found))
            meta <- as.data.frame(.rowdata[, found])
        }
        return(meta)
      },
      warning = function(w) {NULL},
      error = function(e) {NULL}
    )
  }
  )


#' @rdname accessors
#' @exportMethod get_cc
setGeneric(
  "get_cc",
  function(object, ...) standardGeneric("get_cc")
)



#' @param object An instance of class `SummarizedExperiment`.
#' @rdname accessors
#' @return A data.frame containing the metadata of the dataset
#'
setMethod("get_cc", signature = "SummarizedExperiment",
  function(object) {
    tryCatch(
      {
        MultiAssayExperiment::metadata(object)$cc
      },
      warning = function(w) {NULL},
      error = function(e) {NULL}
    )
  }
)

#' @rdname accessors
#' @exportMethod get_parentProtId
setGeneric(
  "get_parentProtId",
  function(object, ...) standardGeneric("get_parentProtId")
)



#' @param object An instance of class `SummarizedExperiment`.
#' @rdname accessors
#' @return A data.frame containing the metadata of the dataset
#'
setMethod("get_parentProtId", signature = "SummarizedExperiment",
  function(object) {
    tryCatch(
      {
        MultiAssayExperiment::metadata(object)$parentProtId
      },
      warning = function(w) {NULL},
      error = function(e) {NULL}
    )
  }
)


#' @rdname accessors
#' @exportMethod get_colID
setGeneric(
  "get_colID",
  function(object, ...) standardGeneric("get_colID")
)



#' @param object An instance of class `SummarizedExperiment`.
#' @rdname accessors
#' @return A data.frame containing the metadata of the dataset
#'
setMethod("get_colID", signature = "SummarizedExperiment",
  function(object) {
    tryCatch(
      {
        id <- NULL
        test1 <- MultiAssayExperiment::metadata(object)$colID
        test2 <- MultiAssayExperiment::metadata(object)$idcol
        
        if (!is.null(test1))
          id <- test1
        
        if(!is.null(test2))
          id <- test2
        
        return(id)
      },
      warning = function(w) {NULL},
      error = function(e) {NULL}
    )
  }
)


#' @rdname accessors
#' @exportMethod get_type
setGeneric(
  "get_type",
  function(object, ...) standardGeneric("get_type")
)



#' @param object An instance of class `SummarizedExperiment`.
#' @rdname accessors
#' @return A data.frame containing the metadata of the dataset
#'
setMethod("get_type", signature = "SummarizedExperiment",
  function(object) {
    tryCatch(
      {
        MultiAssayExperiment::metadata(object)$type
      },
      warning = function(w) {NULL},
      error = function(e) {NULL}
    )
  }
)


#' @rdname accessors
#' @exportMethod get_pkg_version
setGeneric(
  "get_pkg_version",
  function(object, ...) standardGeneric("get_pkg_version")
)



#' @param object An instance of class `SummarizedExperiment`.
#' @rdname accessors
#' @return A data.frame containing the metadata of the dataset
#'
setMethod("get_pkg_version", signature = "SummarizedExperiment",
  function(object) {
    tryCatch(
      {
        MultiAssayExperiment::metadata(object)$pkg_version
      },
      warning = function(w) {NULL},
      error = function(e) {NULL}
    )
  }
)

