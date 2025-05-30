rule gffread:
    input:
        gtf = "output/assembled/stringtie/{id}_assembled.gtf",
        genome = config['reference']['fasta']  
    output:
        fasta = "output/transcripts/{id}_transcript.fasta"
    conda:
        "../envs/gffread.yml"  
    log:
        "logs/gffread/{id}_gffread.log"
    shell:
        "gffread -w {output.fasta} -g {input.genome} {input.gtf} > {log} 2>&1"
        
rule extract_transcript_ids:
    input:
        fasta = "output/transcripts/{id}_transcript.fasta"
    output:
        txt = "output/transcripts/{id}_transcript.txt"
    shell:
        """
        grep '>' {input.fasta} | awk '{{print $1}}' | sed 's/>//g' | sort -u > {output.txt}
        """


