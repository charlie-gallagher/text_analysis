#' Search a gutenberg author's complete works for a word.
#'
#' Calls \code{guten_grab} iteratively, then returns sentences containing the
#' specified word.
#'
#' @param guten_author Author's name in format given by
#' \code{gutenbergr::gutenberg_metadata}. Character.
#'
#' @param word Word of interest. Character.
#'
#' @return A \code{cps_corpus} object.
#'
#' @export
#' @importFrom magrittr %>%
#'
#' @author Charlie Gallagher


guten_search_author <- function(guten_author, word) {
  if (!is.character(guten_author)) stop("guten_author is not a character vector")
  if (!is.character(word)) stop("Word is not a character vector")

  work_ids <- gutenbergr::gutenberg_works(author == guten_author) %>%
    dplyr::pull(var = 1)

  corpus_output <- lapply(work_ids, function(x) guten_search(x, word)) %>%
    cps_corpus()

  match_l <- vapply(X = corpus_output,
                    FUN = function(x) length(x$text)>0,
                    FUN.VALUE = vector('logical', length = 1))

  corpus_output <- corpus_output[match_l]

  corpus_output
}


