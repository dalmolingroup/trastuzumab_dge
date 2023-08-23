# Trastuzumab DGE

This repository contains a differential gene expression (DGE) analysis for three distinct datasets
of cardiomyocite expression after Trastuzumab treatment.
The results of the different DGEs were then used for a meta-analysis.

## Analysis Notebooks

- [RNA-Seq](./reports/RNASeq.html) - [Source](./analysis/RNASeq.Rmd)
- [GSE107385](./reports/GSE107385.html) - [Source](./analysis/GSE107385.Rmd)
- [Select Genes](./reports/select_genes.html) - [Source](./analysis/select_genes.Rmd)
- [Assemble Network](./reports/assemble_network.html) - [Source](./analysis/assemble_network.Rmd)

## Repository Structure

```
.
├── analysis
├── data
├── renv
├── reports
└── results
```

- `analysis`
  - GSE107385.Rmd
    - DGE for the GSE107385 microarray dataset
  - RNASeq.Rmd
    - DGE for the other two RNA-Seq datasets
  - select_genes.Rmd
    - Select genes associated to mitophagy, autophagy and mitochondrial biogenesis
  - make_upset.R
    - Script to generate UpSet plot with intersections between grouped processes.
  - assemble_network.Rmd
    - Assemble PPI network between metanalysis genes.
- `data`
  - `Plataformas.csv`
    - Original metadata for the three studies
  - `meta-analise.csv`
    - Meta-analysis results
  - A directory for each dataset
    - Containing the count matrix for the microarray dataset and the Kallisto results for the RNA-Seq datasets
- `reports`
  - Analysis notebooks in HTML format
- `results`
  - All results from the `analysis` notebooks.
