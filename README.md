# accept3ukR

An R package that provides UK primary-care specific COPD exacerbation risk predictions using ACCEPT 3.0-CPRD.

## Overview

ACCEPT 3.0-CPRD is a recalibration of ACCEPT 2.0 derived from the CPRD (Clinical Practice Research Datalink) primary-care dataset. It applies optimism-corrected Cox-model recalibration parameters separately for moderate-to-severe and severe exacerbations.

## Installation

```r
remotes::install_github("resplab/accept3ukR")
```

## Usage

```r
library(accept3ukR)

# Get sample patients
patients <- get_sample_input()

# Run prediction
results <- model_run(patients)
print(results)
```

## Functions

- `model_run()` — runs ACCEPT 3.0-CPRD predictions on a tibble of patients
- `get_sample_input()` — returns sample patient data
- `get_default_input()` — returns a single default patient

## Related

- [resplab/accept](https://github.com/resplab/accept) — the main ACCEPT package
- [resplab/accept3_UK](https://github.com/resplab/accept3_UK) — manuscript analysis code
