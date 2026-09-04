# ============================================================
# Gu 2026 vs 1991–2020 Climatology
# CHIRPS3 | Somaliland
# ============================================================

library(terra)
library(sf)

options(timeout = 600)

# ------------------------------------------------------------
# Paths and settings
# ------------------------------------------------------------

base_url <- paste0(
  "https://data.chc.ucsb.edu/products/",
  "CHIRPS/v3.0/monthly/africa/tifs/"
)

data_dir <- "data/chirps3_climatology"
processed_dir <- "data/processed"

dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(processed_dir, recursive = TRUE, showWarnings = FALSE)

years  <- 1991:2020
months <- c("04", "05", "06")

# ------------------------------------------------------------
# 1. Download ONLY missing files
# ------------------------------------------------------------

for (yr in years) {
  for (mo in months) {
    
    fname <- sprintf("chirps-v3.0.%d.%s.tif", yr, mo)
    dest  <- file.path(data_dir, fname)
    
    if (!file.exists(dest)) {
      
      message("Downloading: ", fname)
      
      tmp <- paste0(dest, ".part")
      
      download.file(
        paste0(base_url, fname),
        tmp,
        mode = "wb",
        method = "libcurl"
      )
      
      # Confirm raster is readable
      test <- rast(tmp)
      
      file.rename(tmp, dest)
      
      message("Completed: ", fname)
      
    } else {
      message("Already exists: ", fname)
    }
  }
}

# ------------------------------------------------------------
# 2. Verify all 90 files exist
# ------------------------------------------------------------

expected <- unlist(
  lapply(
    years,
    function(y)
      file.path(
        data_dir,
        sprintf(
          "chirps-v3.0.%d.%s.tif",
          y,
          months
        )
      )
  )
)

stopifnot(length(expected) == 90)
stopifnot(all(file.exists(expected)))

message("All 90 CHIRPS3 climatology files are available.")

# ------------------------------------------------------------
# 3. Load Somaliland boundary
# ------------------------------------------------------------

boundary <- vect(
  "data/boundaries/somaliland_study_boundary.gpkg"
)

# ------------------------------------------------------------
# 4. Calculate Gu total for every year
# ------------------------------------------------------------

gu_years <- lapply(years, function(yr) {
  
  files <- file.path(
    data_dir,
    sprintf(
      "chirps-v3.0.%d.%s.tif",
      yr,
      months
    )
  )
  
  r <- rast(files)
  
  gu <- sum(r, na.rm = FALSE)
  
  b <- project(boundary, crs(gu))
  
  gu <- mask(
    crop(gu, b),
    b
  )
  
  names(gu) <- paste0("Gu_", yr)
  
  message("Processed Gu ", yr)
  
  gu
})

gu_stack <- rast(gu_years)

# ------------------------------------------------------------
# 5. 1991–2020 climatology
# ------------------------------------------------------------

climatology <- mean(
  gu_stack,
  na.rm = TRUE
)

names(climatology) <- "Gu_1991_2020_mean_mm"

writeRaster(
  climatology,
  file.path(
    processed_dir,
    "gu_1991_2020_climatology.tif"
  ),
  overwrite = TRUE
)

# ------------------------------------------------------------
# 6. Load Gu 2026
# ------------------------------------------------------------

gu2026 <- rast(
  "data/processed/gu_2026_rainfall_somaliland.tif"
)

# ------------------------------------------------------------
# 7. Calculate 2026 anomaly
# ------------------------------------------------------------

anomaly <- gu2026 - climatology
names(anomaly) <- "Gu_2026_anomaly_mm"

percent_normal <- (gu2026 / climatology) * 100
names(percent_normal) <- "Gu_2026_percent_normal"

writeRaster(
  anomaly,
  file.path(
    processed_dir,
    "gu_2026_anomaly_mm.tif"
  ),
  overwrite = TRUE
)

writeRaster(
  percent_normal,
  file.path(
    processed_dir,
    "gu_2026_percent_normal.tif"
  ),
  overwrite = TRUE
)

# ------------------------------------------------------------
# 8. QC summaries
# ------------------------------------------------------------

cat("\n--- Gu 2026 rainfall ---\n")
print(global(gu2026, c("min", "mean", "max"), na.rm = TRUE))

cat("\n--- 1991–2020 climatology ---\n")
print(global(climatology, c("min", "mean", "max"), na.rm = TRUE))

cat("\n--- Gu 2026 anomaly ---\n")
print(global(anomaly, c("min", "mean", "max"), na.rm = TRUE))

cat("\n--- Gu 2026 percent of normal ---\n")
print(global(percent_normal, c("min", "mean", "max"), na.rm = TRUE))

# ------------------------------------------------------------
# 9. Show the key result
# ------------------------------------------------------------

plot(
  anomaly,
  main = "Gu 2026 Rainfall Anomaly — Somaliland\nRelative to 1991–2020 (mm)"
)

message("Exercise 4 completed successfully.")