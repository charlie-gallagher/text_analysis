#' Corpusr: A Package for Using \code{gutenbergr} as a Corpus
#'
#' Functions for helping you use the \code{gutenbergr} package as a corpus
#' in the style of the Oxford English Corpus: a collection of sentences
#' in which you can search for words you would like to see in context. This
#' package also contains a few objects for making work with large corpuses
#' faster and easier. These are \code{cps_bk} and \code{cps_corpus}. A
#' \code{cps_corpus} is simply a list of \code{cps_book}s.
#'
#' @section Interactive use:
#' You can use \code{corpusr} interactively with the functions
#' \code{guten_search_author} and \code{guten_search_works}. These are best
#' used in combination with information gleaned from
#' \code{View(gutenbergr::gutenberg_metadata)}.
#'
#' @section Corpus use:
#' You can also use \code{guten_grab} to build your own corpus by supplying
#' a vector of works to be included. The package \code{gutenbergr} has several
#' functions for helping to gather such lists of works. In addition,
#' I've included several functions for building a corpus for a certain author
#' or for a list of works. These are \code{corpus_build_author} and
#' \code{corpus_build_works}. With your corpus compiled, you can search it
#' with \code{corpus_search}.
#'
#' @docType package
#' @name corpusr
NULL
