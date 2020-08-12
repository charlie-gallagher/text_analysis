#' Gutenberg texts properly formatted
#'
#' Get a book's text from Project Gutenberg via \code{gutenbergr}. The formatting
#' is fixed, so that it returns sentences rather than lines.
#'
#' This is the details section, supposedly. It may have its own sections.
#'
#' @section Warning:
#' Do not operate heavy machinery within 8 hours of using this function.
#'
#' @param code Book code from \code{gutenbergr::gutenberg_metadata}. Numeric.
#'
#' @return A \code{cps_bk}.
#'
#' @seealso \code{\link{guten_search}}, \code{\link{corpus_search_author}},
#' \code{\link{corpus_search_works}}.
#'
#' @export
#' @importFrom magrittr %>%
#'
#' @author Charlie Gallagher


guten_grab <- function(code) {
  if (!is.numeric(code)) stop("Code is not a numeric vector.")

  gutengrab_output <- gutenbergr::gutenberg_download(code)

  if (nrow(gutengrab_output) == 0) return(NULL)

  gutengrab_output <- gutengrab_output %>%
    dplyr::pull(var = 2) %>%
    stringi::stri_c(collapse = " ") %>%
    stringi::stri_split_boundaries(type = "sentence") %>%
    .[[1]] %>%
    tibble::tibble(text = ., gutenberg_id = code) %>%
    dplyr::left_join(y = gutenberg_works(gutenberg_id == code)[,1:4],
                     by = "gutenberg_id")

  cps_bk(gutengrab_output)
}

