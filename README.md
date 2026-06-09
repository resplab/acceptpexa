# acceptpexa

A ModelsCloud wrapper for the ACCEPT package — ACute COPD Exacerbation Prediction Tool.

## Overview

This package wraps the [resplab/accept](https://github.com/resplab/accept) package for deployment on the ModelsCloud platform. It supports all versions of ACCEPT including ACCEPT 3.0-CPRD, a UK primary-care specific recalibration derived from the Clinical Practice Research Datalink (CPRD).

For direct use, install the main ACCEPT package instead:

```r
remotes::install_github("resplab/accept")
```

## ModelsCloud Usage

```r
library(modelscloud)
connect_to_model("resplab/acceptpexa", access_key = "YOUR_API_KEY")

# UK primary care (ACCEPT 3.0-CPRD)
result <- model_run(get_sample_input(), country = "GBR-primary")

# UK specialty care
result <- model_run(get_sample_input(), country = "GBR-specialty")

# Other countries
result <- model_run(get_sample_input(), country = "CAN")

# ACCEPT 2
result <- model_run(get_sample_input(), version = "accept2")
```

## Functions

- `model_run(model_input, version, country)` — runs ACCEPT predictions
- `get_sample_input()` — returns sample patient data
- `get_default_input()` — returns a single default patient

## Related

- [resplab/accept](https://github.com/resplab/accept) — main ACCEPT package
- [resplab/accept3_UK](https://github.com/resplab/accept3_UK) — manuscript analysis code
