
FROM condaforge/miniforge3:24.9.2-0

LABEL maintainer="bigfacilityiisr"
LABEL description="Container environment for LncRNA-Workflow"

RUN conda install -n base -y \
    -c conda-forge \
    -c bioconda \
    python=3.11 \
    snakemake=7.32.4 \
    mamba \
    pandas \
    git \
    curl \
    wget \
    ca-certificates \
    && conda clean -afy

WORKDIR /opt/lncRNA-Workflow

COPY . .

ENV PYTHONUNBUFFERED=1

CMD ["--help"]
