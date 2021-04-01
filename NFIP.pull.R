library(tidyverse)

require("httr")

baseUrl <- "https://www.fema.gov/api/open/v1/FimaNfipClaims?$filter=(yearOfLoss%20ge%202015%20and%20state%20eq%20'NC')"


result <- GET(paste0(baseUrl,"&$inlinecount=allpages&$top=1&$select=id"))
jsonData <- content(result)
recCount <- as.numeric(jsonData$metadata$count)

get_data <- function(start=0){
  baseURL <- "https://www.fema.gov/api/open/"
  service <- "v1/FimaNfipClaims?$"
  filter  <- "filter=(yearOfLoss%20ge%202015%20and%20state%20eq%20'NC')"
  format  <- "&$format=csv"
  lines   <- paste0("&$skip=",start,"&$top=",start+1000)
  the_request = paste0(baseURL,service,filter,format,lines)
  the_data <- read.csv(the_request)
  return(the_data)
}


the_records = seq(0, recCount, by = 1000)

the_dfs <- lapply(X = the_records,
                  FUN = get_data)

df <- bind_rows(the_dfs)
