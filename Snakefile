# The way that snakemake works is that it starts by reading the Snakefile, then checking the files that the Snakefile points to.
# Each listed .smk file is evaluated to identify available rules and their relationships.
# This is why the (optional) rule all directive is placed in the Snakefile rather than in a separate .smk file: snakemake will read the Snakefile first, meaning "rule all" is triggered with highest priority.

import pandas as pd

configfile: "config/config.yml"

# Load sample metadata from TSV
df = pd.read_csv(config["sample_table"], sep="\t")

# Extract sample IDs as a list
SRA_ID = df["SRA_ID"].unique().tolist()
config["SRA_ID"] = SRA_ID

rule all:
    input:
        expand("output/intersection/{id}_lncRNAs.txt", id=SRA_ID) 

        
module common_utils:
    snakefile: "rules/common_utils.smk"
    config: config
module get_data:
    snakefile: "rules/get_data.smk"
    config: config
module preprocessing:
    snakefile: "rules/preprocessing.smk"
    config: config
module hisat2_alignment:
    snakefile: "rules/hisat2_alignment.smk"
    config: config
module samtools_sort:
    snakefile: "rules/samtools_sort.smk"
    config: config
module stringtie_assembly:
    snakefile: "rules/stringtie_assembly.smk"
    config: config
module gffread:
    snakefile: "rules/gffread.smk"
    config: config    
module FEELncRNA:
    snakefile: "rules/FEELncRNA.smk"
    config: config
module lncFinder:
    snakefile: "rules/lncFinder.smk"
    config: config
module cpat:
    snakefile: "rules/cpat.smk"
    config: config
module uniprot:
    snakefile: "rules/uniprot.smk"
    config: config
module intersection:
    snakefile: "rules/intersection.smk"
    config: config

use rule * from common_utils
use rule * from get_data
use rule * from preprocessing
use rule * from hisat2_alignment
use rule * from samtools_sort
use rule * from stringtie_assembly
use rule * from gffread
use rule * from FEELncRNA
use rule * from lncFinder
use rule * from cpat
use rule * from uniprot
use rule * from intersection



