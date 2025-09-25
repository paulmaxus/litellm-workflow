## LiteLLM resources

Additional example scripts for the [GenAI workshop](https://paulmaxus.github.io/api-lesson/).

For both Python and R, you'll find several files here:

- workflow: simple examples of using the API
- structured: using structured output for SDG labeling

### Python

You will need a file `config.py` with a variable `api_key` set to your key.

### R

For the scripts to work, you need to set environment variables. You can either set those manually with `Sys.setenv()` or by creating a .Renviron file.
Make sure to restart R whenever you make changes to .Renviron

The following variables should be set:

OPENAI_BASE_URL=https://ai-research-proxy.azurewebsites.net/
OPENAI_API_KEY=INSERT_YOUR_API_KEY_HERE