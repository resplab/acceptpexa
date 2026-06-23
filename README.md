# acceptpexa

A ModelsCloud wrapper for the ACCEPT package — ACute COPD Exacerbation Prediction Tool.

## Overview

This package wraps the [resplab/accept](https://github.com/resplab/accept) package for
deployment on the [ModelsCloud](https://modelscloud.resp.core.ubc.ca/) platform. It supports
all versions of ACCEPT including ACCEPT 3.0-CPRD, a UK primary-care specific recalibration
derived from the Clinical Practice Research Datalink (CPRD).

**Default behaviour:** `model_run()` with no arguments runs **ACCEPT 2.0** on the built-in
sample patients. ACCEPT 2.0 works universally — no country code is needed.

> **Important:** All arguments to `model_run()` must be named.
> Use `model_run(model_input = patients)`.

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

### Option 1 — Direct R usage (full flexibility)

```r
library(acceptpexa)

# Get sample patients
patients <- get_sample_input()

# ACCEPT 2.0 — default, no country needed
model_run()
model_run(model_input = patients)
model_run(model_input = get_default_input())

# ACCEPT 3.0 — UK primary care (ACCEPT 3.0-CPRD)
# Missing optional predictors are auto-imputed
model_run(model_input = patients, version = "accept3", country = "GBR-primary")

# ACCEPT 3.0 — UK specialty care
model_run(model_input = patients, version = "accept3", country = "GBR-specialty")

# ACCEPT 3.0 — Other countries
model_run(model_input = patients, version = "accept3", country = "CAN")
model_run(model_input = patients, version = "accept3", country = "USA")

# ACCEPT 1.0
model_run(model_input = patients, version = "accept1")
```

### Option 2 — Via ModelsCloud API

```r
library(modelscloud)
connect_to_model("resplab/acceptpexa", access_key = "YOUR_API_KEY")

# Get sample patients from the server
patients <- get_sample_input()

# Run ACCEPT 2.0 (default — no country needed)
result <- model_run(patients)
result
```

> **Note:** `modelscloud::model_run()` only passes `model_input` to the server.
> To use `version = "accept3"` with a specific country via the API, use
> `pexaclient::function_call()` directly:
>
> ```r
> library(pexaclient)
> result <- function_call(
>   model_path = "resplab/acceptpexa",
>   func_name  = "model_run",
>   func_input = list(
>     model_input = patients,
>     version     = "accept3",
>     country     = "GBR-primary"
>   ),
>   access_key = "YOUR_API_KEY"
> )
> result$output
> ```

---

## Versions

| Version | Call | Country needed? | Missing optionals imputed? |
|---|---|---|---|
| ACCEPT 2.0 | `version = "accept2"` | No | No |
| ACCEPT 3.0-CPRD | `version = "accept3", country = "GBR-primary"` | Yes | **Yes** |
| ACCEPT 3.0 (other) | `version = "accept3", country = "CAN"` | Yes | No |
| ACCEPT 1.0 | `version = "accept1"` | No | No |

### Supported countries for ACCEPT 3.0

ARG, AUS, BRA, CAN, COL, DEU, DNK, ESP, FRA, ITA, JPN, KOR, MEX, NLD, NOR, SWE, USA

For UK: use `"GBR-primary"` (primary care) or `"GBR-specialty"` (specialty care).

---

## Mandatory Predictors

These must always be provided for all versions:

| Variable | Description |
|---|---|
| `ID` | Patient identifier |
| `age` | Age in years |
| `male` | TRUE/FALSE |
| `FEV1` | FEV1 % predicted (10–120) |
| `LastYrExacCount` | Total exacerbations last year |
| `LastYrSevExacCount` | Severe exacerbations last year |
| `mMRC` or `SGRQ` | Symptom score (at least one required) |

---

## Optional Predictors

`LABA`, `oxygen`, `ICS`, `LAMA`, `statin`, `BMI`, `smoker`

These are optional when using `version = "accept3", country = "GBR-primary"` — missing
values are automatically imputed using a UK-specific sequential regression model derived
from CPRD data.

For all other versions, all predictors should be provided.

---

## Functions

| Function | Description |
|---|---|
| `model_run(...)` | Run ACCEPT predictions. All arguments must be named. |
| `get_sample_input(n)` | Get sample patient data (optional: n patients) |
| `get_default_input()` | Get a single default patient |
| `echo(...)` | Echo input back — for testing API connectivity and serialization |

---

## Related

- [resplab/accept](https://github.com/resplab/accept) — main ACCEPT package
- [ModelsCloud platform](https://modelscloud.resp.core.ubc.ca/)
