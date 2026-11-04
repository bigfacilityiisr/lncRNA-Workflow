cat > envs/lncFinder.post-deploy.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Install LncFinder into this Snakemake Conda environment.
"$CONDA_PREFIX/bin/Rscript" --no-environ -e '
options(repos = c(CRAN = "https://cloud.r-project.org"))

if (!requireNamespace("LncFinder", quietly = TRUE)) {
    install.packages("LncFinder", lib = .Library)
}

if (!requireNamespace("LncFinder", quietly = TRUE)) {
    stop("LncFinder installation failed")
}

version <- as.character(packageVersion("LncFinder"))
cat("Installed LncFinder version:", version, "\n")

if (version != "1.1.6") {
    stop("Expected LncFinder version 1.1.6, found ", version)
}
'
EOF
