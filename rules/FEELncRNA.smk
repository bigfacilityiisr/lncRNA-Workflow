rule FEELncRNA:
    input:
        gtf = "output/assembled/stringtie/{id}_assembled.gtf",
        annotation = config['annotation']['gtf']  # From config.yaml
    output:
        filtered_gtf = "output/lncRNA/FEELnc/{id}_FEELncRNA.gtf",
        filtered_txt = "output/lncRNA/FEELnc/{id}_FEELncRNA.txt"
    conda:
        "../envs/feelnc.yml"
    log:
        "logs/feelnc/{id}_feelnc.log"
    params:
        monoex = -1,
        min_length = 200,
        threads = 16
    shell:
        """
        perl -I FEELnc-v.0.2.1/lib FEELnc-v.0.2.1/scripts/FEELnc_filter.pl -i {input.gtf} -a {input.annotation} --monoex={params.monoex} -s {params.min_length} -p {params.threads} > {output.filtered_gtf} 2> {log}
        cut -d ";" -f 2 {output.filtered_gtf} | \
        sed 's/ transcript_id //g' | \
        sed 's/"//g' | \
        sed 's/ //g' | \
        sort -u > {output.filtered_txt}
        """

