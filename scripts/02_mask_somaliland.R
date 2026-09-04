# ============================================================
# Somaliland Gu 2026 Rainfall
# Exercise 3: Study boundary + spatial masking
# ============================================================

library(sf)
library(terra)
library(dplyr)

# ------------------------------------------------------------
# 1. Create boundary folder
# ------------------------------------------------------------

dir.create(
  "data/boundaries",
  recursive = TRUE,
  showWarnings = FALSE
)

# ------------------------------------------------------------
# 2. Download Somalia ADM1 boundaries
#    Source: geoBoundaries gbOpen
# ------------------------------------------------------------

boundary_url <- paste0(
  "https://github.com/wmgeolab/geoBoundaries/raw/",
  "9469f09/releaseData/gbOpen/SOM/ADM1/",
  "geoBoundaries-SOM-ADM1_simplified.geojson"
)

boundary_file <- file.path(
  "data/boundaries",
  "somalia_adm1_geoboundaries.geojson"
)

if (!file.exists(boundary_file)) {
  
  message("Downloading Somalia ADM1 boundaries...")
  
  download.file(
    boundary_url,
    destfile = boundary_file,
    mode = "wb"
  )
  
} else {
  
  message("Boundary file already exists.")
  
}

# ------------------------------------------------------------
# 3. Read administrative boundaries
# ------------------------------------------------------------

som_adm1 <- st_read(
  boundary_file,
  quiet = TRUE
)

print(som_adm1)

# Find administrative-name column automatically
name_field <- grep(
  "shape.?name|name",
  names(som_adm1),
  ignore.case = TRUE,
  value = TRUE
)[1]

message("Administrative-name field: ", name_field)

# Show available ADM1 names
print(sort(unique(som_adm1[[name_field]])))

# ------------------------------------------------------------
# 4. Define Somaliland analytical study units
# ------------------------------------------------------------

study_regions <- c(
  "Awdal",
  "Woqooyi Galbeed",
  "Togdheer",
  "Sanaag",
  "Sool"
)

somaliland_regions <- som_adm1 |>
  filter(.data[[name_field]] %in% study_regions)

message(
  "Selected regions: ",
  paste(somaliland_regions[[name_field]], collapse = ", ")
)

# QC: we expect five source regions
stopifnot(nrow(somaliland_regions) == 5)

# ------------------------------------------------------------
# 5. Make geometries valid
# ------------------------------------------------------------

somaliland_regions <- st_make_valid(
  somaliland_regions
)

# ------------------------------------------------------------
# 6. Dissolve five regions into one study boundary
# ------------------------------------------------------------

somaliland_union <- st_union(
  somaliland_regions
)

somaliland_boundary <- st_sf(
  study_area = "Somaliland analytical study boundary",
  geometry = somaliland_union
)

# ------------------------------------------------------------
# 7. Save local vector files
# ------------------------------------------------------------

st_write(
  somaliland_regions,
  "data/boundaries/somaliland_study_regions.gpkg",
  delete_dsn = TRUE,
  quiet = TRUE
)

st_write(
  somaliland_boundary,
  "data/boundaries/somaliland_study_boundary.gpkg",
  delete_dsn = TRUE,
  quiet = TRUE
)

# ------------------------------------------------------------
# 8. Load real CHIRPS3 April-June 2026 data
# ------------------------------------------------------------

rain_files <- file.path(
  "data/chirps3_raw",
  c(
    "chirps-v3.0.2026.04.tif",
    "chirps-v3.0.2026.05.tif",
    "chirps-v3.0.2026.06.tif"
  )
)

stopifnot(all(file.exists(rain_files)))

gu_months <- rast(rain_files)

names(gu_months) <- c(
  "April_2026",
  "May_2026",
  "June_2026"
)

# ------------------------------------------------------------
# 9. Calculate Gu 2026 total rainfall
# ------------------------------------------------------------

gu2026 <- sum(
  gu_months,
  na.rm = FALSE
)

names(gu2026) <- "Gu_2026_mm"

# ------------------------------------------------------------
# 10. Align study boundary with CHIRPS CRS
# ------------------------------------------------------------

boundary_vect <- vect(
  somaliland_boundary
)

boundary_vect <- project(
  boundary_vect,
  crs(gu2026)
)

regions_vect <- vect(
  somaliland_regions
)

regions_vect <- project(
  regions_vect,
  crs(gu2026)
)

# ------------------------------------------------------------
# 11. Crop and mask CHIRPS3
# ------------------------------------------------------------

gu2026_crop <- crop(
  gu2026,
  boundary_vect
)

gu2026_masked <- mask(
  gu2026_crop,
  boundary_vect
)

names(gu2026_masked) <- "Gu_2026_mm"

# ------------------------------------------------------------
# 12. Save final spatial rainfall raster
# ------------------------------------------------------------

writeRaster(
  gu2026_masked,
  "data/processed/gu_2026_rainfall_somaliland.tif",
  overwrite = TRUE,
  gdal = c("COMPRESS=LZW")
)

# ------------------------------------------------------------
# 13. Numerical QC
# ------------------------------------------------------------

cat("\n--- Gu 2026 rainfall summary ---\n")

print(
  global(
    gu2026_masked,
    fun = c("min", "mean", "max"),
    na.rm = TRUE
  )
)

cat("\nRaster resolution:\n")
print(res(gu2026_masked))

cat("\nRaster CRS:\n")
print(crs(gu2026_masked))

# ------------------------------------------------------------
# 14. Inspect actual spatial pattern
# ------------------------------------------------------------

plot(
  gu2026_masked,
  main = "Gu 2026 Rainfall — Somaliland\nCHIRPS3, April-June (mm)"
)

lines(
  regions_vect,
  lwd = 1
)

lines(
  boundary_vect,
  lwd = 2
)

# ------------------------------------------------------------
# 15. Export QC figure
# ------------------------------------------------------------

png(
  "outputs/figures/01_gu_2026_spatial_rainfall.png",
  width = 1800,
  height = 1200,
  res = 180
)

plot(
  gu2026_masked,
  main = "Gu 2026 Rainfall — Somaliland\nCHIRPS3, April-June (mm)"
)

lines(
  regions_vect,
  lwd = 1
)

lines(
  boundary_vect,
  lwd = 2
)

dev.off()

message("Exercise 3 completed successfully.")