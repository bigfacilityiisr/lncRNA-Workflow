rule star_index:
    input:
        fasta = config['reference']['fasta'],
        gtf = config['annotation']['gtf']  # Optional but recommended
    output:
        index_dir=directory("data/index/star/")
    threads: 4
    params:
        sjdbOverhang = config['star']['sjdbOverhang'],
    conda:
        "../envs/star_alignment.yml"
    shell:
        """
        # Create the output directory if it doesn't exist
        mkdir -p {output.index_dir}
        
        # Decompress the FASTA file
        zcat {input.fasta} > {output.index_dir}/genome.fna
        
        # Generate the genome index
        STAR \
            --runMode genomeGenerate \
            --genomeDir {output.index_dir} \
            --genomeFastaFiles {input.fasta} \
            --sjdbGTFfile {input.gtf} \
            --sjdbOverhang {params.sjdbOverhang} \
            --runThreadN {threads}
        rm {output.index_dir}/genome.fna
        """


rule star_alignment:
    # Aligns reads to the reference genome using STAR.
    input:
        trimmed_r1 = "output/cutadapt/{id}_1.filt.fastq.gz",
        trimmed_r2 = "output/cutadapt/{id}_2.filt.fastq.gz",
        index = "data/index/star/"
    output:
        bam = "output/star/{id}.Aligned.sortedByCoord.out.bam"
    conda:
        "../envs/star_alignment.yml"
    threads: 10
    params:
        sjdbOverhang = config['star']['sjdbOverhang'],
        outdir = "output/star/{id}"
    log:
        "logs/star/{id}.log"
    shell:
        """
        mkdir -p {params.outdir}

        STAR \
        --runThreadN {threads} \
        --genomeDir {input.index} \
        --readFilesIn {input.trimmed_r1} {input.trimmed_r2} \
        --readFilesCommand zcat \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMstrandField intronMotif \
        --outSAMattrRGline ID:{wildcards.id} LB:library SM:sample PL:platform PU:unit \
        --outFilterType BySJout \
        --outFilterMultimapNmax 20 \
        --alignSJoverhangMin 8 \
        --alignSJDBoverhangMin 1 \
        --outFilterMismatchNmax 999 \
        --outFilterMismatchNoverReadLmax 0.04 \
        --alignIntronMin 20 \
        --alignIntronMax 1000000 \
        --alignMatesGapMax 1000000 \
        --outFileNamePrefix {params.outdir}/ \
        --outSAMtype BAM SortedByCoordinate > {log} 2>&1
        """
