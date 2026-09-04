# ============================================================
# Somaliland Gu 2026 Rainfall
# Exercise 2: Download and prepare CHIRPS3 April-June rainfall
# ============================================================

library(terra)

# ------------------------------------------------------------
# 1. Create project folders
# ------------------------------------------------------------

dir.create("data", showWarnings = FALSE)
dir.create("data/chirps3_raw", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------
# 2. Official CHIRPS3 Africa monthly GeoTIFF archive
# ------------------------------------------------------------

base_url <- paste0(
  "https://data.chc.ucsb.edu/products/",
  "CHIRPS/v3.0/monthly/africa/tifs/"
)

months <- c("04", "05", "06")

files <- paste0(
  "chirps-v3.0.2026.",
  months,
  ".tif"
)

urls <- paste0(base_url, files)

local_files <- file.path(
  "data/chirps3_raw",
  files
)

# ------------------------------------------------------------
# 3. Download April, May and June 2026
# ------------------------------------------------------------

for (i in seq_along(urls)) {
  
  if (!file.exists(local_files[i])) {
    
    message("Downloading: ", files[i])
    
    download.file(
      urls[i],
      destfile = local_files[i],
      mode = "wb"
    )
    
  } else {
    
    message("Already exists: ", files[i])
    
  }
}

# ------------------------------------------------------------
# 4. Load CHIRPS3 rasters
# ------------------------------------------------------------

gu_months <- rast(local_files)

names(gu_months) <- c(
  "April_2026",
  "May_2026",
  "June_2026"
)

print(gu_months)

# ------------------------------------------------------------
# 5. Calculate Gu April-June rainfall total
# ------------------------------------------------------------

gu2026 <- sum(gu_months)

names(gu2026) <- "Gu_2026_mm"

# ------------------------------------------------------------
# 6. Temporary Somaliland-area bounding box
#
# NOTE:
# This is ONLY for our initial QC preview.
# We will use a proper Somaliland boundary later.
# ------------------------------------------------------------

somaliland_bbox <- ext(
  42.4, 49.2,
  7.4, 11.9
)

gu2026_preview <- crop(
  gu2026,
  somaliland_bbox
)

# ------------------------------------------------------------
# 7. Save processed preview raster
# ------------------------------------------------------------

writeRaster(
  gu2026_preview,
  "data/processed/gu_2026_rainfall_preview.tif",
  overwrite = TRUE,
  gdal = c("COMPRESS=LZW")
)

# ------------------------------------------------------------
# 8. QC
# ------------------------------------------------------------

print(gu2026_preview)

global(
  gu2026_preview,
  fun = c("min", "mean", "max"),
  na.rm = TRUE
)

# ------------------------------------------------------------
# 9. Quick plot
# ------------------------------------------------------------

plot(
  gu2026_preview,
  main = "CHIRPS3 Gu Rainfall, April-June 2026 (mm)"
)