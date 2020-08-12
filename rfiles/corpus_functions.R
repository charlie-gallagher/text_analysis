require(tidyverse)
require(rvest)
require(stringi)
require(gutenbergr)


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
  work_df <- gutenbergr::gutenberg_works(author == corpus_author)
  author_titles <- work_df %>% pull(var = 2)
  author_titles <- gsub("( )(\\b[A-Za-z])","\\2", author_titles)
  author_name <- work_df %>% pull(var = 3) %>%
    stringi::stri_extract_all_regex("^[A-Za-z]+(?=,)")
  work_IDs <- work_df %>% pull(var = 1)


  output <- purrr::map(work_IDs, function(x) corpus_search(x, word))
  names(output) <- paste(author_titles,author_name, sep = "_")  
  output
}


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

