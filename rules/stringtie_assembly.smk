rule stringtie_assembly:
    input:
        bam = "output/aligned/bam/{id}_aligned.bam",
        gtf = config['annotation']['gtf']
    output:
        gtf = "output/assembled/stringtie/{id}_assembled.gtf"
    conda:
        "../envs/stringtie_assembly.yml"
    log:
        "logs/stringtie/{id}_stringtie.log"
    params:
        threads=8
    shell:
        "stringtie -p {params.threads} -G {input.gtf} -o {output.gtf} {input.bam} > {log} 2>&1"


