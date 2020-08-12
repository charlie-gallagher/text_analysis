library(corpusr)
library(tidyverse)

# Building the corpus -----------
load('data/authors.RData') # Built-in list of 65 authors
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
corpus_search(corpus_texts, "penur(y|ious)")
corpus_search(corpus_texts, "adumbrates?d?")
corpus_search(corpus_texts, "aloof")
corpus_search(corpus_texts, "bombinat(e|ing|ed|s|ion)")
corpus_search(corpus_texts, "bathos")
corpus_search(corpus_texts, "byword")
corpus_search(corpus_guten, 'propitious')
corpus_search(corpus_guten, 'dolorous')
corpus_search(corpus_guten, 'mote')
corpus_search(corpus_guten, 'fosse')
corpus_search(corpus_guten, 'viscid')
corpus_search(corpus_guten, 'at sixes and sevens')
corpus_search(corpus_guten, 'avuncular')
corpus_search(corpus_guten, 'eyrie')

# Interactive usage
guten_search_author("Lincoln, Abraham", "score") # Was Lincoln in the habit of using 'score'?
guten_search_works(6, "liberty") # work 6 is "Give Me Liberty or Give Me Death"