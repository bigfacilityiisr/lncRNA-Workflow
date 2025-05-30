rule uniprot_blast:
    input:
        transcript="output/transcripts/{id}_transcript.fasta"  
    output:
        "output/uniprot/uniprot_{id}.txt"  
    log:
        "logs/uniprot/uniprot_blast_{id}.log" 
    conda:
        "../envs/diamond.yml"
    shell:
        """
        if [ ! -f uniprot_sprot.fasta ]; then
            wget https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
            gunzip uniprot_sprot.fasta.gz
        fi

        diamond makedb --in uniprot_sprot.fasta -d uniprot_out

        diamond blastx -d uniprot_out -q {input.transcript} -o {output} > {log} 2>&1
        """

