rule FEELncRNA:
    input:
        gtf = "/media/hp/DATADRIVE1/lncRNA-Workflow/output/assembled/stringtie/{id}_assembled.gtf",
        annotation = config['annotation']['gtf']  # From config.yaml
    output:
        filtered_gtf = "/media/hp/DATADRIVE1/lncRNA-Workflow/output/lncRNA/FEELnc/{id}_FEELncRNA.gtf",
        filtered_txt = "/media/hp/DATADRIVE1/lncRNA-Workflow/output/lncRNA/FEELnc/{id}_FEELncRNA.txt"
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
        export FEELNCPATH="$(pwd)/FEELnc-v.0.2.1"
        export PERL5LIB="${{FEELNCPATH}}/lib:${{CONDA_PREFIX}}/lib/perl5/site_perl/5.22.0:${{PERL5LIB:-}}"

        perl -I FEELnc-v.0.2.1/lib FEELnc-v.0.2.1/scripts/FEELnc_filter.pl -i {input.gtf} -a {input.annotation} --monoex={params.monoex} -s {params.min_length} -p {params.threads} > {output.filtered_gtf} 2> {log}
        cut -d ";" -f 2 {output.filtered_gtf} | \
        sed 's/ transcript_id //g' | \
        sed 's/"//g' | \
        sed 's/ //g' | \
        sort -u > {output.filtered_txt}
        """
