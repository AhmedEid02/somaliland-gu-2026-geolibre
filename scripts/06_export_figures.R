# ============================================================
# Export final Gu 2026 analytical figures
# ============================================================

library(terra)

dir.create(
  "outputs/figures",
  recursive = TRUE,
  showWarnings = FALSE
)

# Load final analytical rasters
anomaly <- rast(
  "data/processed/gu_2026_anomaly_mm.tif"
)

percent_normal <- rast(
  "data/processed/gu_2026_percent_normal.tif"
)

regions <- vect(
  "data/boundaries/somaliland_study_regions.gpkg"
)

regions <- project(
  regions,
  crs(anomaly)
)

# ------------------------------------------------------------
# Figure 02 — Gu 2026 rainfall anomaly
# ------------------------------------------------------------

png(
  "outputs/figures/02_gu_2026_anomaly.png",
  width = 1800,
  height = 1200,
  res = 180
)

plot(
  anomaly,
  main = "Gu 2026 Rainfall Anomaly — Somaliland\nRelative to 1991–2020 (mm)"
)

lines(
  regions,
  lwd = 1
)

dev.off()

# ------------------------------------------------------------
# Figure 03 — Percent of normal
# ------------------------------------------------------------

png(
  "outputs/figures/03_gu_2026_percent_normal.png",
  width = 1800,
  height = 1200,
  res = 180
)

plot(
  percent_normal,
  main = "Gu 2026 Rainfall — Somaliland\nPercent of 1991–2020 Normal"
)

lines(
  regions,
  lwd = 1
)

dev.off()

message("Final figures exported successfully.")
file.exists(
  c(
    "outputs/figures/01_gu_2026_spatial_rainfall.png",
    "outputs/figures/02_gu_2026_anomaly.png",
    "outputs/figures/03_gu_2026_percent_normal.png"
  )
)
