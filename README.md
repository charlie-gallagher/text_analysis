# Text Analysis
This package, called `corpusr`, is a simple, single-purpose package for querying any corpus for sentences containing a word of interest.

In fact, this repo currently only contains some working files I have, not the actual package. Let me fix that.

Fixed.

# Structure
Ideally, the structure would be to have the repository in two parts. In the first part, you have the package `corpusr`, which doesn't do much on its own except provide the super-structure for the text analysis project. Then, you use the `text_analysis.Rproj` project to do most of the heavy lifting: Scraping names of authors, building a corpus, querying that corpus, etc. Together, they should form a complete unit, neither functioning well without the other.

This presents a challenge, however, because I have to work also with my other account to properly compile the package. I can install fine, but installing form source fails on this account thanks to Windows' shitty personalization. Anyway, I won't set up a remote for that, although I could and it would be interesting... Ok, let me try setting up a remote to the same github repository. 
