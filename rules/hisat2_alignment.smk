rule hisat2_index:
    input:
        fasta = config['reference']['fasta']
    output:
        expand("data/index/hisat2/genome.{suffix}", suffix = ['1.ht2', '2.ht2', '3.ht2', '4.ht2', '5.ht2', '6.ht2', '7.ht2', '8.ht2'])
    threads: 8
    log:
        "logs/hisat2/hisat2_index.log"
    conda:
        "../envs/hisat2_alignment.yml"
    shell:
        """
        # Create the output directory if it doesn't exist
        mkdir -p data/index/hisat2
        # Build the HISAT2 index
        hisat2-build -p {threads} {input.fasta} data/index/hisat2/genome
        """



rule hisat2_alignment:
    input:
        index=expand("data/index/hisat2/genome.{suffix}", suffix = ['1.ht2', '2.ht2', '3.ht2', '4.ht2', '5.ht2', '6.ht2', '7.ht2', '8.ht2']),
        R1 = "output/cutadapt/{id}_1.filt.fastq.gz",
        R2 = "output/cutadapt/{id}_2.filt.fastq.gz"
    output:
        sam = temp("output/aligned/sam/{id}_aligned.sam")
    conda:
        "../envs/hisat2_alignment.yml"
    params:
        threads=8
    log:  
        "logs/hisat2/{id}_hisat2.log"
    shell:
        """
        hisat2 --new-summary -p {params.threads} -x data/index/hisat2/genome -1 {input.R1} -2 {input.R2} -S {output.sam} > {log} 2>&1
        """
