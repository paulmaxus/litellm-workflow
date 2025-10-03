# LiteLLM resources

Additional scripts for the [GenAI workshop](https://paulmaxus.github.io/api-lesson/).

For both Python and R, you'll find several files here:

- workflow: simple examples for using the API
- structured: using structured output for SDG labeling

## Python

To run the examples, you need to have `pandas` and `requests` installed.
You will also need a file `config.py` with a variable `api_key` set to your key. Make sure to never expose this key to the public.

## R

To run the examples, you need to have `readr`, `dplyr` (both tidyverse), `jsonlite` and `httr2` installed.
You also need to set environment variables. You can either set those manually with `Sys.setenv()` or by creating a .Renviron file.
Make sure to restart R whenever you make changes to .Renviron

The following variables should be set:

```bash
OPENAI_BASE_URL=https://ai-research-proxy.azurewebsites.net/

OPENAI_API_KEY=INSERT_YOUR_API_KEY_HERE
```