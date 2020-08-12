#' Search a \code{cps_corpus} for a word
#'
#' Searches a corpus in the format typical of this package.
#'
#' @param corpus A \code{cps_bk} or \code{cps_corpus} object.
#' @param word Word of interest. Character.
#'
#' @details Designed to work well with the output from \code{guten_grab}.
#'
#' @return A \code{cps_corpus}.
#'
#' @export
#'
#' @author Charlie Gallagher

corpus_search <- function(cps_corpus, word) {
  if (!(class(cps_corpus) %in% c("cps_corpus"))) stop("Corpus must be a cps_corpus object.")

  corpus_output <- lapply(cps_corpus, function(x) {
  x$text <- x$text[grep(paste0("\\b",word,"\\b"), x$text)]
  x
  })

  match_len <- vapply(X = corpus_output,
                      FUN = function(x) length(x$text)>0,
                      FUN.VALUE = vector('logical', length = 1))

  corpus_output <- corpus_output[match_len]

  corpus_output
}




#' Search a \code{cps_bk}
#'
#' Search a \code{cps_bk} for instances of a word.
#'
#' @param cps_bk A \code{cps_bk} object.
#' @param word A character vector of length 1.
#'
#' @export
#' @author Charlie Gallagher


cps_bk_search <- function(cps_bk, word) {
  bk_class <- class(cps_bk)
  if (!bk_class=="cps_bk") stop("cps_bk must be a cps_bk object.")

  match_text <- cps_bk$text[grep(paste0("\\b", word, "\\b"), cps_bk$text)]

  cps_bk$text <- match_text
  cps_bk
}
