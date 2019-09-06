#!/bin/bash
#SBATCH --time=300:00:00
#SBATCH --ntasks=1
#SBATCH --mem=8GB
#SBATCH --account=lc_dvc
#SBATCH --partition=conti
#SBATCH --constraint=IB
#SBATCH --mail-user=andreeki@usc.edu
#SBATCH --mail-type=END
#SBATCH --array=1-2
#SBATCH --output=/staging/dvc/andreeki/GxE/logs/GxEScanR_folate_dietqc2_sex_age_pc3_energytot_studygxe_colon_47176_binCovF_chr%a.log

Rscript job01.R ${SLURM_ARRAY_TASK_ID} /staging/dvc/andreeki/GxE/folate_dietqc2_colon/FIGI_GxESet_folate_dietqc2_sex_age_pc3_energytot_studygxe_colon_47176
