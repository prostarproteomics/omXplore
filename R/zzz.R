.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    prefix = "images",
    directoryPath = system.file("images", package = "omXplore")
  )
}

.onUnload <- function(libname, pkgname) {
  shiny::removeResourcePath("images")
}
