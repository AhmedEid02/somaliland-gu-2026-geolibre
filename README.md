# Somaliland Gu 2026 Rainfall Explorer

**CHIRPS3 × R × GeoLibre × Agro-Meteorology × Interactive GIS**

🌍 **[Launch the Live Interactive GeoLibre Map](https://ahmedeid02.github.io/somaliland-gu-2026-geolibre/)**

An interactive geospatial analysis of the **2026 Gu rainy season (April–June)** across Somaliland, combining reproducible climate-data processing in R with **GeoLibre R** for interactive spatial exploration.

The project demonstrates a complete workflow from climate-data processing and regional diagnostics to interactive GIS visualization, layer inspection, and swipe-based comparison.

---

## GeoLibre R in action

This project applies **GeoLibre R** to a real climate-analysis workflow rather than a demonstration dataset.

GeoLibre transforms the processed rainfall information into an interactive GIS environment with:

- regional choropleth layers
- interactive layer controls
- attribute inspection
- climatology–2026 swipe comparison
- standalone interactive HTML
- portable `.geolibre.json` project

The live application allows users to compare the **1991–2020 Gu climatology** with **Gu 2026 rainfall** using GeoLibre's vertical swipe control.

🌍 **[Open the interactive GeoLibre application](https://ahmedeid02.github.io/somaliland-gu-2026-geolibre/)**

---

## Research question

**How did Gu 2026 rainfall vary across Somaliland relative to the 1991–2020 climate normal, and which regions experienced the strongest rainfall deficits?**

---

## Key findings

All five analytical regions recorded **below-normal Gu 2026 rainfall** relative to their 1991–2020 climatological means.

| Region | Gu 2026 rainfall (mm) | 1991–2020 normal (mm) | Anomaly (mm) | Percent of normal |
|---|---:|---:|---:|---:|
| Sanaag | 41.7 | 95.1 | **−53.4** | **43.8%** |
| Sool | 44.1 | 89.5 | **−45.4** | **49.3%** |
| Awdal | 53.2 | 83.0 | **−29.8** | **64.1%** |
| Woqooyi Galbeed | 87.0 | 119.4 | **−32.5** | **72.8%** |
| Togdheer | 90.7 | 117.4 | **−26.7** | **77.2%** |

The strongest absolute regional rainfall deficit occurred in **Sanaag**, followed by **Sool**.

These statistics describe rainfall conditions only. They should not be interpreted as direct measurements of crop losses, livestock impacts, agricultural drought, food insecurity, or household outcomes without additional environmental and socioeconomic evidence.

---

## Climate data

Rainfall data are derived from **CHIRPS3 monthly precipitation** products for Africa.

### Analysis periods

- **Gu 2026:** April–June 2026
- **Climatological baseline:** 1991–2020
- **Season definition:** April–June (AMJ)
- **Spatial resolution:** approximately 0.05°

For each climatological year, April, May, and June rainfall were accumulated to produce annual Gu-season totals. The 30 annual Gu totals were then averaged to derive the **1991–2020 Gu climatology**.

Gu 2026 rainfall was compared with this climatology using:

### Rainfall anomaly

```text
Gu 2026 rainfall − 1991–2020 Gu climatology
```

### Percent of normal

```text
(Gu 2026 rainfall / 1991–2020 Gu climatology) × 100
```

---

## Study domain

The analytical study domain includes five first-order administrative units:

- Awdal
- Woqooyi Galbeed
- Togdheer
- Sanaag
- Sool

Administrative boundaries are derived from **geoBoundaries Somalia ADM1**.

The boundary configuration is used solely as an analytical framework for this geospatial exercise and does not imply a position regarding political status, jurisdiction, or territorial claims.

The selected ADM1 dataset does not represent Sahil as a separate first-order administrative unit; its corresponding geography is included within Woqooyi Galbeed in this boundary source.

---

## Interactive GeoLibre project

The GeoLibre project contains four analytical layers:

1. **1991–2020 Gu Climatology**
2. **Gu 2026 Rainfall**
3. **Gu 2026 Rainfall Anomaly**
4. **Gu 2026 Percent of Normal**

The default interactive view uses GeoLibre's **split-map / swipe functionality** to compare:

```text
1991–2020 Gu Climatology  ↔  Gu 2026 Rainfall
```

The anomaly and percent-of-normal layers can also be activated from the GeoLibre layer panel.

### Live application

🌍 **[Launch Somaliland Gu 2026 Rainfall Explorer](https://ahmedeid02.github.io/somaliland-gu-2026-geolibre/)**

---

## Static outputs

The repository contains three reproducible static maps:

```text
outputs/figures/
├── 01_gu_2026_spatial_rainfall.png
├── 02_gu_2026_anomaly.png
└── 03_gu_2026_percent_normal.png
```

These provide complementary spatial summaries of:

- Gu 2026 seasonal rainfall
- rainfall anomaly relative to 1991–2020
- rainfall as a percentage of the climatological normal

---

## Interactive outputs

```text
outputs/interactive/
├── somaliland_gu_2026_geolibre.html
└── somaliland_gu_2026.geolibre.json
```

The HTML file provides the interactive GeoLibre interface, while the `.geolibre.json` file preserves the portable project configuration, layers, styling, map view, and swipe settings.

The public GitHub Pages deployment is generated from:

```text
docs/index.html
```

---

## Regional statistics

The regional rainfall summary is available at:

```text
outputs/tables/gu_2026_regional_summary.csv
```

Regional percent-of-normal values are calculated as the ratio of regional mean Gu 2026 rainfall to regional mean 1991–2020 climatological rainfall.

---

## Reproducible workflow

The analysis is organized into six R scripts:

```text
scripts/
├── 01_download_gu2026.R
├── 02_mask_somaliland.R
├── 03_gu_climatology_anomaly.R
├── 04_regional_summary.R
├── 05_geolibre_map.R
└── 06_export_figures.R
```

### Workflow

```text
CHIRPS3 monthly rainfall
        ↓
Gu 2026 seasonal accumulation
        ↓
Somaliland study-area masking
        ↓
1991–2020 annual Gu totals
        ↓
30-year Gu climatology
        ↓
Rainfall anomaly
        ↓
Percent of normal
        ↓
Regional diagnostics
        ↓
Static maps
        ↓
GeoLibre interactive GIS
        ↓
Swipe comparison + HTML + GeoLibre project
```

---

## Reproducing the analysis

Clone the repository:

```bash
git clone https://github.com/AhmedEid02/somaliland-gu-2026-geolibre.git
cd somaliland-gu-2026-geolibre
```

Install the required R packages:

```r
source("requirements.R")
```

Then run the scripts sequentially:

```r
source("scripts/01_download_gu2026.R")
source("scripts/02_mask_somaliland.R")
source("scripts/03_gu_climatology_anomaly.R")
source("scripts/04_regional_summary.R")
source("scripts/05_geolibre_map.R")
source("scripts/06_export_figures.R")
```

The climatology workflow downloads the required CHIRPS3 monthly files when they are not already available locally.

---

## Data management

Large raw CHIRPS3 downloads are intentionally excluded from version control.

The repository retains:

- reproducible download scripts
- analytical boundary files
- processed climate products
- regional statistics
- static figures
- interactive GeoLibre outputs

This keeps the repository lightweight while preserving the ability to reproduce the workflow from the original rainfall data.

Additional information is available in:

```text
data/README.md
```

---

## Repository structure

```text
somaliland-gu-2026-geolibre/
│
├── data/
│   ├── README.md
│   ├── boundaries/
│   └── processed/
│
├── docs/
│   └── index.html
│
├── outputs/
│   ├── figures/
│   ├── interactive/
│   └── tables/
│
├── scripts/
│   ├── 01_download_gu2026.R
│   ├── 02_mask_somaliland.R
│   ├── 03_gu_climatology_anomaly.R
│   ├── 04_regional_summary.R
│   ├── 05_geolibre_map.R
│   └── 06_export_figures.R
│
├── .gitignore
├── CITATION.cff
├── LICENSE
├── README.md
└── requirements.R
```

---

## Why GeoLibre R?

A central purpose of this repository is to explore how **GeoLibre R** can connect reproducible spatial analysis with interactive GIS.

Instead of ending the workflow with static maps, processed climate information is passed directly from R into GeoLibre, where users can inspect layers, explore regional attributes, and compare climatological and seasonal rainfall through an interactive swipe interface.

The workflow provides a practical bridge between:

**climate-data analysis → geospatial computation → interactive GIS communication**

---

## Tools

- **R**
- **GeoLibre R**
- **terra**
- **sf**
- **dplyr**
- **CHIRPS3**
- **GeoJSON / GeoPackage**
- **Git & GitHub**
- **GitHub Pages**

---

## Scientific interpretation

This repository is designed primarily as a reproducible **climate-data and interactive geospatial workflow**.

Rainfall anomalies provide information about precipitation departures from climatological conditions, but rainfall alone does not establish agricultural drought, crop failure, food insecurity, vegetation stress, or socioeconomic impact.

Such interpretations require additional variables and independent evidence.

---

## Acknowledgment

Special appreciation to **Dr. Qiusheng Wu** for developing and advancing **GeoLibre** and extending its capabilities to the R ecosystem.

GeoLibre R provides a useful bridge between reproducible R-based geospatial analysis and modern interactive GIS workflows.

---

## Author

**Ahmed Hussein Ismail**

Agro-Meteorology | Climate Data Analysis | GIS & Remote Sensing | Geospatial Research

GitHub: [AhmedEid02](https://github.com/AhmedEid02)

---

## Citation

Citation metadata are provided in:

```text
CITATION.cff
```

GitHub's **Cite this repository** functionality can be used to generate citation formats from this metadata.

---

## License

This project is released under the **MIT License**.

See [`LICENSE`](LICENSE) for details.
