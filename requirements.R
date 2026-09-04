packages <- c(
  "geolibre",
  "terra",
  "sf",
  "dplyr"
)

to_install <- packages[
  !packages %in% rownames(installed.packages())
]

if (length(to_install) > 0) {
  install.packages(to_install)
}

message("Required R packages are available.")