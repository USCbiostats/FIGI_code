#!/bin/bash
#SBATCH --time=23:00:00
#SBATCH --ntasks=1
#SBATCH --mem=8GB
#SBATCH --account=lc_dvc
#SBATCH --partition=conti

OUT=/auto/pmd-02/figi/PCA
cd ${OUT}

# merge kgp chromosomes 1-22
#for j in {1..22}; do echo ${OUT}/files/kgp_backbone_chr$j; done > ${OUT}/mergelist_kgp.txt
#plink --merge-list ${OUT}/mergelist_kgp.txt --make-bed --out ${OUT}/TMP1


# convert rsids to chr:bp (is this good idea? I think it should be fine?)
# recall this file is created in the SNP_Sample_30K.R file
awk '{print $14, $1}' hrc_kgp_innerjoin_rsid.txt > update_ids_rs_to_chrbp.txt 
plink --bfile TMP1 --memory 16000 --update-name update_ids_rs_to_chrbp.txt --make-bed --out ${OUT}/files/kgp_backbone

