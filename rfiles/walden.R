library(gutenbergr)
library(tidyverse)
library(tidytext)
library(stringi)

View(gutenberg_metadata)

#' Get a gutenberg book in sentence format
#' 
#' Converts `gutenbergr` format into a format where each string is one sentence.
#' 
#' @param code `Gutenbergr` book code. 
#' @return A character vector. 
#' @author Charlie Gallagher

gutengrab <- function(code) {
  gutengrab_output <- gutenbergr::gutenberg_download(code)
  
  gutengrab_output %>%
    dplyr::pull(var = 2) %>% 
    stringi::stri_c(collapse = " ") %>%
    stringi::stri_split_boundaries(type = "sentence") %>%
    .[[1]]
}

# Example: loop
ja <- vector('list')
for (i in seq_along(author_list)) {
  
  ja[[i]] <- gutengrab(author_list[[i]])
}

# So this loop works. 






#' Search for a word
#' 
#' Returns sentences in which the given word appears. 
#' 
#' @param book Character vector to be searched.
#' @param word A character vector of length one.
#' @return A character vector of sentences in which the requested word appears.
#' @author Charlie Gallagher

gutensearch <- function(book, word) {
  if (!is.character(book)) stop("Book is not a character vector")
  if (!is.character(word)) stop("Word is not a character vector")
  
  book[grepl(paste0("\\b", word, "\\b"), book)]
}

# Examples (1 works, 2 and 3 should throw errors)
gutensearch(output[[1]], "time")
gutensearch(output, "time")
gutensearch(output[[1]], output)





#' Search a Gutenbergr book for a word
#' 
#' Inputs a book code and a word and returns sentences in which that word appears.
#' 
#' @param code `gutenbergr` book code.
#' @param word A character of length one.
#' @return A character vector of sentences in which the requested word appears.
#' @author Charlie Gallagher

corpus_search <- function(code, word) {
  work_sentences <- gutengrab(code)
  
  return_sentences <- gutensearch(work_sentences, word)
  
  return_sentences
}

# Example: searching for aliment
corpus_search(205, "aliment")





#' Search an author for a particular word
#' 
#' Search an author for a particular word, using the functions already defined. 
#' 
#' @param corpus_author Character vector of length one.
#' @param word Character vector of length one.
#' @return A list of the same length as the number of works in the author's
#' gutenberg corpus.
#' @author Charlie Gallagher

corpus_search_author <- function(corpus_author, word) {
  work_list <- gutenbergr::gutenberg_works(author == corpus_author) %>%
    pull(var = 1)
  
  output <- map(work_list, function(x) corpus_search(x, word))
  
  output
}

corpus_search_author("Woolf, Virginia", "time")


#' Search an author for a particular word
#' 
#' Search an author for a particular word, using the functions already defined. 
#' 
#' @param work_list Numeric vector of book/work IDs. 
#' @param word Character vector of length one.
#' @return A list of the same length as the number of works in the author's
#' gutenberg corpus.
#' @author Charlie Gallagher

corpus_search_works <- function(work_list, word) {
  output <- map(work_list, function(x) corpus_search(x, word))
  
  output
}



corpus_search_author("Shakespeare, William", "abhor")









# Getting list of authors ---------------------
library(rvest)
selector <- ".authorName span"
gut_url <- "https://www.goodreads.com/list/show/18755.Project_Gutenberg_Books"
webpage <- read_html(gut_url)
authors <- html_text(html_nodes(webpage,selector))

authors

# Reformatting list -----------------
authors_reform <- stringi::stri_replace_all_regex(
  authors,
  "((?:[\\w.]+ )+)(\\w+)$", # some number of words followed by spaces, followed
                            # by a final word.
  "$2, $1"
) %>%
  stri_replace_all_regex(" $", "")


authors_reform <- unique(authors_reform[!grepl("Unknown|Anonymous", 
                                               authors_reform)])

# Problems: initials ought to be spelled out, Miguel de Cervantes should be 
# written "Cervantes Saavedra, Miguel de". Otherwise looks good. 

authors_final <- read_csv('authors.csv')
authors <- pull(authors_final, var = 1)
corpus <- gutenberg_works(author %in% authors)
save(authors, file = "authors.RData")
save(corpus, file = "corpus.RData")


# Testing corpus ------------
load("corpus.RData")
corpus_codes <- corpus %>% pull(var = 1)
corpus_works <- map(corpus_codes, gutengrab)

# Failed to complete. Tried to do it piecewise but it didn't complete that
# way either. Don't know what's going on. Weird errors. 