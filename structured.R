library(dplyr)
library(httr2)
library(jsonlite)

api_key <- Sys.getenv("OPENAI_API_KEY")
base_url <- Sys.getenv("OPENAI_BASE_URL")

headers <- list(
  "Content-Type" = "application/json",
  "Accept" = "application/json",
  "Authorization" = paste("Bearer", api_key)
)

# Load publications data
data <- read.csv("publications2024.csv", nrows = 20)

# Read and invert abstracts
n_subsets <- 20

abstracts_inverted <- read_json("abstracts_inverted.json")

abstracts <- list()
for (item in abstracts_inverted[1:n_subsets]) {
  if (is.null(item$abstract)) {
    next
  }
  # Create list of placeholders with sufficiently large size
  abstract <- rep(NA, 10000)
  for (word in names(item$abstract)) {
    indexes <- item$abstract[[word]]
    for (index in indexes) {
      abstract[index] <- word
    }
  }
  abstract <- paste(abstract[!is.na(abstract)], collapse = " ")
  abstracts <- append(abstracts, list(list(id = item$id, abstract = abstract)))
}

data <- merge(data, bind_rows(abstracts), by = "id")

# Assign SDG labels
model <- "gpt-4o-mini"
persona <- "You are an expert on Sustainable Development Goals. For a given publication you can assign the most suitable SDG."

schema <- list(
  name = "sdg_response",
  strict = TRUE,
  schema = list(
    type = "object",
    properties = list(
      sdg = list(type = "integer", minimum = 1, maximum = 17),
      label = list(type = "string")
    ),
    required = c("sdg", "label"),
    additionalProperties = FALSE
  )
)

responses_titles <- list()
for (text in data$title) {
  response <- request(paste0(base_url, "chat/completions")) %>%
    req_headers(!!!headers) %>%
    req_body_json(
      list(
        model = model,
        messages = list(
          list(role = "system", content = persona),
          list(role = "user", content = text)
        ),
        response_format = list(
          type = "json_schema",
          json_schema = schema
        )
      )
    ) %>%
    req_perform()

  if (response$status_code == 200) {
    content <- resp_body_json(response)
    responses_titles <- append(
      responses_titles,
      list(fromJSON(content$choices[[1]]$message$content))
    )
  } else {
    cat("Error:", response$status_code, "\n")
  }
}

data <- data %>% bind_cols(responses_titles %>% bind_rows())

# We can do the same for abstracts