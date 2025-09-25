library(httr2)
library(readr)

api_key <- Sys.getenv("OPENAI_API_KEY")
base_url <- Sys.getenv("OPENAI_BASE_URL")

headers <- list(
  "Content-Type" = "application/json",
  "Accept" = "application/json",
  "Authorization" = paste("Bearer", api_key)
)

# Load publications data
data <- read_csv("publications2024.csv", n_max = 20)

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
    )
  )
)

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
    print(content$choices[[1]]$message$content)
  } else {
    cat("Error:", response$status_code, "\n")
  }
}