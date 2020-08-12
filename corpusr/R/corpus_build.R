#' Build a corpus
#'
#' Construct a corpus from either a list of works or an author.
#'
#' @param works A numeric vector. See \code{gutenbergr::gutenberg_metadata}
#' for more information.
#'
#' @return A \code{cps_corpus} object.
#'
#' @export
#' @importFrom magrittr %>%
#'
#' @author Charlie Gallagher

corpus_build_works <- function(works) {
  output <- lapply(works, guten_grab)

  output <- purrr::compact(output)

  cps_corpus(output)
}


#' Build a corpus
#'
#' Construct a corpus from either a list of works or an author.
#'
#' @param guten_author A character vector, the author of interest. See
#' \code{gutenbergr::gutenberg_metadata} for more information.
#'
#' @return A \code{cps_corpus} object.
#'
#' @export
#' @importFrom magrittr %>%
#'
#' @author Charlie Gallagher

corpus_build_author <- function(guten_author) {
  work_ids <- gutenbergr::gutenberg_works(author == guten_author) %>%
    dplyr::pull(var = 1)

  output <- lapply(work_ids, guten_grab)
  output <- purrr::compact(output)

  cps_corpus(output)
}


