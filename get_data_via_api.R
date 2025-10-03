library(httr2)

# Prepare the request
req <- request("https://api.openalex.org/works?filter=institutions.ror:04dkp9463,publication_year:2024")

# Submit the request
resp <- req %>% req_perform()

# Retrieve data from the response
data <- resp %>% resp_body_json() %>% str()