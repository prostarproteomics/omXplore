% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/modules.R
\name{omXplore-modules}
\alias{omXplore-modules}
\alias{addModules}
\alias{listShinyApps}
\alias{listPlotModules}
\title{Shiny modules used by \code{omXplore}}
\usage{
addModules(addons = list())

listShinyApps(location = "both")

listPlotModules(location = "both")
}
\arguments{
\item{addons}{A \code{list} in which each item:
\itemize{
\item is named by the name of a package containing the modules to add,
\item contains the name of the shiny modules to integrate (without '_ui' nor
'_server' suffixes)
}}

\item{location}{A \code{character(0)} to indicate which modules to list. Available
values are: 'builtin', 'external' and 'both' (default).}
}
\value{
NA

A vector

A vector
}
\description{
These functions are relative to external modules that can be added into
\code{omXplore} UI:
\itemize{
\item \code{listShinyApps()}: Show the shiny modules recognized by \code{omXplore} and
ready to bu integrated in the UI of the function view_dataset()
\item \code{listPlotModules()}: Show the shiny modules function names (only prefixes)
recognized by \code{omXplore} and ready to use in the UI.
\item \code{addModules()}: Add external shiny module(s) to the R global environment in
such a way (specific prefix renaming of the functions) that it can be
discovered by the function view_dataset() of the package \code{omXplore} during
its launch.
}
}
\examples{
listShinyApps()
listPlotModules()

#####################################################
# Integration of a module in the package 'mypackage'
#####################################################
\dontrun{
addons <- list(omXplore = c("extFoo1", "extFoo2"))
addModules(addons)
}

}
