#' Search a set of gutenberg works for a word.
#'
#' Calls \code{guten_grab} iteratively, then returns sentences containing the
#' specified word.
#'
#' @param word_ids Numeric vector of book IDs
#' from \code{gutenbergr::gutenberg_metadata}.
#'
#' @param word Word of interest. Character.
#'
#' @return A \code{cps_corpus} object.
#'
#' @export
#' @importFrom magrittr %>%
#'
#' @author Charlie Gallagher


guten_search_works <- function(work_ids, word) {
  if (!is.numeric(work_ids)) stop("Work_ids is not a numeric vector")
  if (!is.character(word)) stop("Word is not a character vector")

  corpus_output <- lapply(work_ids, function(x) guten_search(x, word)) %>%
    cps_corpus()

  match_len <- vapply(X = corpus_output,
                    FUN = function(x) length(x$text)>0,
                    FUN.VALUE = vector('logical', length = 1))

  corpus_output <- corpus_output[match_len]

  corpus_output
}

