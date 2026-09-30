library(quallmer)
library(quanteda)

# Get last 5 inaugural addresses
texts <- tail(data_corpus_inaugural, 5)
texts

my_codebook <- qlm_codebook(
  name = "Tone analysis",
  instructions = "Classify the overall tone of this political speech.",
  schema = type_object(
    tone = type_enum(
      values = c("optimistic", "cautious", "urgent"),
      description = "The dominant emotional tone"
    ),
    confidence = type_integer("Confidence in classification from 1-5")
  )
)

my_codebook

coded <- qlm_code(
  texts,
  my_codebook,
  base_url = "https://llmproxy.uva.nl/",
  model = "openai_compatible/gpt-5.6-luna",
  name = "gpt-5.6-luna"
)

coded
