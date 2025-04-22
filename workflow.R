library(httr2)
library(readr)

api_key <- Sys.getenv("API_KEY")

headers <- list(
    "Content-Type" = "application/json",
    "Accept" = "application/json",
    "Authorization" = paste("Bearer", api_key)
)

# Which models are available?
response <- request("https://ai-research-proxy.azurewebsites.net/models") %>%
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

# Choose model, persona, load prompts, loop
model <- "gpt-4o-mini"
persona <- "You can interpret how someone feels from how they talk and assign a number from 1 (unhappy) to 5 (happy)"
data <- read_csv("feelings.csv")
for (text in data$feeling) {
    print(text)
    response <- request("https://ai-research-proxy.azurewebsites.net/chat/completions") %>%
    req_headers(!!!headers) %>% 
    req_body_json(
        list(
            model = model,
            messages = list(
                list(role = "system", content = persona),
                list(role = "user", content = text)
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
