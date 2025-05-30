#!Rscript
# Usage: Rscript intersect_lncRNAs.R candidates.txt short.txt cpat.txt lncfinder.txt swissprot.txt output.txt
##################################################################################################################
# Taking the intersection of lncRNA identification results to obtain high-confidence lncRNAs.
##################################################################################################################

# Read command line arguments
args <- commandArgs(TRUE)

# Define input files
candidate_lncRNA_file <- args[1]
short_file <- args[2]
cpat_file <- args[3]
lncfinder_file <- args[4]
swissprot_file <- args[5]
output_file <- args[6]

# Load necessary libraries
if (!require("dplyr")) {
    install.packages("dplyr", repos = "https://cloud.r-project.org/")
    library(dplyr)
}

if (!require("readr")) {
    install.packages("readr", repos = "https://cloud.r-project.org/")
    library(readr)
}

# Read the input files
candidate_lncRNA <- read.table(candidate_lncRNA_file, header = FALSE, col.names = "genes") %>% pull(genes)
length <- read_delim(short_file, delim = "\t", col_names = FALSE, show_col_types = FALSE) %>% pull(X1)
CPAT <- read_delim(cpat_file, delim = "\t", show_col_types = FALSE) %>% filter(coding_prob < 0.46) %>% pull(mRNA_size)
LncFinder <- read_delim(lncfinder_file, delim = "\t", show_col_types = FALSE) %>% filter(Coding.Potential == "NonCoding") %>% pull(Pred)
uniprot <- read_delim(swissprot_file, delim = "\t", col_names = FALSE, show_col_types = FALSE) %>% filter(X3 > 60, X11 < 1e-5) %>% pull(X1) %>% unique()

  
# Exclude uniprot matches from the candidate lncRNAs
uniprot <- dplyr::setdiff(candidate_lncRNA, uniprot)

# Take intersection of all the criteria
lncRNA <- Reduce(intersect, list(length, CPAT, LncFinder, uniprot))

# Write the result to the output file
write.table(lncRNA, file = output_file, row.names = FALSE, col.names = FALSE, quote = FALSE)

