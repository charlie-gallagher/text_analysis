% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/corpus_search.R
\name{corpus_search}
\alias{corpus_search}
\title{Search a \code{cps_corpus} for a word}
\usage{
corpus_search(cps_corpus, word)
}
\arguments{
\item{word}{Word of interest. Character.}

\item{corpus}{A \code{cps_bk} or \code{cps_corpus} object.}
}
\value{
A \code{cps_corpus}.
}
\description{
Searches a corpus in the format typical of this package.
}
\details{
Designed to work well with the output from \code{guten_grab}.
}
\author{
Charlie Gallagher
}
