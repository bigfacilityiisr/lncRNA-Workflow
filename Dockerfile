FROM mambaorg/micromamba:1.5.8

LABEL maintainer="bigfacilityiisr"
LABEL description="Container environment for LncRNA-Workflow"

USER $MAMBA_USER

RUN micromamba install -y -n base \
    -c conda-forge \
    -c bioconda \
    python=3.11 \
    snakemake=7.32.4 \
    pandas \
    git \
    curl \
    wget \
    procps \
    ca-certificates \
    && micromamba clean --all --yes

WORKDIR /opt/lncRNA-Workflow

COPY --chown=$MAMBA_USER:$MAMBA_USER . .

ENV PYTHONUNBUFFERED=1

CMD ["--help"]
