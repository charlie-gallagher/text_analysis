#' Search a gutenbergr text for a word
#'
#' Calls \code{guten_grab} and returns sentences containing the specified word.
#'
#' @param code Book code from \code{gutenbergr::gutenberg_metadata}. Numeric.
#' @param word Word of interest. Character.
#'
#' @return A \code{cps_bk}, or NULL if no book is returned from gutenbergr.
#'
#' @export
#'
#' @author Charlie Gallagher


guten_search <- function(code, word) {
  if (!is.numeric(code)) stop("Code is not a numeric vector")
  if (!is.character(word)) stop("Word is not a character vector")

  guten_search_output <- guten_grab(code)

  if (is.null(guten_search_output)) return(NULL)

  guten_text <- guten_search_output$text[grepl(paste0("\\b",word,"\\b"),
                                               guten_search_output$text)]

  guten_search_output$text <- guten_text

  guten_search_output
}


