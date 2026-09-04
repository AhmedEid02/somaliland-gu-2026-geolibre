# Somaliland Gu 2026 Rainfall Anomaly Explorer

**CHIRPS3 × R × GeoLibre × Agro-Meteorology × Interactive GIS**

An interactive geospatial analysis of the **2026 Gu rainy season (April–June)** across Somaliland, comparing observed CHIRPS3 rainfall with the **1991–2020 climatological baseline**.

The project combines reproducible climate-data processing in R with the newly available **GeoLibre R** package to move from raw rainfall grids to regional diagnostics and an interactive GIS comparison.

---

## Research question

**How did Gu 2026 rainfall vary across Somaliland relative to the 1991–2020 climate normal, and which regions experienced the strongest rainfall deficits?**

---

## Key finding

All five analytical regions recorded **below-normal Gu 2026 rainfall** relative to their 1991–2020 climatological means.

| Region | Gu 2026 rainfall (mm) | 1991–2020 normal (mm) | Anomaly (mm) | Percent of normal |
|---|---:|---:|---:|---:|
| Sanaag | 41.7 | 95.1 | **−53.4** | **43.8%** |
| Sool | 44.1 | 89.5 | **−45.4** | **49.3%** |
| Awdal | 53.2 | 83.0 | **−29.8** | **64.1%** |
| Woqooyi Galbeed | 87.0 | 119.4 | **−32.5** | **72.8%** |
| Togdheer | 90.7 | 117.4 | **−26.7** | **77.2%** |

The strongest absolute regional rainfall deficit occurred in **Sanaag**, followed by **Sool**.

These values describe rainfall conditions only. They are not interpreted as direct crop-yield losses or measured agricultural impacts.

---

## Interactive GeoLibre analysis

The project uses **GeoLibre R** to transform the climate analysis into an interactive GIS environment.

The final project contains:

- Gu 2026 regional rainfall
- 1991–2020 Gu climatology
- Gu 2026 rainfall anomaly
- Gu 2026 percent of normal
- interactive layer controls
- regional attribute inspection
- climatology–2026 split-map comparison
- standalone interactive HTML
- portable `.geolibre.json` project

### Interactive outputs

```text
outputs/interactive/
├── somaliland_gu_2026_geolibre.html
└── somaliland_gu_2026.geolibre.json