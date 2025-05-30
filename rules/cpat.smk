rule cpat:
    input:
        transcript="output/transcripts/{id}_transcript.fasta",
        hexamer="others/Model/Plant_Hexamer.tsv",
        logit="others/Model/Plant.logit.RData"
    output:
        "output/lncRNA/cpat/{id}_CPAT"
    log:
        "logs/cpat/{id}.log"
    conda:
        "../envs/cpat.yml"
    shell:
        "cpat.py -x {input.hexamer} -d {input.logit} -g {input.transcript} -o {output} > {log} 2>&1"

