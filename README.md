corpusr
================
Charlie Gallagher
11/24/2020

  - [Quickstart](#quickstart)
      - [Querying a Work](#querying-a-work)
      - [Querying Multiple Works](#querying-multiple-works)
      - [Querying an Author’s Works](#querying-an-authors-works)
      - [Building a Corpus](#building-a-corpus)
  - [The `corpusr` Package](#the-corpusr-package)
      - [Motivation](#motivation)
      - [Implementation](#implementation)
  - [History and Purpose](#history-and-purpose)

This package, called `corpusr`, is a simple, very high-level package for
querying books from `gutenbergr` for sentences containing certain words
or regular expressions.

# Quickstart

Before starting, you should have both `corpusr` and `gutenbergr`
installed. When `corpusr` is loaded, so is `gutenbergr`.

``` r
library(tidyverse)
```

    ## -- Attaching packages --------------------------------------- tidyverse 1.3.0 --

    ## v ggplot2 3.3.2     v purrr   0.3.4
    ## v tibble  3.0.4     v dplyr   1.0.2
    ## v tidyr   1.1.2     v stringr 1.4.0
    ## v readr   1.4.0     v forcats 0.5.0

    ## Warning: package 'tibble' was built under R version 4.0.3

    ## Warning: package 'readr' was built under R version 4.0.3

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(corpusr)
```

    ## Loading required package: gutenbergr

    ## Warning: package 'gutenbergr' was built under R version 4.0.3

### Querying a Work

The simplest search you can do is a single work. For this, use
`corpusr::guten_search()`, which takes the arguments “code” and “word”.
The code is a number that comes from `gutenbergr::gutenberg_works()`,
which is a dataset containing an observation for every work in Project
Gutenberg. Search this for the work you want to analyze and get its
`gutenberg_id`. For example, here is how to search the US Constitution
for the word “Enumeration.”

``` r
gutenbergr::gutenberg_works(title == "The United States Constitution") %>% 
  pull(gutenberg_id) %>% 
  guten_search("Enumeration")
```

    ## Determining mirror for Project Gutenberg from http://www.gutenberg.org/robot/harvest

    ## Using mirror http://aleph.gutenberg.org

    ## 
    ## Author:  United States 
    ## Title:  The United States Constitution 
    ## 
    ## 1. The actual Enumeration shall be made within three Years after the first Meeting of the Congress of the United States, and within every subsequent Term of ten Years, in such Manner as they shall by law Direct.  
    ## 
    ## 2. No Capitation, or other direct, Tax shall be laid, unless in Proportion to the Census or Enumeration herein before directed to be taken.  
    ## 
    ## 
    ## -----------------------------------------------------

The search tools are written with regular expressions built in, so you
can search for several word forms at once, sentences, or common
collocations. The regular expression is automatically book-ended by word
separators, so ‘the’ will never match ‘there’, for example.

``` r
gutenbergr::gutenberg_works(title == "The United States Constitution") %>% 
  pull(gutenberg_id) %>% 
  guten_search("House of Representatives")
```

    ## 
    ## Author:  United States 
    ## Title:  The United States Constitution 
    ## 
    ## 1. All legislative Powers herein granted shall be vested in a Congress of the United States, which shall consist of a Senate and House of Representatives.  
    ## 
    ## 2. The House of Representatives shall be composed of Members chosen every second Year by the People of the several States, and the electors in each State shall have the qualifications requisite for electors of the most numerous branch of the State legislature.  
    ## 
    ## 3. The House of Representatives shall chuse their Speaker and other Officers; and shall have the sole Power of Impeachment.  
    ## 
    ## 4. All Bills for raising Revenue shall originate in the House of Representatives; but the Senate may propose or concur with Amendments as on other Bills.  
    ## 
    ## 5. Every Bill which shall have passed the House of Representatives and the Senate, shall, before it become a Law, be presented to the President of the United States; If he approve he shall sign it, but if not he shall return it, with his Objections to that House in which it shall have originated, who shall enter the Objections at large on their Journal, and proceed to reconsider it. 
    ## 
    ## 6. Every Order, Resolution, or Vote to which the Concurrence of the Senate and House of Representatives may be necessary (except on a question of Adjournment) shall be presented to the President of the United States; and before the Same shall take Effect, shall be approved by him, or being disapproved by him, shall be repassed by two thirds of the Senate and House of Representatives, according to the Rules and Limitations prescribed in the Case of a Bill.  
    ## 
    ## 7. The President of the Senate shall, in the Presence of the Senate and House of Representatives, open all the Certificates, and the Votes shall then be counted. 
    ## 
    ## 8. The Person having the greatest Number of Votes shall be the President, if such Number be a Majority of the whole Number of Electors appointed; and if there be more than one who have such Majority, and have an equal Number of votes, then the House of Representatives shall immediately chuse by Ballot one of them for President; and if no Person have a Majority, then from the five highest on the List the said House shall in like Manner chuse the President.  
    ## 
    ## 
    ## -----------------------------------------------------

When more than 10 sentences are returned for a single work, the output
is truncated.

``` r
gutenbergr::gutenberg_works(title == "The United States Constitution") %>% 
  pull(gutenberg_id) %>% 
  guten_search("the")
```

    ## 
    ## Author:  United States 
    ## Title:  The United States Constitution 
    ## 
    ## 1. ***  These original Project Gutenberg Etexts will be compiled into a file containing them all, in order to improve the content ratios of Etext to header material.  
    ## 
    ## 2. ***    The following edition of The Consitution of the United States of America has been based on many hours of study of a variety of editions, and will include certain variant spellings, punctuation, and captialization as we have been able to reasonable ascertain belonged to the orginal.  
    ## 
    ## 3. In our orginal editions the letters were all CAPITALS, and we did not do anything about capitalization, consistent or otherwise, nor with most of the punctuation, since we had limited punctionation in those days.  
    ## 
    ## 4. This document does NOT include the amendments, as the Bill of Rights was one of our earlier Project Gutenberg Etexts, and the others will be sent in a separate posting.  
    ## 
    ## 5. ***     THE CONSTITUTION OF THE UNITED STATES OF AMERICA, 1787    We the people of the United States, in Order to form a more perfect Union, establish Justice, insure domestic Tranquility, provide for the common defence, promote the general Welfare, and secure the Blessings of Liberty to ourselves and our Posterity, do ordain and establish this Constitution for the United States of America.   
    ## 
    ## 6. All legislative Powers herein granted shall be vested in a Congress of the United States, which shall consist of a Senate and House of Representatives.  
    ## 
    ## 7. The House of Representatives shall be composed of Members chosen every second Year by the People of the several States, and the electors in each State shall have the qualifications requisite for electors of the most numerous branch of the State legislature.  
    ## 
    ## 8. No Person shall be a Representative who shall not have attained to the Age of twenty five Years, and been seven Years a citizen of the United States, and who shall not, when elected, be an Inhabitant of that State in which he shall be chosen.  
    ## 
    ## 9. Representatives and direct Taxes shall be apportioned among the several States which may be included within this Union, according to their respective Numbers, which shall be determined by adding to the whole number of free Persons, including those bound to Service for a Term of Years, and excluding Indians not taxed, three fifths of all other Persons.  
    ## 
    ## 10. The actual Enumeration shall be made within three Years after the first Meeting of the Congress of the United States, and within every subsequent Term of ten Years, in such Manner as they shall by law Direct.  
    ## 
    ## 
    ## NOTE: Only showing the first 10 sentences. Omitted 78 sentences.
    ## -----------------------------------------------------

### Querying Multiple Works

You can search multiple works if you provide a vector of `gutenberg_id`s
with `corpusr::guten_search_works()`. Here, I search for any books with
“Puget Sound” in their title for the words “serene” or “serenely”.

``` r
gutenbergr::gutenberg_works(str_detect(title, "Puget Sound")) %>% 
  pull(gutenberg_id) %>% 
  guten_search_works("serene(ly)?")
```

    ## [[1]]
    ## 
    ## Author:  Leighton, Caroline C. 
    ## Title:  Life at Puget Sound: With Sketches of Travel in Washington Territory, British Columbia, Oregon and California 
    ## 
    ## 1. She sat serenely in the sunshine, hollowing out a little canoe of pine-bark for the youngest, two little girls who swam in the arm of the river before the tent-door.  
    ## 
    ## 2. This was the introduction of the serene sisters to their field of labor. 
    ## 
    ## 3. They seemed to regard it as a kind of goddess; and I felt half inclined to, myself, she looked out so serenely at the water. 
    ## 
    ## 4. How serenely we descended the river last year, floating along at sunset, admiring the lovely valley and the hills, reaching over the side of the canoe, and soaking our biscuits in the glacier-water, without once thinking of the vicissitudes to which we were liable from its mountain origin!  
    ## 
    ## 5. I felt that I fled from the angry sea, and reached, in an instant, serene heights above the storm.  
    ## 
    ## 6. Nothing can be conceived more virginal than this form of exquisite purity rising from the dark fir forests to the serene sky. 
    ## 
    ## 7. We steamed serenely on, over the clear, still water, to Port Madison, and then crossed the inlet to Seattle. 
    ## 
    ## 8. How serenely the water lay in the sunshine, as we looked at it, hearing this news, which had stirred the city to its utmost! 
    ## 
    ## 9. The grave, serene Spanish is the common type; and, since the hoodlum spirit has broken out among the Californians, it has called out a coarse, rough class among the Chinese, corresponding to the lower grades of the Irish. 
    ## 
    ## 10. Then a serene-looking Chinaman chanted something that sounded very soothing and musical, and another made a prayer. 
    ## 
    ## 
    ## NOTE: Only showing the first 10 sentences. Omitted 2 sentences.
    ## -----------------------------------------------------
    ## 
    ## [[2]]
    ## 
    ## Author:  Denny, Emily Inez 
    ## Title:  Blazing the Way; Or, True Stories, Songs and Sketches of Puget Sound 
    ## 
    ## 1. "She will roam no more on the ocean trails,     Where her floating scarf of black was seen     Like a challenge proud to the shrieking gales     By the mighty shores of evergreen;         For she lies at rest         With a pulseless breast     In the rough sea's clasp and all serene.      
    ## 
    ## 2. Some died in childhood, accidents befell others, a part were more fortunate, yet she seemed in old age serene, courageous, undaunted as ever, faithful and true, lovely and beloved.  
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[3]]
    ## 
    ## Author:  Stine, Thomas Ostenson 
    ## Title:  Scandinavians on the Pacific, Puget Sound 
    ## 
    ## 1. Morning steals serenely on us,   Melting in from east to west,     And the diamonds on the water,   Burning, leap from crest to crest.     
    ## 
    ## 2. Mountains hold the treasure tempting,   And the valleys ever green     Teem with blooms of inspiration   By the sun-kissed shore serene.    --Thos. 
    ## 
    ## 3. Not only a home, but a pleasant home in a congenial clime, where the heaven smiles serenely, where the rose-bud bursts and thrives the year round. 
    ## 
    ## 4. Burst ye rose-buds to a fresh-born day,   And drink from heaven's eye serene,           Sweet beams of rainbow tint,           Emblems of God, I weep and wait.    
    ## 
    ## 
    ## -----------------------------------------------------

In fact, five books were returned, but only those containing ‘serene’ or
‘serenely’ are included in the final `cps_corpus` object. (A
`cps_corpus` is a list of `cps_bk` objects. More on the `cps` classes
later, though.)

### Querying an Author’s Works

Commonly, one wants to search all an author’s works for a certain word
or phrase. For this, you can query the `gutenbergr` database as above or
use `corpusr::guten_search_author()`.

``` r
corpusr::guten_search_author("Lincoln, Abraham", "(S|s)cores?")
```

    ## [[1]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  Lincoln's Gettysburg Address
    ## Given November 19, 1863 on the battlefield near Gettysburg, Pennsylvania, USA 
    ## 
    ## 1. Lincoln's Gettysburg Address, given November 19, 1863 on the battlefield near Gettysburg, Pennsylvania, USA   Four score and seven years ago, our fathers brought forth upon this continent a new nation:  conceived in liberty, and dedicated to the proposition that all men are created equal.  
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[2]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  The Papers And Writings Of Abraham Lincoln — Volume 1: 1832-1843 
    ## 
    ## 1. His whole soul was in it:  "Four score and seven years ago our fathers brought forth on this continent a new nation, conceived in liberty and dedicated to the proposition that all men are created equal. 
    ## 
    ## 2. But when he went on to say that five millions of the expenditure of 1838 were payments of the French indemnities, which I knew to be untrue; that five millions had been for the post-office, which I knew to be untrue; that ten millions had been for the Maine boundary war, which I not only knew to be untrue, but supremely ridiculous also; and when I saw that he was stupid enough to hope that I would permit such groundless and audacious assertions to go unexposed,--I readily consented that, on the score both of veracity and sagacity, the audience should judge whether he or I were the more deserving of the world's contempt.  
    ## 
    ## 3. Although they succeeded in defeating the nominees almost by scores, they too were defeated, and the spoils chucklingly borne off by the common enemy.  
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[3]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  The Papers And Writings Of Abraham Lincoln — Volume 2: 1843-1858 
    ## 
    ## 1. The war has gone on some twenty months; for the expenses of which, together with an inconsiderable old score, the President now claims about one half of the Mexican territory, and that by far the better half, so far as concerns our ability to make anything out of it. 
    ## 
    ## 2. Neither the President nor any one can possibly specify an improvement which shall not be clearly liable to one or another of the objections he has urged on the score of expediency. 
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[4]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  The Papers And Writings Of Abraham Lincoln — Volume 4: The Lincoln-Douglas Debates 
    ## 
    ## 1. He insists that upon the score of equality the owners of slaves and owners of property--of horses and every other sort of property--should be alike, and hold them alike in a new Territory. 
    ## 
    ## 2. He says that upon the score of equality slaves should be allowed to go in a new Territory, like other property. 
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[5]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  The Papers And Writings Of Abraham Lincoln — Volume 5: 1858-1862 
    ## 
    ## 1. There are scores of them, good men in their character for intelligence and talent and integrity. 
    ## 
    ## 2. Occasional poisonings from the kitchen, and open or stealthy assassinations in the field, and local revolts, extending to a score or so, will continue to occur as the natural results of slavery; but no general insurrection of slaves, as I think, can happen in this country for a long time. 
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[6]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  The Papers And Writings Of Abraham Lincoln — Volume 7: 1863-1865 
    ## 
    ## 1. Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.  
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[7]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  The Papers And Writings Of Abraham Lincoln, Complete 
    ## 
    ## 1. His whole soul was in it:  "Four score and seven years ago our fathers brought forth on this continent a new nation, conceived in liberty and dedicated to the proposition that all men are created equal. 
    ## 
    ## 2. But when he went on to say that five millions of the expenditure of 1838 were payments of the French indemnities, which I knew to be untrue; that five millions had been for the post-office, which I knew to be untrue; that ten millions had been for the Maine boundary war, which I not only knew to be untrue, but supremely ridiculous also; and when I saw that he was stupid enough to hope that I would permit such groundless and audacious assertions to go unexposed,--I readily consented that, on the score both of veracity and sagacity, the audience should judge whether he or I were the more deserving of the world's contempt.  
    ## 
    ## 3. Although they succeeded in defeating the nominees almost by scores, they too were defeated, and the spoils chucklingly borne off by the common enemy.  
    ## 
    ## 4. The war has gone on some twenty months; for the expenses of which, together with an inconsiderable old score, the President now claims about one half of the Mexican territory, and that by far the better half, so far as concerns our ability to make anything out of it. 
    ## 
    ## 5. Neither the President nor any one can possibly specify an improvement which shall not be clearly liable to one or another of the objections he has urged on the score of expediency. 
    ## 
    ## 6. He insists that upon the score of equality the owners of slaves and owners of property--of horses and every other sort of property--should be alike, and hold them alike in a new Territory. 
    ## 
    ## 7. He says that upon the score of equality slaves should be allowed to go in a new Territory, like other property. 
    ## 
    ## 8. There are scores of them, good men in their character for intelligence and talent and integrity. 
    ## 
    ## 9. Occasional poisonings from the kitchen, and open or stealthy assassinations in the field, and local revolts, extending to a score or so, will continue to occur as the natural results of slavery; but no general insurrection of slaves, as I think, can happen in this country for a long time. 
    ## 
    ## 10. Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.  
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[8]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  Widger's Quotations from the Project Gutenberg Editions of the Works of Abraham Lincoln 
    ## 
    ## 1. Can't Tell Where He Will Come out At Cannot Conciliate the South Cannot Fly from My Thoughts Capture of the City of Atlanta Chew and Choke as Much as Possible Christmas Gift, the Capture of Savannah Chronologic Review of Peace Proposals Colored Colony Constitutional Amendment for the Abolishing of Slavery Deserters Sentences Remitted to Hard Labor Early Consultations with Rebels Emancipation Exemption of  American Consuls from Military Service Female Spy First Overtures for Surrender from Davis Five-star Mother Fort Pillow Massacre Four Score and Seven Years Ago Gettysburg Gratuitous Hostility Greenback Habeas Corpus Harmon's Sandal Sock Hawaiian Islands Indians Irresponsible Newspaper Reporters and Editors Keep Cool Kindness Not Quite Free from Ridicule Labor Last Public Address Lecture on Liberty Letter Accepting the Nomination for President. 
    ## 
    ## 2. Danger of third-parties Declaration of Independence Declaring the African slave trade piracy Direct while appearing to obey Dirge of one who has no title to himself Distinction between a purpose and an expectation Don't think it will do him a bit of good either Dred Scott Dred Scott Early Consultations with Rebels Emancipation Proclamation Emancipation Endeavoring to blow up a storm that he may ride upon Estimated as mere brutes--as rightful property Events control me; I cannot control events Explanations explanatory of explanations explained Familiarize yourselves with the chains of bondage Father's request for money Female Spy First Inaugural Address First Overtures for Surrender from Davis Five-star Mother Forbids the marrying of white people with negroes Forever forbid the two races living together Fort Pillow Massacre Four Score and Seven Years Ago Frankly that I am not in favor of negro citizenship Free all the slaves, and send them to Liberia Fugitive Slave law Further Democratic Party Criticism General Grant is a copious worker General McClellan's Tired Horses General Grant Get along without making either slaves or wives of negroes Gingerbread God gave him but little, that little let him enjoy Government cannot endure permanently half slave and half free Government was made for the white people Grant--very meager writer or telegrapher Grant's Exclusion of a Newspaper Reporter Gratuitous Hostility Greeley Hard to affirm a negative Henry Clay House divided against itself cannot stand I can't spare that man, he fights! 
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[9]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  Quotes and Images From The Writings of Abraham Lincoln 
    ## 
    ## 1. Danger of third-parties  Declaring the African slave trade piracy  Direct while appearing to obey  Dirge of one who has no title to himself  Distinction between a purpose and an expectation  Don't think it will do him a bit of good either  Dred Scott  Endeavoring to blow up a storm that he may ride upon  Estimated as mere brutes--as rightful property  Events control me; I cannot control events  Explanations explanatory of explanations explained  Familiarize yourselves with the chains of bondage  Father's request for money  Female Spy  First Overtures for Surrender from Davis  Five-star Mother  Forbids the marrying of white people with negroes  Forever forbid the two races living together  Fort Pillow Massacre  Four Score and Seven Years Ago  Frankly that I am not in favor of negro citizenship  Free all the slaves, and send them to Liberia  Fugitive Slave law  Further Democratic Party Criticism  General Grant is a copious worker  General McClellan's Tired Horses  Get along without making either slaves or wives of negroes  Gingerbread  God gave him but little, that little let him enjoy  Government cannot endure permanently half slave and half free  Government was made for the white people  Grant--very meager writer or telegrapher  Grant's Exclusion of a Newspaper Reporter  Gratuitous Hostility  Hard to affirm a negative  House divided against itself cannot stand  I can't spare that man, he fights!  
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[10]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  Lincoln's Inaugurals, Addresses and Letters (Selections) 
    ## 
    ## 1. Occasional poisonings from the kitchen, and open or stealthy assassinations in the field, and local revolts extending to a score or so will continue to occur as the natural results of slavery; but no general insurrection of slaves, as I think, can happen in this country for a long time.  
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[11]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  Speeches & Letters of Abraham Lincoln, 1832-1865 
    ## 
    ## 1. He says that, upon the score of equality, slaves should be allowed to go into a new Territory like other property. 
    ## 
    ## 2. There are scores of them--good men in their character for intelligence, for talent and integrity. 
    ## 
    ## 3. Occasional poisonings from the kitchen, and open or stealthy assassinations in the field, and local revolts extending to a score or so, will continue to occur as the natural results of slavery; but no general insurrection of slaves, as I think, can happen in this country for a long time. 
    ## 
    ## 
    ## -----------------------------------------------------
    ## 
    ## [[12]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  Noted Speeches of Abraham Lincoln
    ## Including the Lincoln-Douglas Debate 
    ## 
    ## 1. Occasional poisonings from the kitchen and open or stealthy assassinations in the field, and local revolts extending to a score or so, will continue to occur as the natural results of slavery; but no general insurrections of slaves, as I think, can happen in this country for a long time. 
    ## 
    ## 
    ## -----------------------------------------------------

Twelve works by Abraham Lincoln are returned (with some odd entries
owing to how the sentence parser works with tables of contents and the
like), with all the sentences that contain “score” or “scores”.

When you enter the name of an author, it must be the exact form that it
appears in in the `gutenbergr` dataset. Thus, you might still prefer to
use `stringr::str_detect` and `gutenbergr::gutenberg_works` when you
don’t know that exact form.

### Building a Corpus

Functions dealing with corpora have the prefix `corpus_*`. To build a
corpus from the `gutenbergr` database, you can use the `corpusr`
functions `corpus_build_works` or `corpus_build_author`. These return a
list of complete `cps_bk` objects, each of which contains the full texts
with sentence-level observations, as opposed to the *filtered* `cps_bk`
objects returned by `guten_search`, for example. Depending on the
function you use, you provide either a vector of work IDs
(`corpus_build_works`) or an author name. Currently, you cannot pass a
vector of author names, although this functionality will be added in
future versions.

``` r
corpus_build_works(4) %>% print()
```

    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  Lincoln's Gettysburg Address
    ## Given November 19, 1863 on the battlefield near Gettysburg, Pennsylvania, USA 
    ## 
    ## 1. This is a retranscription of one of the first Project Gutenberg Etexts, offically dated December 31, 1974-- and now officially re-released on November 19, 1993-- 130 years after it was spoken.  
    ## 
    ## 2. We will rerelease the Inaugural Address of President Kennedy, officially on November 22, 1993, on the day of the 30th anniversary of his assassination.     
    ## 
    ## 3. Lincoln's Gettysburg Address, given November 19, 1863 on the battlefield near Gettysburg, Pennsylvania, USA   Four score and seven years ago, our fathers brought forth upon this continent a new nation:  conceived in liberty, and dedicated to the proposition that all men are created equal.  
    ## 
    ## 4. Now we are engaged in a great civil war. . .testing whether that nation, or any nation so conceived and so dedicated. . . can long endure.  
    ## 
    ## 5. We are met on a great battlefield of that war.  
    ## 
    ## 6. We have come to dedicate a portion of that field as a final resting place for those who here gave their lives that this nation might live. 
    ## 
    ## 7. It is altogether fitting and proper that we should do this.  
    ## 
    ## 8. But, in a larger sense, we cannot dedicate. . .we cannot consecrate. . . we cannot hallow this ground.  
    ## 
    ## 9. The brave men, living and dead, who struggled here have consecrated it, far above our poor power to add or detract.  
    ## 
    ## 10. The world will little note, nor long remember, what we say here, but it can never forget what they did here.  
    ## 
    ## 
    ## NOTE: Only showing the first 10 sentences. Omitted 2 sentences.
    ## -----------------------------------------------------

This corpus is small, but good for illustrating the idea. Once built,
you can search this corpus using `corpusr::corpus_search()`:

``` r
corpus_build_works(4) %>% 
  corpus_search("battlefield")
```

    ## [[1]]
    ## 
    ## Author:  Lincoln, Abraham 
    ## Title:  Lincoln's Gettysburg Address
    ## Given November 19, 1863 on the battlefield near Gettysburg, Pennsylvania, USA 
    ## 
    ## 1. Lincoln's Gettysburg Address, given November 19, 1863 on the battlefield near Gettysburg, Pennsylvania, USA   Four score and seven years ago, our fathers brought forth upon this continent a new nation:  conceived in liberty, and dedicated to the proposition that all men are created equal.  
    ## 
    ## 2. We are met on a great battlefield of that war.  
    ## 
    ## 
    ## -----------------------------------------------------

In general, it’s best work from a corpus. A corpus has several
advantages over the interactive `guten_*` functions:

1.  A corpus built with `corpus_build_*` can be saved, allowing you to
2.  You are guaranteed to always be working with the same data,
    regardless of whether Project Gutenberg changes the files.
3.  It’s much faster to use `corpus_search` than it is to use
    `guten_search_works`.

# The `corpusr` Package

## Motivation

The `gutenbergr` package allows one to query the Project Gutenberg book
database for searchable full-texts, which you can then analyze in R.
What I wanted to do was search for illustrative examples of sentences in
these works. For this purpose, there are several weaknesses in the
`gutenbergr` package that I wanted to improve on:

1.  **Lines, not sentences** The responses are organized only into data
    frames with a ‘full-text’ column, in which the unit of observation
    is the line.
2.  **Lack of grouping structures** Querying multiple books can be
    difficult because there is no structure that allows you to easily
    distinguish books and authors from each other.
3.  **No print methods** Without a convenient print method, printing
    many sentences from many books becomes an exercise in data
    manipulation.

In `corpusr`, the unit of observation is the sentence, and books
(`cps_bk` objects) can be grouped together into a `cps_corpus` object,
which provides very clear grouping and printing.

## Implementation

There are two objects, `cps_bk` and `cps_corpus`. A `cps_bk` stores a
list containing the full text (as sentences, not lines), the author, and
the title of the work. This way, unnecessary metadata is kept to a
minimum. The print method for a `cps_bk` is designed to make the author
and title clear. For example:

    Author:  Lincoln, Abraham 
    Title:  Noted Speeches of Abraham Lincoln
    Including the Lincoln-Douglas Debate 
    
    1. Occasional poisonings from the kitchen and open or stealthy assassinations in the field, and local revolts extending to a score or so, will continue to occur as the natural results of slavery; but no general insurrections of slaves, as I think, can happen in this country for a long time. 

A list of `cps_bk` objects can be made into a `cps_corpus`, which
provides a further print method that makes several things clear:

1.  The author, title, and number of returned sentences, via the
    `cps_bk` print method.
2.  The number of books containing the searched-for word or phrase.

For example:

    [[1]]
    
    Author:  Lincoln, Abraham 
    Title:  Lincoln's Gettysburg Address
    Given November 19, 1863 on the battlefield near Gettysburg, Pennsylvania, USA 
    
    1. Lincoln's Gettysburg Address, given November 19, 1863 on the battlefield near Gettysburg, Pennsylvania, USA   Four score and seven years ago, our fathers brought forth upon this continent a new nation:  conceived in liberty, and dedicated to the proposition that all men are created equal.  
    
    
    -----------------------------------------------------
    
    < ... TRUNCATED (not part of print method) ... >
    
    [[11]]
    
    Author:  Lincoln, Abraham 
    Title:  Speeches & Letters of Abraham Lincoln, 1832-1865 
    
    1. He says that, upon the score of equality, slaves should be allowed to go into a new Territory like other property. 
    
    2. There are scores of them--good men in their character for intelligence, for talent and integrity. 
    
    3. Occasional poisonings from the kitchen, and open or stealthy assassinations in the field, and local revolts extending to a score or so, will continue to occur as the natural results of slavery; but no general insurrection of slaves, as I think, can happen in this country for a long time. 
    
    
    -----------------------------------------------------
    
    [[12]]
    
    Author:  Lincoln, Abraham 
    Title:  Noted Speeches of Abraham Lincoln
    Including the Lincoln-Douglas Debate 
    
    1. Occasional poisonings from the kitchen and open or stealthy assassinations in the field, and local revolts extending to a score or so, will continue to occur as the natural results of slavery; but no general insurrections of slaves, as I think, can happen in this country for a long time. 
    
    
    -----------------------------------------------------

At the moment, the regular expression is not saved or printed, but this
is on the to-do list.

-----

This is one project I would like to convert to a Python project using
the [Natural Language Toolkit](https://www.nltk.org/). Owing to the
large size of the corpora that you can generate with `corpusr`, both
packages would have a place in my language processing workflow. But this
is all just personal notetaking.

-----

# History and Purpose

I read often, and I write often. When I find a word I like, say
‘jeremiad’, I’m interested in how the word is used. A ‘jeremiad’ is a
lamentation or complaint, and it refers specifically to the Jeremiah in
the Bible: does that mean it’s always used with a religious connotation?
Does it have a typical collocation?

Illustrative quotations are central to modern lexicography. The first
edition of the OED contained 252,200 entries and 1,861,200 illustrative
quotations from a corpus of approximately 5 million slips, all
hand-written and contributed by everyone lexicographical authorities to
interested readers. Today, the OED contains about 290,500 main entries
with 2,412,400 illustrative quotations. (For an interesting look at the
statistics of the OED, take a look at the [OED
Editions](https://public.oed.com/history/oed-editions/) website.) There
was, is, and always will be, a large space for quotations in the OED,
because lexicographers are as interested in word usage as in word
definitions (if it even makes sense to talk about them as separate
entities). Today, the OED is powered by the Oxford English Corpus. It
contains nearly 2.1 billion words, all searchable in context, from all
imaginable sources from the English-speaking world.

Important developments often come from extremes. The OED citations were
often from works of literature and other carefully edited works. In
1961, Merriam-Webster published *Webster’s Third New International
Dictionary*, and the editors (led by Philip Gove) included all manner of
quotations from well-respected literary men to the Saturday Evening Post
and Reader’s Digest. Reviewers were outraged. They felt that proper
English was being degraded, destroyed. But to many lexicographers it
made sense. It certainly made sense to the editors of the OED. The
Oxford English Corpus contains a much wider array of citations from
outside literature.

The purpose of my package is small, but it derives mostly from one
thing: it’s hard to find good illustrative quotations. Most corpora are
not publicly available, and if they are they are expensive, difficult to
use, or small. I wanted a search engine in which you could search for a
word or phrase and be given example sentences from across literature.

A side note: This package has a focus on literature, and literature does
not represent the language as it is spoken; neither, then, does this
package. The `corpusr` package is useful for studying the standard
written English contained in books whose copyrights have expired and
left them in the public domain.

Why is it necessary to look at example sentences? Why not use a good
dictionary with usage labels like *rare*, *chiefly N. American*, and so
on? There is no reason not to use a dictionary, but it’s analogous to
reading a description of a photograph instead of looking at the
photograph itself. By reading a description of a photo, you understand
the content, the context, and you might get more information in a
description than you could possibly by looking at the photograph (its
history, inspiration, etc.). But you don’t understand the photograph
because you haven’t seen it.

Today, there are no dictionaries of illustrative quotations. Even the
OED gives mainly historical quotations, not all of which are useful to
the modern English speaker/writer. Thus, there is a need to have a
simple-to-use, searchable, customizable corpus of sentences.
