library(corpusr)
library(tidyverse)

load('data/authors.RData')
list_of_works <- gutenbergr::gutenberg_works(author %in% authors) %>%
  pull(var = 1)

corpus_guten <- corpus_build_works(list_of_works)

save(corpus_guten, file = "data/corpus_guten.RData")


# examples ----------
load('data/corpus_guten.RData')
corpus_search(corpus_guten, "couched")
corpus_search(corpus_guten, "akimbo")
corpus_search(corpus_guten, "foment(ed|s|ing)?")
corpus_search(corpus_guten, "diurnal")
corpus_search(corpus_guten, "vertiginous")
corpus_search(corpus_guten, "logy")
corpus_search(corpus_guten, "lucubrat(es|ed|ion|e)")
corpus_search(corpus_guten, "derring-do")
corpus_search(corpus_guten, "capacious")
corpus_search(corpus_guten, "detritus")
corpus_search(corpus_guten, "fictile")
corpus_search(corpus_guten, "mien")
