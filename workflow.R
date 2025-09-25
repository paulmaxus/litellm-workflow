library(httr2)
library(readr)

api_key <- Sys.getenv("OPENAI_API_KEY")
base_url <- Sys.getenv("OPENAI_BASE_URL")

headers <- list(
  "Content-Type" = "application/json",
  "Accept" = "application/json",
  "Authorization" = paste("Bearer", api_key)
)

# Which models are available?
response <- request(paste0(base_url, "models")) %>%
  req_headers(!!!headers) %>%
  req_perform()

if (response$status_code == 200) {
  content <- resp_body_json(response)
  print("Available models:")
  for (model in content$data) {
    print(model$id)
  }
} else {
  cat("Error:", response$status_code, "\n")
}

# Simple prompt
persona <- "You are a helpful assistant."
prompt <- "Write a haiku about recursion in programming."

response <- request(paste0(base_url, "chat/completions")) %>%
  req_headers(!!!headers) %>%
  req_body_json(
    list(
      model = "gpt-4o-mini",
      messages = list(
        list(role = "system", content = persona),
        list(role = "user", content = prompt)
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