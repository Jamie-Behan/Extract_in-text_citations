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
####### START HELPER FUNCTIONS ##################################################
# Helper: Valid-looking author + year filter
is_valid_author_year <- function(citation) {
  citation <- str_trim(citation)
  year_match <- str_detect(citation, "\\d{4}$")
  name_part <- str_remove(citation, "\\s*\\d{4}$")
  name_has_caps <- str_detect(name_part, "\\b([A-Z][a-z\\p{L}\\-']+)(\\s+(and|et al\\.?|et al\\.,?|[A-Z][a-z\\p{L}\\-']+))*\\b")
  return(year_match & name_has_caps)
}

# Normalize
normalize_citation <- function(x) {
  x <- str_replace_all(x, ",", "")
  x <- str_replace_all(x, "\\s{2,}", " ")
  x <- str_trim(x)
  return(x)
}

# Extract from parentheses
paren_rx <- "\\(([^()]*\\d{4}[^()]*)\\)"
extract_citations <- function(matches) {
  unlist(lapply(matches, function(m) {
    if (!is.na(m)) {
      str_extract_all(m, "\\b[\\p{L}\\-]+(?:\\s+(?:and\\s+)?[\\p{L}\\-]+)*(?:\\s+et al\\.,?|\\s+et al\\.)?\\s*,?\\s*\\d{4}")[[1]]
    }
  }))
}

# Improved narrative citation detection
# Requires capitalized name(s), allows "et al." and "and" but avoids "from/since/between/for"
# Matches: Kane (2007), Smith and Wesson (2002), Granger et al. (2015)
narrative_rx <- "\\b([A-Z][a-z\\p{L}\\-']+(?:\\s+(?:and\\s+|et al\\.?|et al\\.|[A-Z][a-z\\p{L}\\-']+))*)\\s*\\(\\s*(\\d{4})\\s*\\)"

narrative_matches <- str_match_all(text, narrative_rx)[[1]]
if (nrow(narrative_matches) > 0) {
  narrative_citations <- paste(narrative_matches[,2], narrative_matches[,3]) %>%
    sapply(normalize_citation)
} else {
  narrative_citations <- character(0)
}

# Final filter
all_raw <- c(paren_citations, narrative_citations)
all_filtered <- all_raw[sapply(all_raw, is_valid_author_year)]
all_unique <- unique(all_filtered)


# Output
citations_alpha <- sort(all_unique)
citations_chrono <- all_unique[order(as.numeric(str_extract(all_unique, "\\d{4}")))]
################ WARNINGS FUNCTION  #############################################
# Function to identify potential citation mistakes
find_possible_mistakes <- function(text) {
  # 1. Catch "Author; Year" in parentheses (should be Author, Year)
  bad_semi <- str_match_all(text, "\\(([^)]*?[A-Z][a-z\\p{L}\\-']+(?:\\s+and\\s+[A-Z][a-z\\p{L}\\-']+)?\\s*;\\s*\\d{4})\\)")
  bad_semi <- unlist(bad_semi)
  
  # Remove any matches already caught as valid citations
  bad_semi <- bad_semi[!is.na(bad_semi)]
  
  return(unique(bad_semi))
}
  
# Warnings
warnings <- find_possible_mistakes(text)

cat("\n⚠️  POSSIBLE FORMATTING ISSUES (manual check suggested):\n")
print(warnings)

###### Select which way you want the output ####
cat("Alphabetical:\n")
print(citations_alpha)

cat("\nChronological:\n")
print(citations_chrono)
