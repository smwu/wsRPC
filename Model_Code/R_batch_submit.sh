#!/bin/bash
#SBATCH -J Rcpp_SOLCA_scen11111_        # Job name for the array
#SBATCH -o Rcpp_SOLCA_scen11111_%A.out  # Shared standard output with job ID
#SBATCH -e Rcpp_SOLCA_scen11111_%A.err  # Shared standard error with job ID
#SBATCH -p shared      # Partition to submit to
#SBATCH -n 1	       # Number of cores
#SBATCH -t 0-6:00:00  # Runtime (D-HH:MM:SS)
#SBATCH --mem=5000     # Memory request
#SBATCH --mail-type=BEGIN,END,FAIL  # Mail notifications
#SBATCH --mail-user=stephaniewu@fas.harvard.edu  # Account to email

module load R/4.1.0-fasrc01 gcc/10.2.0-fasrc01
export R_LIBS_USER=$HOME/apps/R_4.1.0:$R_LIBS_USER
scen_samp=11111
iter_pop=1
Rscript /n/holyscratch01/stephenson_lab/Users/stephwu18/wsOFMM/Model_Code/SOLCA_main_Rcpp.R ${scen_samp} ${iter_pop} ${SLURM_ARRAY_TASK_ID}
