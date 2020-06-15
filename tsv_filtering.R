library(dplyr)

args = commandArgs(trailingOnly = TRUE)
input = args[1]
output = args[2]

snps = read.delim(input,
                  stringsAsFactors = FALSE,
                  header = TRUE,
                  sep = '\t')
# Remove columns with all NA
not_any_na = function(x) all(!is.na(x))
snps = select_if(snps, not_any_na)
# Gifu is either 0/0 or 0/1
snps = snps[snps$X.6.results.sorted_Gifu_R.bam.GT %in% c('0/0', '0/1'), ]
# MQ >= 40
snps = snps[snps$X.5.MQ >= 40, ]
# DP >= 200
snps = snps[snps$X.4.DP >= 200, ]
# Missing < 50%
missing = apply(snps[, 6:166], 1, function(x) sum(x == './.'))
snps = snps[missing <= 81, ]
# Must be biallelic
biallelic = apply(snps[, 6:166], 1, function(x) names(table(x)))
biallelic = unlist(biallelic)
biallelic = levels(factor(biallelic))
biallelic = biallelic[!(biallelic %in% c('./.', '0/0', '0/1', '1/1'))]
biallelic = (apply(snps, 1, function(x) sum(!(x %in% biallelic))))
snps = snps[biallelic == 166, ]
positions = snps[, 1:2, drop = FALSE]
# Output
write.table(positions, file = output,
            quote = FALSE, sep = '\t',
            row.names = FALSE, col.names = FALSE)

