# Data

This repository uses real satellite-derived rainfall data and open administrative boundaries.

## CHIRPS3 rainfall

Rainfall data are from the Climate Hazards Center InfraRed Precipitation with Stations version 3 (CHIRPS3).

The analysis uses:

- Gu 2026 rainfall: April–June 2026
- Climatological reference period: 1991–2020
- Monthly CHIRPS3 Africa GeoTIFFs
- Spatial resolution: 0.05°

Raw CHIRPS3 GeoTIFFs are not redistributed in this repository because they are downloaded reproducibly by the R scripts from the official Climate Hazards Center archive.

## Administrative boundaries

Somalia ADM1 boundaries were obtained from the geoBoundaries open administrative boundary dataset.

For this analysis, the Somaliland study domain is constructed from:

- Awdal
- Woqooyi Galbeed
- Togdheer
- Sool
- Sanaag

The study boundary is used solely as an analytical geographic domain. It does not imply a position on political status or territorial claims.

The ADM1 source used here does not represent Sahil as a separate unit; the corresponding area is contained within the Woqooyi Galbeed geography.

## Processed data

The `processed/` directory contains lightweight derived rasters produced by the analysis:

- Gu 2026 rainfall total
- 1991–2020 Gu climatological mean
- Gu 2026 rainfall anomaly
- Gu 2026 percent of climatological normal

All derived values can be regenerated from the scripts in `scripts/`.