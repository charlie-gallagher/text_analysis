library(tidyverse)
library(rvest)
library(stringi)
library(gutenbergr)

load('data/corpus.RData')

# A better corpus -----------

guten_grab <- function(code) {
  if (!is.numeric(code)) stop("Code is not a numeric vector.")
  
  gutengrab_output <- gutenbergr::gutenberg_download(code)
  
  if (nrow(gutengrab_output) == 0) return(NULL)
  
  gutengrab_output <- gutengrab_output %>%
    dplyr::pull(var = 2) %>% 
    stringi::stri_c(collapse = " ") %>%
    stringi::stri_split_boundaries(type = "sentence") %>%
    .[[1]] %>%
    tibble(text = ., gutenberg_id = code) %>%
    left_join(y = gutenberg_works(gutenberg_id == code)[,1:4])
  
  gutengrab_output
}


guten_search <- function(code, word) {
  if (!is.numeric(code)) stop("Code is not a numeric vector")
  if (!is.character(word)) stop("Word is not a character vector")
  
  guten_search_output <- guten_grab(code)
  
  if (is.null(guten_search_output) == TRUE) return(NULL)
  
  filter(guten_search_output, 
         grepl(paste0("\\b",word,"\\b"), text))
}



corpus_search_author <- function(corpus_author, word) {
  if (!is.character(corpus_author)) stop("Corpus_author is not a character vector")
  if (!is.character(word)) stop("Word is not a character vector")
  
  work_ids <- gutenbergr::gutenberg_works(author == corpus_author) %>%
    pull(var = 1)
  
  corpus_output <- purrr::map(work_ids, function(x) guten_search(x, word)) %>%
    bind_rows()
  
  corpus_output
}



corpus_search_works <- function(work_ids, word) {
  if (!is.numeric(work_ids)) stop("Work_ids is not a numeric vector")
  if (!is.character(word)) stop("Word is not a character vector")
  
  corpus_output <- purrr::map(work_ids, function(x) guten_search(x, word)) %>%
    bind_rows()
  
  corpus_output
}

# Examples------------------------
guten_grab(41)
guten_search(41, "deference")
corpus_search_author("Thoreau, Henry David", "aliment")
my_work_ids <- c(205, 9846, 41)
corpus_search_works(my_work_ids, "deference")


# Building a corpus --------------
work_ids <- corpus %>% pull(var = 1)
corpus_texts <- map(work_ids, guten_grab) %>%
  bind_rows()
save(corpus_texts, file = 'data/corpus_texts.RData')




# Searching the corpus ----------
load('data/corpus_texts.RData')
# Different from corpus_search_author and corpus_search_works.
corpus_search <- function(corpus, word) {
  corpus %>%
    filter(grepl(paste0("\\b",word,"\\b"), text))
}

# Example
clover <- corpus_search(corpus_texts, "in clover")
byword <- corpus_search(corpus_texts, "byword")
limn <- corpus_search(corpus_texts, "(limn)((s|ed)?)")
kismet <- corpus_search(corpus_texts, "kismet")




# Further directions for development ----------
# One attractive and practical idea is to create an S3 or S4 object for the
# results of the corpus search. This would ideally be very flexible (allowing
# you to manipulate the strings, perhaps) but at least would have a more 
# attractive print method. Again, I would have to learn print method techniques,
# which I don't know how to do. Something like this though: 

# [[1]]
# "This is the quote that has the word of interest, which takes up only
# as much space as it needs to take up."
#   Title: Book title
#   Author: Book author



# Done: made guten_grab and guten_search compatible with occasional 
# query failures.


install.packages("C:/rpackages/corpusr_0.4.1.zip", repos = NULL)

# post package ---------
library(corpusr)
library(tidyverse)
library(stringi)
library(gutenbergr)

load('data/corpus_guten.RData')

penury <- corpus_search(corpus_texts, "penur(y|ious)")

adumbrate <- corpus_search(corpus_texts, "adumbrates?d?")
aloof <- corpus_search(corpus_texts, "aloof")
bombinate <- corpus_search(corpus_texts, "bombinat(e|ing|ed|s|ion)")
bathos <- corpus_search(corpus_texts, "bathos")
byword <- corpus_search(corpus_texts, "byword")
propitious <- corpus_search(corpus_guten, 'propitious')
dolorous <- corpus_search(corpus_guten, 'dolorous')
mote <- corpus_search(corpus_guten, 'mote')
fosse <- corpus_search(corpus_guten, 'fosse')
viscid <- corpus_search(corpus_guten, 'viscid')
sixes <- corpus_search(corpus_guten, 'at sixes and sevens')
avuncular <- corpus_search(corpus_guten, 'avuncular')
eyrie <- corpus_search(corpus_guten, 'eyrie')
