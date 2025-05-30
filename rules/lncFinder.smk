rule lnc_finder:
    input:
        fasta="output/transcripts/{id}_transcript.fasta",
        model="others/Model/Plant_model.rda",
        mRNA="others/example_data/training_mRNA.fasta",
        lncRNA="others/example_data/training_lncRNA.fasta"
    output:
        results="output/lncRNA/lncFinder/{id}_plant-lncFinder.txt"
    params:
        script="scripts/run_lncFinder.R"
    log:
        "logs/lncFinder/{id}.log"
    conda:
        "../envs/lncFinder.yml"
    shell:
        "Rscript {params.script} {input.fasta} {input.model} {input.mRNA} {input.lncRNA} {output.results} > {log} 2>&1"

