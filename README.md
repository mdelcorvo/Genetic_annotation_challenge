# Genetic annotation challenge


## Goal of the challenge

1. Create an interactive dashboard (i.e with Shiny, interactive notebook or web framework ) that allows you to select the file provided as an example and show the results of the analysis described below.
2. Create a Nextlfow/CWL/WDL pipeline that processes input data and generates all output results required by 1. to visualize the results.

Input file is a tab separated file containing genotyping information of an individual:

[Example genome file](https://gist.githubusercontent.com/pprieto/f3f75aed72e5b7f28728dbca03e6edde/raw/242e42954475f2876c2b425c901fdfa818089b33/example_genome.txt)

This file contains information about the genotype at 638,488 positions in an individual’s genome. This kind of files are for 
example produced by the 23andMe genotyping analysis including the accession number of SNPs, its location information (chromosome, position), and the 
corresponding genotype.

Given this file with genotyping information the tasks are:

- Imputation 
- SNP effects

## Imputation
The genotyping information you are provided with, as mentioned before, only partially covers the genome and is therefore 
incomplete. In fact, many genetic markers are not included as probes into genotyping arrays and eventually less than 
1M position in the genome are covered.  
Due to the success of genomic population studies across several hundreds of human genomes, we know how much genetic 
information tends to be shared within the same population. We can use that information up to certain degree of confidence to 
amplify the genetic markers from a dataset. This process, called imputation, can use information from projects such as HapMap 
or 1000Genomes to make predictions on genotypes not included in genotyping arrays.

1. How many new SNPs can be confidently obtained through imputation? 

## SNP effects
Genetic variations in human genomes, especially the very common single nucleotide polymorphisms (SNPs), are correlated with
many diseases, associated with individuality and relevant to many other fields, such as nutrition. In order to be able to 
accurately identify strong associations between genetic markers and its phenotypes, Genome Wide Association Studies are 
conducted. Those, however, do not always conclude reliably the strength of the effect, and sometimes the confidence is not 
high enough. Reference catalogs such as dbSNP, Clinvar and Exac among others, try to annotate all information relevant to the 
variants and its associated phenotype. Typically all those variants tend to be related to certain publications where some GWAS 
and other analysis have been carried out to corroborate associations.

2. Find out from the example dataset, as well as on the imputed genotypes from task 1 what genetic markers can 
be associated to conditions that affect Nutrition such as vitamins, minerals, antioxidants, carbohydrates and lipids. For the 
ones you can find interesting effects, we would like you to provide:  overall effect, information about the confidence of 
the association, clinical information, scientific publications related to the studies carried out to prove the association, 
population related information  and dietary recommendations.

3. Finally present the information in a dashboard that allows to inspect all of the information found 
between markers and condition.
(An example of a dashboard displaying genetic annotation of an individual can be found here: https://files.snpedia.com/reports/promethease_data/genome_Lilly_Mendel_v4_ui2.html)


## Results

1. Create an interactive dashboard:

https://mdelcorvo.shinyapps.io/bioinfo_challenge/

2. Create a Nextlfow/CWL/WDL pipeline

## Using the Snakemake workflow

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
and put them in resources\ReferencePanel directory (or change the default directory in config file)

5. Download Clinvar, Cosmic and GWAS database from the following link:
Cosmic: "http://ftp.ensembl.org/pub/grch37/current/variation/vcf/homo_sapiens/homo_sapiens_somatic.vcf.gz"
ClinVar: "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh37/clinvar.vcf.gz"
GWAS: "https://www.ebi.ac.uk/gwas/api/search/downloads/full"
and put them in resources\database directory (or change the default directory in config file)

6.Edit config file by setting correct paths

7. cd Genetic_annotation_challenge && snakemake --use-conda -n 4
```
