publish <- function(file) {
  library(knitr)

  year <- substr(file, 1, 4)
  month <- substr(file, 6, 7)
  day <- substr(file, 9, 10)

  # output directory for assets
  outputDir <- paste("..", year, month, day, sep="/")
  dir.create(outputDir, recursive = T)

  # output filenames
  fileWithoutExtension = strsplit(file, '\\.')[[1]][1]
  mdFile = paste(fileWithoutExtension, '.md', sep = "")

  # create markdown file and assets
  knit(file)

  figure <- "figure"
  # remove existing ../${year}/${month}/${day} so that file.rename can work
  unlink(paste(outputDir, figure, sep = "/"), force=T, recursive=T)
  # move assets to ../${year}/${month}/${day}
  file.rename(figure, paste(outputDir, figure, sep = "/"))

  # move generated markdown file to ../_posts so that jekyll can do his thing
  file.rename(mdFile, paste("../_posts", mdFile, sep = "/"))
}
