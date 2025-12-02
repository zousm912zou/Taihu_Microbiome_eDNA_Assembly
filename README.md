
# **Taihu_Microbiome_eDNA_Assembly**

### Repository for the workflow accompanying the manuscript:

**“Seasonal Rebalancing of Assembly Processes and Cross-Domain Network Rewiring in Prokaryotic and Eukaryotic Microbial Communities of a Large Eutrophic Lake”**

---

# 🚀 **Quick Start**

If all input files are placed under `example_data/`, each analytical module can be run independently:

```bash
cd scripts
Rscript Part1_Diversity_indicators.R
```

To run the entire pipeline end-to-end:

```bash
cd scripts
Rscript master_pipeline.R
```

All modules are fully modular and reproducible.

---

# 📘 **Overview**

This repository provides a **complete, modular, and fully reproducible R pipeline** for multi-marker eDNA analysis (16S, 18S, 23S).
It characterizes **seasonal microbial community assembly mechanisms**, **environmental filtering**, **neutral processes**, and **cross-domain interaction networks** in a large eutrophic lake.

The workflow covers:

* Diversity and indicator species
* NMDS / CCA / environmental fitting
* PERMANOVA & beta dispersion
* Variation partitioning (environment vs. space)
* Distance–decay relationships
* Phylogenetic null models (βNTI)
* Abundance-based null models (RC_bray)
* Neutral model fitting
* SparCC networks
* Network topology / robustness / cross-season comparison

Every module can be run independently.

---

# 📁 **Repository Structure**

```
📁 Repository
│
├── example_data/
│   ├── ASV.csv
│   ├── Group.csv
│   ├── Taxonomy.csv
│   ├── Tree.nwk
│   ├── ENV.csv
│   ├── JWD.csv
│   ├── Network_ASV_Spring.csv
│   ├── Network_ASV_Summer.csv
│   └── Network_taxonomy.csv
│
├── scripts/
│   ├── Part1_Diversity_indicators.R
│   ├── Part2_NMDS_CCA_PERMANOVA.R
│   ├── Part3_Varpart_distance_decay.R
│   ├── Part4_Null_neutral.R
│   ├── Part5_Network_SparCC.R
│   └── master_pipeline.R
│
└── README.md
```

---

# 📑 **Required Input Files**

| File                                    | Description                            |
| --------------------------------------- | -------------------------------------- |
| **ASV.csv**                             | Sample × ASV abundance matrix          |
| **Group.csv**                           | Sample metadata (Season, Region, etc.) |
| **Taxonomy.csv / Network_taxonomy.csv** | ASV taxonomy                           |
| **Tree.nwk**                            | Phylogenetic tree for βNTI             |
| **ENV.csv**                             | Environmental variables                |
| **JWD.csv**                             | Spatial coordinates                    |
| **Network_ASV_Spring.csv**              | Spring ASV table for SparCC            |
| **Network_ASV_Summer.csv**              | Summer ASV table for SparCC            |

All scripts assume **matching sample names** across files.

---

# ⭐ **Part 1 — Diversity & Indicator Species**

**Script:** `Part1_Diversity_indicators.R`

### Includes:

* Phylum-level abundance profiles
* Seasonal/region diversity comparisons
* Indicator species detection (IndVal.g)
* Indicator-environment correlation analysis
* Heatmaps, stacked barplots, boxplots

### Outputs:

* Top-10 dominant phyla (abundance-based)
* Indicator species lists
* Indicator–environment heatmap
* Diversity summary tables

---

# ⭐ **Part 2 — NMDS, CCA, Environmental Drivers & PERMANOVA**

**Script:** `Part2_NMDS_CCA_PERMANOVA.R`

### Includes:

* NMDS (Bray–Curtis, Hellinger transformed)
* Automated outlier removal
* CCA ordination + environmental vectors (envfit)
* Significance testing for axes and overall model
* PERMANOVA by Season / Region / Season×Region
* Beta dispersion (betadisper)
* Bray–Curtis pairwise distance distributions

### Outputs:

* `Example_NMDS.png`
* `Example_CCA.png`
* PERMANOVA tables
* Beta-dispersion tables
* Bray–Curtis distance plot (`Example_BrayCurtis_Boxplot.png`)
* `Example_Ordination_Results.xlsx`

All results exactly match Figure 2 and Figure S5 of the manuscript.

---

# ⭐ **Part 3 — Variation Partitioning & Distance–Decay**

**Script:** `Part3_Varpart_distance_decay.R`

### A. Variation Partitioning

* Hellinger-transformed ASV table
* Pure environmental fraction
* Pure spatial fraction (dbMEM)
* Shared / unexplained variance
* Spring vs Summer comparisons (dumbbell plots)

### B. Distance–Decay

* Geographic distance (Haversine)
* Bray–Curtis dissimilarity
* Mantel tests
* Season-specific regressions with annotated equations

### Outputs:

* Variation partitioning tables & plots
* Distance–decay regression figures

Matches Figure 4 and Figure S7 in the manuscript.

---

# ⭐ **Part 4 — βNTI, RC_bray & Neutral Model**

**Script:** `Part4_Null_neutral.R`

### Includes:

* βNTI using phylogenetic null model (taxaShuffle)
* RC_bray based on sample-wise null permutations
* Neutral model fitting (MicEco)
* Season-wise distributions and comparisons

### Outputs:

* βNTI distribution plots
* RC_bray boxplots
* Neutral model curves
* Summary tables

These correspond to Figure 3 and related analyses.

---

# ⭐ **Part 5 — SparCC Interaction Networks & Robustness**

**Script:** `Part5_Network_SparCC.R`

### Includes:

* SparCC correlation inference (SpiecEasi)
* Filtering edges by |ρ| ≥ 0.07
* Positive/negative edge classification
* Node-level properties:

  * Degree
  * Phylum
* Network topology:

  * Node count
  * Edge count
  * Average path length
  * Transitivity
  * Proportion of positive edges
  * Module detection (fast-greedy)
* Robustness analysis:

  * Iterative targeted removal of highest-degree nodes
  * AUC calculation (network resilience)
* Global color harmonization across seasons
* Combined side-by-side network visualization
* Export of Excel tables (edge list + statistics)

### Outputs:

* `Example_Spring_Summer_Comparison_Bacterioplankton.png`
* `Network_Comparison_Summary_Table_Bacterioplankton.xlsx`
* `Figure7_Robustness_Curves_Bacterioplankton.png`
* `Network_Analysis_Workspace_Bacterioplankton.RData`

These correspond to Figure 6–7 and Figures S8–S11.

---

# 🌱 **Extending the Pipeline to New Taxonomic Groups**

To analyze another microbial group:

1. Prepare a new ASV table
2. Ensure sample names match `Group.csv`
3. Provide corresponding taxonomy file
4. (Optional) Provide phylogenetic tree for βNTI
5. Run any Part independently

All plots and statistics update automatically.

---

# 📚 **Citation**

Please cite our manuscript when using this workflow.

For questions, please contact the authors.

---

# **END OF README.md**

---

