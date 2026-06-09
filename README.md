# acceptpexa

A ModelsCloud wrapper for the ACCEPT package — ACute COPD Exacerbation Prediction Tool.

## Overview

This package wraps the [resplab/accept](https://github.com/resplab/accept) package for deployment on the ModelsCloud platform. It supports all versions of ACCEPT including ACCEPT 3.0-CPRD, a UK primary-care specific recalibration derived from the Clinical Practice Research Datalink (CPRD).

For direct use, install the main ACCEPT package instead:

```r
remotes::install_github("resplab/accept")
```

## Versions

- **ACCEPT 3.0-CPRD** (`country = "GBR-primary"`) — UK primary care recalibration using CPRD data. Includes automatic imputation of missing optional predictors.
- **ACCEPT 3.0** (`version = "accept3"`) — Country-specific recalibration based on the NOVELTY study. Requires a country code.
- **ACCEPT 2.0** (`version = "accept2"`) — Updated model improving accuracy for patients without exacerbation history.
- **ACCEPT 1.0** (`version = "accept1"`) — Original ACCEPT model.



## Required Predictors for GBR-primary

| Variable | Description |
|---|---|
| `ID` | Patient identifier |
| `age` | Age in years |
| `male` | TRUE/FALSE |
| `FEV1` | FEV1 % predicted (10-120) |
| `LastYrExacCount` | Total exacerbations last year |
| `LastYrSevExacCount` | Severe exacerbations last year |
| `mMRC` or `SGRQ` or `CAT` | Symptom score (at least one required) |

## Optional Predictors  for GBR-primary

When using `country = "GBR-primary"`, these predictors are optional — if missing 
they are automatically imputed using a UK-specific sequential regression 
imputation model derived from CPRD data:

`LABA`, `oxygen`, `ICS`, `LAMA`, `statin`, `BMI`, `smoker`

For all other versions, all predictors should be provided.
For requirements for other versions, see [resplab/accept](https://github.com/resplab/accept).

## ModelsCloud Usage

```r
library(modelscloud)
connect_to_model("resplab/acceptpexa", access_key = "YOUR_API_KEY")

# Get sample patients
patients <- get_sample_input()

# UK primary care - ACCEPT 3.0-CPRD (all predictors present)
model_run(patients, country = "GBR-primary")

# UK primary care - with missing optional predictors (auto-imputed)
patients_missing <- patients
patients_missing$BMI    <- NULL
patients_missing$statin <- NULL
patients_missing$LABA   <- NULL
model_run(patients_missing, country = "GBR-primary")

# UK specialty care
model_run(patients, country = "GBR-specialty")

# Other countries (ACCEPT 3.0)
model_run(patients, country = "CAN")
model_run(patients, country = "USA")

# ACCEPT 2.0
model_run(patients, version = "accept2")

# ACCEPT 1.0
model_run(patients, version = "accept1")

# Single patient
model_run(get_default_input(), country = "GBR-primary")
```

## Functions

| Function | Description |
|---|---|
| `model_run(model_input, version, country)` | Run ACCEPT predictions |
| `get_sample_input(n)` | Get sample patient data (optional: n patients) |
| `get_default_input()` | Get a single default patient |

## Supported Countries for ACCEPT 3.0

ARG, AUS, BRA, CAN, COL, DEU, DNK, ESP, FRA, ITA, JPN, KOR, MEX, NLD, NOR, SWE, USA

For UK: use `"GBR-primary"` (primary care) or `"GBR-specialty"` (specialty care).

For unsupported countries, provide `obs_modsev_risk`:

```r
model_run(patients, version = "accept3", country = "XXX", obs_modsev_risk = 0.2)
```

## Related

- [resplab/accept](https://github.com/resplab/accept) — main ACCEPT package
- [resplab/accept3_UK](https://github.com/resplab/accept3_UK) — manuscript analysis code
- [ModelsCloud platform](https://modelscloud.resp.core.ubc.ca/)
