# ============================================================
# Somaliland Gu 2026 Rainfall Explorer
# CHIRPS3 | GeoLibre R
# ============================================================

library(geolibre)
library(sf)
library(dplyr)

dir.create(
  "outputs/interactive",
  recursive = TRUE,
  showWarnings = FALSE
)

# ------------------------------------------------------------
# 1. Load regional boundaries + statistics
# ------------------------------------------------------------

regions <- st_read(
  "data/boundaries/somaliland_study_regions.gpkg",
  quiet = TRUE
)

stats <- read.csv(
  "outputs/tables/gu_2026_regional_summary.csv"
)

regions_map <- regions |>
  left_join(
    stats,
    by = c("shapeName" = "Region")
  )

print(
  regions_map |>
    st_drop_geometry() |>
    select(
      shapeName,
      Gu_2026_mm,
      Normal_1991_2020_mm,
      Anomaly_mm,
      Percent_Normal
    )
)

# ------------------------------------------------------------
# 2. Build interactive GeoLibre GIS
# ------------------------------------------------------------

m <- geolibre(
  name = "Somaliland Gu 2026 Rainfall Explorer"
) |>
  
  add_choropleth(
    regions_map,
    column = "Normal_1991_2020_mm",
    name = "1991–2020 Gu Climatology",
    colormap = "blues",
    class_count = 5
  ) |>
  
  add_choropleth(
    regions_map,
    column = "Gu_2026_mm",
    name = "Gu 2026 Rainfall",
    colormap = "blues",
    class_count = 5
  ) |>
  
  add_choropleth(
    regions_map,
    column = "Anomaly_mm",
    name = "Gu 2026 Rainfall Anomaly",
    colormap = "reds",
    class_count = 5
  ) |>
  
  add_choropleth(
    regions_map,
    column = "Percent_Normal",
    name = "Gu 2026 Percent of Normal",
    colormap = "reds",
    class_count = 5
  ) |>
  
  set_view(
    center = c(46.0, 9.5),
    zoom = 5.6
  )

# ------------------------------------------------------------
# 3. Prepare clean swipe comparison
# ------------------------------------------------------------

m <- m |>
  hide_layer("Gu 2026 Rainfall Anomaly") |>
  hide_layer("Gu 2026 Percent of Normal") |>
  split_map(
    "1991–2020 Gu Climatology",
    "Gu 2026 Rainfall",
    orientation = "vertical",
    position = 50
  )

# ------------------------------------------------------------
# 4. Display in RStudio Viewer
# ------------------------------------------------------------

print(m)

# ------------------------------------------------------------
# 5. Export standalone interactive HTML
# ------------------------------------------------------------

to_html(
  m,
  "outputs/interactive/somaliland_gu_2026_geolibre.html",
  title = "Somaliland Gu 2026 Rainfall Explorer"
)

# ------------------------------------------------------------
# 6. Save portable GeoLibre project
# ------------------------------------------------------------

save_project(
  m,
  "outputs/interactive/somaliland_gu_2026.geolibre.json"
)

message("GeoLibre interactive project completed successfully.")