rule plantlncboost:
    input:
        fasta="output/transcripts/{id}_transcript.fasta",
        model="others/PlantLncBoost/Model/PlantLncBoost_model.cb"
    output:
        prediction="output/lncRNA/plantlncboost/{id}_PlantLncBoost_prediction.csv"
    conda:
        "../envs/plantlncboost.yml"
    params:
        features=temp("output/lncRNA/plantlncboost/{id}_features.csv")
    log:
        "logs/plantlncboost/{id}.log"
    shell:
        """
        # Run feature extraction
        python others/PlantLncBoost/Script/Feature_extraction.py \
            -i {input.fasta} \
            -o {params.features}

        # Run PlantLncBoost prediction
        python others/PlantLncBoost/Script/PlantLncBoost_prediction.py \
            -i {params.features} \
            -m {input.model} \
            -t 0.5 \
            -o {output.prediction} > {log} 2>&1
        """

