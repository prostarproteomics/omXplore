% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{Build_enriched_qdata}
\alias{Build_enriched_qdata}
\title{Builds enriched assay with cell metadata info}
\usage{
Build_enriched_qdata(obj)
}
\arguments{
\item{obj}{An instance of the class \code{SummarizedExperiment}}
}
\value{
A data.frame with new colums corresponding to the cell metadata
(if exists)
}
\description{
If the cell metadata exists in the object of class \code{SummarizedExperiment},
then these information are added to the quantitative data so as to use
styles with the functions of the package \code{DT}.
}
