# Extract_in-text_citations
## R Shiny app developed to be able to upload a file (.doc, .docx, .pdf, etc.) and it will find the mentioned in-text citations and return them as a list in either alphabetical or chronological order.

## This app will extract the following in-text citation formats within pieces of writing:
  1) This is an example sentence (Author 2020).
  2) This is an example sentence (Author and Anotherauthor 2010).
  3) This is an example sentence (Author 2004; Secondauthor 2018; Thridauthor 2022).
  4) This is an example sentence (Green 2020a).
  5) This is an example sentence (Green 2020b).
  6) This is an example sentence (Cooper et al. 2020).
  7) This is an example sentence written by Cooper (2015).
  8) This is an example sentence written by Cooper and Brown (2001).
  9) This example should also work John Granger et al. (2015).
  10) It will also work with commas (Author, 2008).



### Instances I have come across where this app will not pick up on citations:
  1) This is an example text with an abbreviation directly followed by a citation (ABBR) (Author, 2010).
         
I know this is not a common method of separating abbrevations from citaitons, but I have still seen it in papers.

#### Please feel free to comment or let me know about any other instances where the app misses citations, as adding examples to the list will also help users be able to manually search for them after.

### Other Important Notes:
##### This app will sometimes list things that are not citations in the results.
- For example, often abbreviations are listed alongside citations such as (ABBR; Author 2004; Secondauthor 2018; Thridauthor 2022).
- "ABBR" might be returned as a citation in the list. Therefore it is important for the user to take a close enough look at the list to determine if it is an actual       citation or not.
- Using the app with the "alphabetical order" sort method will likely be more useful than chronological as it allows or faster side-by-side comparison with the works cited.
- However, the chronological order sort method might be helpful when a result is returned and the user is not sure if it is a proper citaiton or not, but the chronological order may give the user a better idea of where to go back and double check in the paper.
      
      
If you have any questions or comments, please reach out to me at jamie.behan@maine.edu
  
