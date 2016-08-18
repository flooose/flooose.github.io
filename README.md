## Running `jekyll`

    $ bundle exec jekyll serve

## Working with `rmarkdown`

Files that are to be `knit` have to be in the `_knitr` directory and must use
the `Rmd` layout in the `_layouts` directory. Here is a sample `yaml`-front
matter:

    ---
    title: "Comparing Automatic to Manual Transmissions"
    layout: Rmd
    author: Christopher Floess
    output:
      # pdf_document: default
      html_document:
        default: true
        self_contained: false
        keep_md: yes
        mathjax: default
    ---

Once this is done, the following can be used in the R-console to compile `.Rmd`
files

    > setwd("_knitr")
    > source("publish.R")
    > publish("2016-07-23-your-r-research-paper.Rmd")
