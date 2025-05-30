rule raw_fastqc:
    #Creates a report describing the length and quality of the raw (not trimmed or filtered) reads.
    input:
        r1 = "data/{id}_1.fastq.gz",
        r2 = "data/{id}_2.fastq.gz"
    output:
        "output/fastq/raw/{id}_1.html",
        "output/fastq/raw/{id}_1.zip",
        "output/fastq/raw/{id}_2.html",
        "output/fastq/raw/{id}_2.zip"
    conda:
        "../envs/preprocessing.yml"
    threads: 5
    params:
        outdir = "output/fastqc/raw"
    shell:
        """
        fastqc {input.r1} -o {params.outdir}
        fastqc {input.r1} -o {params.outdir}
        """ 

rule cutadapt_trim:
    # Trims sequencing adapters from reads.
    input:
        r1 = "data/{id}_1.fastq.gz",
        r2 = "data/{id}_2.fastq.gz"
    output:
        trimmed_r1 = temp("output/cutadapt/{id}_1.trimmed.fastq.gz"),
        trimmed_r2 = temp("output/cutadapt/{id}_2.trimmed.fastq.gz")
    conda:
        "../envs/preprocessing.yml"
    threads: 5
    params:
        overlap = config['cutadapt']['overlap'] 
    log:
        "logs/cutadapt/{id}.trimmed.json"
    shell:
        """
        cutadapt \
        -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
        -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
        --cores={threads} \
        -O {params.overlap} \
        -o {output.trimmed_r1} \
        -p {output.trimmed_r2} \
        --json={log} \
        {input.r1} {input.r2}
        """
rule cutadapt_filter:
    #Filters out reads that are too short after trimming
    # Too short reads are retained in .tooshort.fastq, just in case
   #After this rule, *trimmed.fastq files should be automaticaly cleaned up
    input:
        r1 = "output/cutadapt/{id}_1.trimmed.fastq.gz",
        r2 = "output/cutadapt/{id}_2.trimmed.fastq.gz"
    output:
        filtered_r1 = temp("output/cutadapt/{id}_1.filt.fastq.gz"),
        filtered_r2 = temp("output/cutadapt/{id}_2.filt.fastq.gz"),
        tooshort_r1 = temp("output/cutadapt/{id}_1.tooshort.fastq.gz"),
        tooshort_r2 = temp("output/cutadapt/{id}_2.tooshort.fastq.gz")
    conda:
        "../envs/preprocessing.yml"
    threads: 5
    params:
        min_length = config['cutadapt']['min_length']
    log:
        "logs/cutadapt/{id}.filtered.json"
    shell:
        """
        cutadapt \
        -m {params.min_length} \
        --cores={threads} \
        -o {output.filtered_r1} \
        -p {output.filtered_r2} \
        --too-short-output={output.tooshort_r1} \
        --too-short-paired-output={output.tooshort_r2} \
        --json={log} \
        {input.r1} {input.r2}
        """

rule filt_fastqc:
     #Examines the trim-filtered reads with fastqc.
    input:
        r1 = "output/cutadapt/{id}_1.filt.fastq.gz",
        r2 = "output/cutadapt/{id}_2.filt.fastq.gz"
    output:
        "output/fastqc/filt/{id}_1.filt.html",
        "output/fastqc/filt/{id}_2.filt.html",
        "output/fastqc/filt/{id}_1.filt.zip",
        "output/fastqc/filt/{id}_2.filt.zip"
    conda:
        "../envs/preprocessing.yml"
    threads: 5
    params:
        outdir = "output/fastqc/filt"
    shell:
        """
        fastqc {input.r1} -o {params.outdir}
        fastqc {input.r2} -o {params.outdir}
        """
