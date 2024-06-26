% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metacell_utils.R
\name{q_metadata}
\alias{q_metadata}
\alias{metacell.def}
\alias{Parent}
\alias{Children}
\alias{GetMetacellTags}
\title{Quantitative metadata vocabulary for entities}
\usage{
metacell.def(level)

Parent(level, node = NULL)

Children(level, parent = NULL)

GetMetacellTags(metacells = NULL, level = NULL, onlyPresent = FALSE)
}
\arguments{
\item{level}{A string corresponding to the type of object}

\item{node}{The name of the node for which one wants its parent

#' @examples
Parent('protein', 'Missing')
Parent('protein', 'Missing POV')
Parent('protein', c('Missing POV', 'Missing MEC'))
Parent('protein', c('Missing', 'Missing POV', 'Missing MEC'))}

\item{parent}{The name og the parent node}

\item{metacells}{A data.frame() representing the cell metadata}

\item{onlyPresent}{A \code{boolean(1)}}
}
\value{
A data.frame containing the different tags and corresponding colors
for the level given in parameter

A list

A vector

A vector

A vector
}
\description{
This function gives the vocabulary used for the quantitative metadata of
each entity in each condition.
}
\section{Glossary}{


Peptide-level vocabulary

|-- 'Any'
|    |
|    |-- 1.0 'Quantified'
|    |    |
|    |    |-- 1.1 "Quant. by direct id" (color 4, white)
|    |    |
|    |    |-- 1.2 "Quant. by recovery" (color 3, lightgrey)
|    |
|    |-- 2.0 "Missing" (no color)
|    |    |
|    |    |-- 2.1 "Missing POV" (color 1)
|    |    |
|    |    |-- 2.2 'Missing MEC' (color 2)
|    |
|    |-- 3.0 'Imputed'
|    |    |
|    |    |-- 3.1 'Imputed POV' (color 1)
|    |    |
|    |    |-- 3.2 'Imputed MEC' (color 2)

Protein-level vocabulary:
|-- 'Any'
|    |
|    |-- 1.0 'Quantified'
|    |    |
|    |    |-- 1.1 "Quant. by direct id" (color 4, white)
|    |    |
|    |    |-- 1.2 "Quant. by recovery" (color 3, lightgrey)
|    |
|    |-- 2.0 "Missing"
|    |    |
|    |    |-- 2.1 "Missing POV" (color 1)
|    |    |
|    |    |-- 2.2 'Missing MEC' (color 2)
|    |
|    |-- 3.0 'Imputed'
|    |    |
|    |    |-- 3.1 'Imputed POV' (color 1)
|    |    |
|    |    |-- 3.2 'Imputed MEC' (color 2)
|    |
|    |-- 4.0 'Combined tags' (color 3bis, lightgrey)
}

\section{Conversion to the glossary}{


A generic conversion

Conversion for Proline datasets

Conversion from Maxquant datasets
}

\examples{

metacell.def("protein")
metacell.def("peptide")

#-----------------------------------------------
# A shiny app to view color legends
#-----------------------------------------------
if(interactive()) {
  data(vdata)
  ui <- qMetacellLegend_ui("legend")

  server <- function(input, output, session) {
    qMetacellLegend_server("legend",
      object = reactive({vdata[[1]]})
    )
  }

  shinyApp(ui = ui, server = server)
}

Children("protein", "Missing")
Children("protein", "Missing POV")
Children("protein", c("Missing POV", "Missing MEC"))
Children("protein", c("Missing", "Missing POV", "Missing MEC"))
data(vdata)
metacells <- get_metacell(vdata[[1]])
level <- get_type(vdata[[1]])
GetMetacellTags(metacells, level)

}
\author{
Thomas Burger, Samuel Wieczorek

Samuel Wieczorek
}
