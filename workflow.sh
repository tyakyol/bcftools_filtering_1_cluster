# First filtering: MAF should be higher than 0.05.
vcftools --vcf '../../InRoot/variant_calling_7/results/20200531_raw_variants.vcf' \
--maf 0.05 \
--recode \
--recode-INFO-all \
--out results/maf_filtered

# Convert the MAF filtered vcf file to tabular form for further filtering
bcftools query -H \
-f '%CHROM\t%POS\t%QUAL\t%DP\t%MQ[\t%GT\t]\n' \
results/maf_filtered.recode.vcf > results/maf_filtered_calls.tsv

# Second filtering: generating positions.tsv
# MQ should be higher than 40
# DP should be higher than 200
# Only biallelic
# No more than 50% missing data
# Gifu can't be alternative homozygous
Rscript tsv_filtering.R results/maf_filtered_calls.tsv results/positions.tsv

# Second filtering: applying positions.tsv on the vcf file
vcftools --vcf results/maf_filtered.recode.vcf \
--positions results/positions.tsv \
--recode \
--recode-INFO-all \
--out results/final_filtered

# vcf file for INDELs only (necessary for the histograms)
vcftools --vcf results/final_filtered.recode.vcf \
--keep-only-indels \
--recode \
--recode-INFO-all \
--out results/final_filtered_INDELs

# vcf file for SNPs only (necessary for the histograms)
vcftools --vcf results/final_filtered.recode.vcf \
--remove-indels \
--recode \
--recode-INFO-all \
--out results/final_filtered_SNPs

# Convert the vcf file (only INDELs) to tabular form for historgrams
bcftools query -H \
-f '%CHROM\t%POS\t%QUAL\t%IDV\t%IMF\t%DP\t%VDB\t%SGB\t%MQ0F\t%ICB\t%HOB\t%AC\t%AN\t%DP4\t%MQ[\t%GT\t]\n' \
results/final_filtered_INDELs.recode.vcf > results/final_filtered_INDELs.tsv

# Extracting IDV and IMF from the vcf file (only INDELs)
bcftools query -H \
-f '%IDV\t%IMF\t\n' \
results/final_filtered_INDELs.recode.vcf > results/final_filtered_INDELs_additional.tsv

# Convert the vcf file (only SNPs) to tabular form for histograms
bcftools query -H \
-f '%CHROM\t%POS\t%QUAL\t%DP\t%VDB\t%SGB\t%RPB\t%MQB\t%MQSB\t%BQB\t%MQ0F\t%ICB\t%HOB\t%AC\t%AN\t%DP4\t%MQ[\t%GT\t]\n' \
results/final_filtered_SNPs.recode.vcf > results/final_filtered_SNPs.tsv

# Histograms for filtered INDELs
Rscript INDEL_histograms.R results/final_filtered_INDELs.tsv results/final_filtered_INDELs_additional.tsv results/INDEL_hist.pdf

# Histograms for filtered SNPs
Rscript SNP_histograms.R results/final_filtered_SNPs.tsv results/SNP_hist.pdf 
