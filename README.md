# Genetic annotation challenge

## Goal of the challenge

1. Create an interactive dashboard (i.e with Shiny, interactive notebook or web framework ) that allows you to select the file provided as an example and show the results of the analysis described below.
2. Create a Nextlfow/CWL/WDL pipeline that processes input data and generates all output results required by 1. to visualize the results.

## Workflow

## Using the Snakemake pipeline

We assume that you already have conda and Snakemake installed, otherwise you can easily install them with the following commands:

To install conda: https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html

To install Snakemake via conda: conda install -c conda-forge -c bioconda snakemake snakemake-wrapper-utils mamba
```
To use the pipeline:

git clone https://github.com/mdelcorvo/TOSCA.git
#edit config
cd Genetic_annotation_challenge && snakemake --use-conda -n 4
```
