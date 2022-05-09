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
To use this tool, you will need to do the following steps:

1. git clone https://github.com/mdelcorvo/Genetic_annotation_challenge.git

2. Download your ‘raw data’ from the 23andme site and put it in data directory

3. Download the 1000 Genomes reference data, which can be found on the impute2 website here:
https://mathgen.stats.ox.ac.uk/impute/data_download_1000G_phase1_integrated.html

4.Extract this data by running:
gunzip ALL_1000G_phase1integrated_v3_impute.tgz
tar xf ALL_1000G_phase1integrated_v3_impute.tar

#edit config

cd Genetic_annotation_challenge && snakemake --use-conda -n 4
```
