rule samtools_sort:
    input:
        sam = "output/aligned/sam/{id}_aligned.sam"
    output:
        bam = "output/aligned/bam/{id}_aligned.bam"
    log:
        "logs/samtools/{id}_samtools_sort.log"
    conda:
        "../envs/samtools.yml"
    shell:
        "samtools sort -o {output.bam} {input.sam} > {log} 2>&1" 
