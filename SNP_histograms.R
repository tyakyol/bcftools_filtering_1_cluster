library(dplyr)

args = commandArgs(trailingOnly = TRUE)
input = args[1]
output = args[2]

snps = read.delim(input,
                  stringsAsFactors = FALSE,
                  header = TRUE,
                  sep = '\t')
not_any_na = function(x) all(!is.na(x))
snps = select_if(snps, not_any_na)

pdf(output)
for(i in c(3, 4, 6, 11, 15, 17)) {
  if(i %in% c(3, 4)) {
      hist(x = log10((snps[, i])), col = 'gold', breaks = 200,
       xlim = c(min(log10(as.numeric(snps[, i]))), max(log10(as.numeric(snps[, i])))),
       main = colnames(snps)[i])
  } else {
  hist(x = as.numeric(snps[, i]), col = 'gold', breaks = 200,
       xlim = c(min(as.numeric(snps[, i])), max(as.numeric(snps[, i]))),
       main = colnames(snps)[i])
  }
}
dev.off()
