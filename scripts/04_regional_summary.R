# ============================================================
# Gu 2026 Regional Rainfall Diagnostics
# Somaliland | CHIRPS3
# ============================================================

library(terra)
library(dplyr)

dir.create(
  "outputs/tables",
  recursive = TRUE,
  showWarnings = FALSE
)

# ------------------------------------------------------------
# 1. Load regions and analytical rasters
# ------------------------------------------------------------

regions <- vect(
  "data/boundaries/somaliland_study_regions.gpkg"
)

gu2026 <- rast(
  "data/processed/gu_2026_rainfall_somaliland.tif"
)

climatology <- rast(
  "data/processed/gu_1991_2020_climatology.tif"
)

anomaly <- rast(
  "data/processed/gu_2026_anomaly_mm.tif"
)

percent_normal <- rast(
  "data/processed/gu_2026_percent_normal.tif"
)

regions <- project(
  regions,
  crs(gu2026)
)

# ------------------------------------------------------------
# 2. Regional spatial means
# ------------------------------------------------------------

r2026 <- extract(
  gu2026,
  regions,
  mean,
  na.rm = TRUE,
  exact = TRUE
)

rnormal <- extract(
  climatology,
  regions,
  mean,
  na.rm = TRUE,
  exact = TRUE
)

ranomaly <- extract(
  anomaly,
  regions,
  mean,
  na.rm = TRUE,
  exact = TRUE
)

rpct <- extract(
  percent_normal,
  regions,
  mean,
  na.rm = TRUE,
  exact = TRUE
)

# ------------------------------------------------------------
# 3. Build final regional table
# ------------------------------------------------------------

summary_table <- data.frame(
  Region = values(regions)$shapeName,
  Gu_2026_mm = round(r2026[, 2], 1),
  Normal_1991_2020_mm = round(rnormal[, 2], 1),
  Anomaly_mm = round(ranomaly[, 2], 1),
  Percent_Normal = round(
    (r2026[, 2] / rnormal[, 2]) * 100,
    1
  )
) |>
  arrange(Percent_Normal)

print(summary_table)

# ------------------------------------------------------------
# 4. Export CSV
# ------------------------------------------------------------

write.csv(
  summary_table,
  "outputs/tables/gu_2026_regional_summary.csv",
  row.names = FALSE
)

message("Exercise 5 completed successfully.")