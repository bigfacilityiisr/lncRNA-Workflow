#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=TRUE)

if (length(args) < 4) {
  stop("Usage: Rscript run_lncFinder.R <transcript_fasta> <model_rda> <mRNA_fasta> <lncRNA_fasta> <output_file>")
}

# Parse arguments
transcript_fasta <- args[1]
model_rda <- args[2]
mRNA_fasta <- args[3]
lncRNA_fasta <- args[4]
output_file <- args[5]

# Load required libraries
library(LncFinder)
library(seqinr)

# Read input sequences
mRNA <- seqinr::read.fasta(file = mRNA_fasta)
lncRNA <- seqinr::read.fasta(file = lncRNA_fasta)
frequencies <- make_frequencies(cds.seq = mRNA, lncRNA.seq = lncRNA, SS.features = FALSE, cds.format = "DNA", lnc.format = "DNA", check.cds = TRUE, ignore.illegal = TRUE)

# Load Plant Model
plant <- readRDS(model_rda)

# Read transcript sequences
Seqs <- seqinr::read.fasta(file = transcript_fasta)

# Run lncFinder
Plant_results <- LncFinder::lnc_finder(Seqs, SS.features = FALSE, format = "DNA", frequencies.file = frequencies, svm.model = plant, parallel.cores = 2)

# Save results
write.table(Plant_results, file = output_file, sep = "\t", row.names = TRUE, col.names = TRUE, quote = FALSE)

