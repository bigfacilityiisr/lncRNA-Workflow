# 🧬 lncRNA-Workflow

**A modular and reproducible Snakemake pipeline for identification and analysis of lncRNAs from RNA-seq data.**

This pipeline is designed to start directly from **SRA accession IDs** and automate the full process of identifying both known and novel **long non-coding RNAs (lncRNAs)** using a set of standard and powerful tools. It’s ideal for beginners who want a reproducible way to analyze RNA-seq data with minimal setup.

---

## 🧾 Table of Contents

- [Overview](#overview)
- [Workflow Summary](#workflow-summary)
- [Requirements](#requirements)
- [Installation](#installation)
- [How to Use](#how-to-use)
- [Output](#output)
- [Visualization](#visualization)
- [Credits](#credits)

---

## 📖 Overview

lncRNAs (long non-coding RNAs) are transcripts longer than 200 nucleotides that do not encode proteins but often regulate gene expression. This pipeline provides a **start-to-finish workflow**: from downloading RNA-seq data (via SRA) to predicting high-confidence lncRNAs using multiple tools and filters.

---

## 🔁 Workflow Summary

The figure below shows the structure of the pipeline:

![Workflow Graph](rulegraph.png)

### Key Steps:

1. **get_reads** – Automatically downloads RNA-seq datasets using SRA IDs (via `fastq-dump` or `prefetch`).
2. **cutadapt_trim & cutadapt_filter** – Removes adapter sequences and filters low-quality reads.
3. **hisat2_index** – Builds genome index from the reference genome.
4. **hisat2_alignment** – Aligns reads to the reference genome.
5. **samtools_sort** – Sorts aligned reads for assembly.
6. **stringtie_assembly** – Assembles transcripts from the aligned reads.
7. **gffread** – Processes the GTF file for compatibility.
8. **FEELncRNA, CPAT, lnc_finder** – Apply multiple tools to identify lncRNAs based on coding potential.
9. **uniprot_blast** – Removes known protein-coding transcripts.
10. **intersection** – Combines filtered results from all tools to identify high-confidence lncRNAs.
11. **all** – Final results.

---

## 💻 Requirements

- **Snakemake ≥ 7.0**
- **Python ≥ 3.6**
- **Conda** (recommended)

### Required Tools (installed automatically via Conda environments):
- `sra-tools` (for `fastq-dump`)
- `cutadapt`
- `hisat2`
- `samtools`
- `stringtie`
- `gffread`
- `CPAT`
- `FEELnc`
- `BLAST+`

---

## ⚙️ Installation

Clone the repository:

```bash
git clone https://github.com/bigfacilityiisr/lncRNA-Workflow.git
cd lncRNA-Workflow
