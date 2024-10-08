% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/omXplore_tabExplorer.R
\name{omXplore_tabExplorer}
\alias{omXplore_tabExplorer}
\alias{omXplore_tabExplorer_ui}
\alias{omXplore_tabExplorer_server}
\title{Explore \code{MultiAssayExperiment} objects.}
\usage{
omXplore_tabExplorer_ui(id)

omXplore_tabExplorer_server(
  id,
  obj = reactive({
     NULL
 }),
  i = reactive({
     NULL
 }),
  digits = reactive({
     3
 })
)

omXplore_tabExplorer(obj, i)
}
\arguments{
\item{id}{A \code{character(1)} which is the id of the shiny module.}

\item{obj}{An instance of the class \code{MultiAssayExperiment}}

\item{i}{An integer which is the index of the assay in the param obj}

\item{digits}{An integer for the number of digits shown in the table}
}
\value{
NA

NA

NA

A shiny app
}
\description{
Explore \code{MultiAssayExperiment} objects.
}
\examples{
\dontrun{
  data(vdata)
  shiny::runApp(omXplore_tabExplorer(vdata, 1))
}

}
