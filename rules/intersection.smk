rule intersection:
    input:
        candidate_lncRNA = "output/lncRNA/FEELnc/{id}_FEELncRNA.txt",  
        cpat_output = "output/lncRNA/cpat/{id}_CPAT",  
        LncFinder = "output/lncRNA/lncFinder/{id}_plant-lncFinder.txt",
        uniprot_output = "output/uniprot/uniprot_{id}.txt" 
    output:
        "output/intersection/{id}_lncRNAs.txt"
    conda:
        "../envs/intersection.yml"  
    params:
        script="scripts/intersection.sh"
    log:
        "logs/intersection/{id}_intersection.log"  
    shell:
        """
        Rscript {params.script} {input.candidate_lncRNA} {input.candidate_lncRNA} {input.cpat_output} {input.LncFinder} {input.uniprot_output} {output} > {log} 2>&1
        """


