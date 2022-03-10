#### function to extract character strings inside parentesis of text.
#### the prospective use for this function is to quickly obtain a list of in text citations that can be
#### compared to the literature cited section of works of writing
library(dplyr)
library(stringr)
library(readtext)
library(XML)
library(here)

here()
######Option to manually paste text####
text <- "This is a test. I only want to select the (cites) in parenthesis. I do not want it to return words in parenthesis that do not have years attached, such as abbreviations (abbr). For example, citing (Smith, 2010) is something I would want to be returned. I would also want multiple citations returned separately such as (Smith 2010; Jones, 2001; Brown 2020). I would also want Cooper (2015) returned as Cooper 2015, and not just 2015.  I would also want John Granger et al. (2015) returned as John Granger et al. 2015."

######Option to read in word doc######
wordtest<-readtext(here("Example.docx"))
text<-wordtest$text
######Option to read in PDF file######
PDFtest<-readtext("Example2.pdf")
text<-PDFtest$text
##Return citations alphabetically:
rx <- "(?:\\b(\\p{Lu}\\w*(?:\\s+\\p{Lu}\\w*)*(?:\\s+et\\s+al\\.)?)?)\\s*\\(([^()]*\\d{4})\\)"
res <- str_match_all(text, rx)
result <- lapply(res, function(z) {ifelse(!is.na(z[,2]) & str_detect(z[,3],"^\\d+$"), paste(trimws(z[,2]),  trimws(z[,3])), z[,3])})    
sort(unique(unlist(sapply(result, function(z) strsplit(paste(z, collapse=";"), "\\s*;\\s*")))))

##Return citations Chronologically:
rx <- "(?:\\b(\\p{Lu}\\w*(?:\\s+\\p{Lu}\\w*)*(?:\\s+et\\s+al\\.)?)?)\\s*\\(([^()]*\\d{4})\\)"
res <- str_match_all(text, rx)
result <- lapply(res, function(z) {ifelse(!is.na(z[,2]) & str_detect(z[,3],"^\\d+$"), paste(trimws(z[,2]),  trimws(z[,3])), z[,3])})    
unique(unlist(sapply(result, function(z) strsplit(paste(z, collapse=";"), "\\s*;\\s*"))))

#### Exceptions I have come across that this function does not pick up on:
#1) An abbreviation separately followed by citation: (abbr) (Smith, 2021) -> would not extract "Smith, 2021:

