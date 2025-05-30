# have used wildcards to indicate sample SRA_ID

rule get_reads:
    # Given an NCBI Sequence Read Archive (SRA) ID, downloads a subset of reads(specify n_reads=10000,etc) in config file if subset only is required) associated with the ID.
    # This rule doesn't operate on a file as input, so we don't provide an input field.
    # Note: We apply the temporary flag to these files because we want to remove them after preprocesssing step
    output:
        temp("data/{id}_1.fastq.gz"),
        temp("data/{id}_2.fastq.gz")
    conda:
        '../envs/get_data.yml'
    params:
        outdir = 'data'
    resources:
        sra_download=1 
    shell:
        """
        fastq-dump --split-files -O {params.outdir} {wildcards.id} && \
        gzip {params.outdir}/{wildcards.id}_1.fastq {params.outdir}/{wildcards.id}_2.fastq
        """


