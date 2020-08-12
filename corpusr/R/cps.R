#' Build a \code{cps_bk} object
#'
#' Constructor function.
#'
#' @param x Data frame to be converted to \code{cps_bk}.
#' @param text Name of the column which contains the text.
#' @param author Name of the column with contains the author's name.
#' @param title Name of the column which contains the title.
#'
#' @return A \code{cps_bk}.
#'
#' @export
#'
#' @author Charlie Gallagher

cps_bk <- function(x, text = "text", author = "author", title = "title") {
  cps_bk_output <- list(
    text = x[[text]],
    author = unique(x[[author]]),
    title = unique(x[[title]])
  )

  n_bk <- length(cps_bk_output$title)
  n_au <- length(cps_bk_output$author)

  if (!(n_bk == 1 && n_au == 1)) stop("More than one title or author detected. Cps_bk objects must only contain one title.")

  class(cps_bk_output) <- "cps_bk"

  cps_bk_output
}


#' Print a \code{cps_bk}
#'
#' A print method for \code{cps_bk} objects.
#'
#' @param x a \code{cps_bk} object
#' @param ... Further arguments. In this case, not used.
#' @param n_sentences Number of lines to print.
#'
#' @export
#'
#' @author Charlie Gallagher

print.cps_bk <- function(x, ..., n_sentences = 10) {
  author <- x$author
  title <- x$title
  len_x <- length(x$text)
  len_rest <- len_x - n_sentences

  if (len_x < n_sentences) output_bk <- x$text
  if (len_x >= n_sentences) output_bk <- x$text[seq_len(n_sentences)]

  cat(crayon::cyan(crayon::bold("\nAuthor: ", author, "\n")))
  cat(crayon::cyan(crayon::bold("Title: ", title, "\n\n")))
  # print(output_bk, quote = FALSE, max = n_sentences)

  for (i in seq_along(output_bk)) {
    cat(paste0(as.character(i), ". "))
    cat(paste0(output_bk[[i]], "\n\n"))
    }

  if (len_x > n_sentences) {
  cat(paste0("\nNOTE: Only showing the first ", n_sentences, " sentences. Omitted ", len_rest, " sentences."))
  }
  cat("\n-----------------------------------------------------\n")
}


#' Print a \code{cps_corpus}
#'
#' A print method for \code{cps_corpus} objects.
#'
#' @param x a \code{cps_corpus} object
#' @param ... Further arguments. In this case, not used.
#'
#' @export
#'
#' @author Charlie Gallagher
print.cps_corpus <- function(x, ...) {
  for (i in seq_along(x)) {
    print(x[[i]])
  }
}



#' Build a \code{cps_corpus} object
#'
#' Constructor function for building a \code{cps_corpus} object from a list
#' of \code{cps_bk} objects. This is the main unit of analysis in the rest
#' of the package, and even single books are better kept in a \code{cps_corpus}
#' rather than a \code{cps_bk} for analytical purposes.
#'
#' @param cps_bk_list A list of \code{cps_bk} objects.
#'
#' @return A \code{cps_corpus}.
#'
#' @export
#'
#' @author Charlie Gallagher

cps_corpus <- function(cps_bk_list) {
  cps_bk_check <- vapply(cps_bk_list, class, vector('character', length = 1))

  if (!all(cps_bk_check == "cps_bk")) stop("A cps_corpus must be composed of objects with the class cps_bk.")
  if (!is.list(cps_bk_list)) stop("A cps_corpus must be in the form of a list")

  class(cps_bk_list) <- "cps_corpus"
  cps_bk_list
}




