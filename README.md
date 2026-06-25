# acceptpexa

A ModelsCloud wrapper for the ACCEPT package — ACute COPD Exacerbation Prediction Tool.

## Overview

This package wraps the [resplab/accept](https://github.com/resplab/accept) package for
deployment on the [ModelsCloud](https://modelscloud.resp.core.ubc.ca/) platform. It supports
all versions of ACCEPT including ACCEPT 3.0-CPRD, a UK primary-care specific recalibration
derived from the Clinical Practice Research Datalink (CPRD).

### Design philosophy

`model_run()` takes a **single** `model_input` argument — a named list containing:
- `patients_data` — the array of patient records
- `version` — which ACCEPT model to run
- `country` — country code for ACCEPT 3.0

This follows the ModelsCloud uniform API contract where every model on the platform
looks identical to the client.

---

## Installation

### Direct R usage (recommended for full functionality)

```r
remotes::install_github("resplab/acceptpexa")
```

### Via ModelsCloud

```r
remotes::install_github("resplab/modelscloud")
```

---

## Usage

### Option 1 — Direct R usage

```r
library(acceptpexa)

# Use default input (accept2, single patient)
model_run()

# Get sample patients and run accept2 (default)
mi <- get_sample_input()
model_run(mi)

# UK primary care — ACCEPT 3.0-CPRD
mi <- get_sample_input()
mi$version <- "accept3"
mi$country <- "GBR-primary"
model_run(mi)

# UK specialty care
mi <- get_sample_input()
mi$version <- "accept3"
mi$country <- "GBR-specialty"
model_run(mi)

# Other countries
mi <- get_sample_input()
mi$version <- "accept3"
mi$country <- "CAN"
model_run(mi)

# ACCEPT 1.0
mi <- get_sample_input()
mi$version <- "accept1"
model_run(mi)

# Missing optional predictors — auto-imputed for GBR-primary
mi <- get_sample_input()
mi$patients_data$BMI    <- NULL
mi$patients_data$LABA   <- NULL
mi$patients_data$statin <- NULL
mi$version <- "accept3"
mi$country <- "GBR-primary"
model_run(mi)
```

### Option 2 — Via ModelsCloud API

```r
library(modelscloud)
connect_to_model("resplab/acceptpexa", access_key = "YOUR_API_KEY")

# Default — accept2
model_run(get_default_input())

# UK primary care
mi <- get_sample_input()
mi$version <- "accept3"
mi$country <- "GBR-primary"
model_run(mi)
```

### Option 3 — Via Web Interface (Raw JSON)

```json
{
  "funcName": "model_run",
  "funcInput": {
    "model_input": {
      "patients_data": [
        {
          "ID": "10001",
          "male": true,
          "age": 70,
          "smoker": true,
          "oxygen": true,
          "statin": true,
          "LAMA": true,
          "LABA": true,
          "ICS": true,
          "FEV1": 33,
          "BMI": 25,
          "SGRQ": 50,
          "LastYrExacCount": 2,
          "LastYrSevExacCount": 1
        }
      ],
      "version": "accept3",
      "country": "GBR-primary"
    }
  },
  "ignoreDefaultInput": true
}
```

---

## How it works

`model_run()` receives a single named list (`model_input`) structured as:

```r
list(
  patients_data = <data frame or list of patient records>,
  version       = "accept3",
  country       = "GBR-primary"
)
```

It extracts `version` and `country`, passes `patients_data` to `accept::accept()`.

---

## Versions

| Version | How to use | Country needed? | Missing optionals imputed? |
|---|---|---|---|
| ACCEPT 2.0 | `mi$version <- "accept2"` | No | No |
| ACCEPT 3.0-CPRD | `mi$version <- "accept3"; mi$country <- "GBR-primary"` | Yes | **Yes** |
| ACCEPT 3.0 (other) | `mi$version <- "accept3"; mi$country <- "CAN"` | Yes | No |
| ACCEPT 1.0 | `mi$version <- "accept1"` | No | No |

### Supported countries for ACCEPT 3.0

ARG, AUS, BRA, CAN, COL, DEU, DNK, ESP, FRA, ITA, JPN, KOR, MEX, NLD, NOR, SWE, USA

For UK: use `"GBR-primary"` (primary care) or `"GBR-specialty"` (specialty care).

---

## Required Identifier

| Variable | Description |
|---|---|
| `ID` | Unique patient identifier — required to label output rows, not a predictor |

## Mandatory Predictors

| Variable | Description |
|---|---|
| `age` | Age in years |
| `male` | TRUE/FALSE |
| `FEV1` | FEV1 % predicted (10–120) |
| `LastYrExacCount` | Total exacerbations last year |
| `LastYrSevExacCount` | Severe exacerbations last year |
| `mMRC` or `SGRQ` | Symptom score — at least one required. SGRQ is converted to mMRC internally if mMRC is missing |

---

## Optional Predictors

`LABA`, `oxygen`, `ICS`, `LAMA`, `statin`, `BMI`, `smoker`

These are optional when using `version = "accept3"` with `country = "GBR-primary"` —
missing values are automatically imputed using a UK-specific sequential regression model
derived from CPRD data. For all other versions, all predictors should be provided.

---

## Functions

| Function | Description |
|---|---|
| `model_run(model_input)` | Run ACCEPT predictions |
| `get_sample_input(n)` | Get sample input list with patients_data, version and country |
| `get_default_input()` | Get default input list with one patient, version and country |
| `echo(...)` | Echo input back — for testing API connectivity |

---

## Related

- [resplab/accept](https://github.com/resplab/accept) — main ACCEPT package
- [ModelsCloud platform](https://modelscloud.resp.core.ubc.ca/)
