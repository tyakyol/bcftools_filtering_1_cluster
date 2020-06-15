library(dplyr)

args = commandArgs(trailingOnly = TRUE)
input1 = args[1]
input2 = args[2]
output = args[3]

indels = read.delim(input1,
                    stringsAsFactors = FALSE,
                    header = TRUE,
                    sep = '\t')
not_any_na = function(x) all(!is.na(x))
indels = select_if(indels, not_any_na)
addition = read.delim(input2,
                      stringsAsFactors = FALSE,
                      header = TRUE,
                      sep = '\t')
addition = select_if(addition, not_any_na)
indels = cbind(indels, addition)

pdf(output)
for(i in c(3, 6, 8, 9, 13, 15, 177, 178)) {
  if(i %in% c(3, 6)) {
      hist(x = log10((indels[, i])), col = 'gold', breaks = 200,
       xlim = c(min(log10(as.numeric(indels[, i]))), max(log10(as.numeric(indels[, i])))),
       main = colnames(indels)[i])
  } else {
  hist(x = as.numeric(indels[, i]), col = 'gold', breaks = 200,
       xlim = c(min(as.numeric(indels[, i])), max(as.numeric(indels[, i]))),
       main = colnames(indels)[i])
  }
}
dev.off()
