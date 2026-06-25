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

### Direct R usage 

```r
remotes::install_github("resplab/acceptpexa")
```

### Via ModelsCloud

```r
remotes::install_github("resplab/modelscloud")
```

---

## Quick Start

### Direct R usage (without ModelsCloud)

```r
remotes::install_github("resplab/acceptpexa")
library(acceptpexa)

# Default — accept2, single patient
model_run()

# UK primary care
model_run(list(
  patients_data = accept::samplePatients,
  version = "accept3",
  country = "GBR-primary"
))

# Canada
model_run(list(
  patients_data = accept::samplePatients,
  version = "accept3",
  country = "CAN"
))
```

### Via ModelsCloud

```r
remotes::install_github("resplab/modelscloud")
library(modelscloud)
connect_to_model("resplab/accept", access_key = "YOUR_KEY")

# Default — accept2
model_run(get_default_input())

# UK primary care
model_run(list(
  patients_data = accept::samplePatients,
  version = "accept3",
  country = "GBR-primary"
))
```

---

## Examples by Version

> **Note:** `ID` can be any string — `"P002"`, `"10001"`, `"patient_1"`, `"ABC123"` — it is just a label
> to identify the patient in the output. The model does not use it for any calculation; it simply
> echoes it back in the results so you can match predictions to patients.

### ACCEPT 1.0

**Web interface (Lite tab):**
```json
{
  "model_input": {
    "patients_data": [
      {
        "ID": "10001", "male": true, "age": 70, "smoker": true,
        "oxygen": true, "statin": true, "LAMA": true, "LABA": true,
        "ICS": true, "FEV1": 33, "BMI": 25, "SGRQ": 50,
        "LastYrExacCount": 2, "LastYrSevExacCount": 1
      }
    ],
    "version": "accept1"
  }
}
```

**R (modelscloud):**
```r
library(modelscloud)
connect_to_model("resplab/accept", access_key = "YOUR_KEY")

model_run(list(
  patients_data = data.frame(
    ID = "10001", male = TRUE, age = 70, smoker = TRUE, oxygen = TRUE,
    statin = TRUE, LAMA = TRUE, LABA = TRUE, ICS = TRUE, FEV1 = 33,
    BMI = 25, SGRQ = 50, LastYrExacCount = 2, LastYrSevExacCount = 1
  ),
  version = "accept1"
))
```

---

### ACCEPT 2.0

**Web interface (Lite tab):**
```json
{
  "model_input": {
    "patients_data": [
      {
        "ID": "10001", "male": true, "age": 70, "smoker": true,
        "oxygen": true, "statin": true, "LAMA": true, "LABA": true,
        "ICS": true, "FEV1": 33, "BMI": 25, "SGRQ": 50,
        "LastYrExacCount": 2, "LastYrSevExacCount": 1
      }
    ],
    "version": "accept2"
  }
}
```

> **Note:** `"country": null` also works for accept2 — country is not used.

**R (modelscloud):**
```r
model_run(list(
  patients_data = data.frame(
    ID = "10001", male = TRUE, age = 70, smoker = TRUE, oxygen = TRUE,
    statin = TRUE, LAMA = TRUE, LABA = TRUE, ICS = TRUE, FEV1 = 33,
    BMI = 25, SGRQ = 50, LastYrExacCount = 2, LastYrSevExacCount = 1
  ),
  version = "accept2"
))
```

---

### ACCEPT 3.0 — Country-specific (e.g. Germany)

**Web interface (Lite tab):**
```json
{
  "model_input": {
    "patients_data": [
      {
        "ID": "10001", "male": true, "age": 70, "smoker": true,
        "oxygen": false, "statin": true, "LAMA": true, "LABA": true,
        "ICS": false, "FEV1": 33, "BMI": 25, "SGRQ": 50,
        "LastYrExacCount": 2, "LastYrSevExacCount": 1
      }
    ],
    "version": "accept3",
    "country": "DEU"
  }
}
```

**R (modelscloud):**
```r
model_run(list(
  patients_data = data.frame(
    ID = "10001", male = TRUE, age = 70, smoker = TRUE, oxygen = FALSE,
    statin = TRUE, LAMA = TRUE, LABA = TRUE, ICS = FALSE, FEV1 = 33,
    BMI = 25, SGRQ = 50, LastYrExacCount = 2, LastYrSevExacCount = 1
  ),
  version = "accept3",
  country = "DEU"
))
```

---

### ACCEPT 3.0-CPRD — UK Primary Care (two patients)

**Web interface (Lite tab):**
```json
{
  "model_input": {
    "patients_data": [
      {
        "ID": "10001", "male": true, "age": 70, "smoker": true,
        "oxygen": true, "LAMA": true, "ICS": true, "FEV1": 33,
        "SGRQ": 50, "LastYrExacCount": 2, "LastYrSevExacCount": 1
      },
      {
        "ID": "10002", "male": false, "age": 42, "smoker": false,
        "oxygen": true, "LAMA": true, "ICS": false, "FEV1": 40,
        "SGRQ": 40, "LastYrExacCount": 0, "LastYrSevExacCount": 0
      }
    ],
    "version": "accept3",
    "country": "GBR-primary"
  }
}
```

**R (modelscloud):**
```r
model_run(list(
  patients_data = data.frame(
    ID    = c("10001", "10002"),
    male  = c(TRUE, FALSE),
    age   = c(70, 42),
    smoker = c(TRUE, FALSE),
    oxygen = c(TRUE, TRUE),
    LAMA  = c(TRUE, TRUE),
    ICS   = c(TRUE, FALSE),
    FEV1  = c(33, 40),
    SGRQ  = c(50, 40),
    LastYrExacCount    = c(2, 0),
    LastYrSevExacCount = c(1, 0)
  ),
  version = "accept3",
  country = "GBR-primary"
))
```

---

### ACCEPT 3.0-CPRD — Missing optional predictors (auto-imputed)

Missing `statin`, `LABA`, `BMI` are automatically imputed using the CPRD model.

**Web interface (Lite tab):**
```json
{
  "model_input": {
    "patients_data": [
      {
        "ID": "10001", "male": true, "age": 70, "smoker": true,
        "oxygen": true, "LAMA": true, "ICS": true, "FEV1": 33,
        "SGRQ": 50, "LastYrExacCount": 2, "LastYrSevExacCount": 1
      }
    ],
    "version": "accept3",
    "country": "GBR-primary"
  }
}
```

**R (modelscloud):**
```r
model_run(list(
  patients_data = data.frame(
    ID = "10001", male = TRUE, age = 70, smoker = TRUE, oxygen = TRUE,
    LAMA = TRUE, ICS = TRUE, FEV1 = 33, SGRQ = 50,
    LastYrExacCount = 2, LastYrSevExacCount = 1
  ),
  version = "accept3",
  country = "GBR-primary"
))
```

---

### Custom patient

**Web interface (Lite tab):**
```json
{
  "model_input": {
    "patients_data": [
      {
        "ID": "P002", "male": true, "age": 80, "smoker": true,
        "oxygen": true, "statin": true, "LAMA": true, "LABA": true,
        "ICS": true, "FEV1": 20, "BMI": 18, "SGRQ": 80,
        "LastYrExacCount": 5, "LastYrSevExacCount": 3
      }
    ],
    "version": "accept2"
  }
}
```

**R (modelscloud):**
```r
model_run(list(
  patients_data = data.frame(
    ID = "P002", male = TRUE, age = 80, smoker = TRUE, oxygen = TRUE,
    statin = TRUE, LAMA = TRUE, LABA = TRUE, ICS = TRUE, FEV1 = 20,
    BMI = 18, SGRQ = 80, LastYrExacCount = 5, LastYrSevExacCount = 3
  ),
  version = "accept2"
))
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

| Version | `version` | `country` needed? | Missing optionals imputed? |
|---|---|---|---|
| ACCEPT 1.0 | `"accept1"` | No | No |
| ACCEPT 2.0 | `"accept2"` | No | No |
| ACCEPT 3.0-CPRD | `"accept3"` | Yes — `"GBR-primary"` | **Yes** |
| ACCEPT 3.0 UK specialty | `"accept3"` | Yes — `"GBR-specialty"` | No |
| ACCEPT 3.0 other countries | `"accept3"` | Yes — e.g. `"CAN"` | No |

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

## References

If you use this package, please cite the relevant ACCEPT paper(s):

**ACCEPT 1.0**
> Adibi A, Sin DD, Safari A, Johnson KM, Aaron SD, FitzGerald JM, Sadatsafavi M.
> The Acute COPD Exacerbation Prediction Tool (ACCEPT): a modelling study.
> *The Lancet Respiratory Medicine.* 2020; 8(10): 1013–1021.
> https://doi.org/10.1016/S2213-2600(19)30397-2

**ACCEPT 2.0**
> Safari A, Adibi A, Sin DD, Lee TY, Ho JK, Sadatsafavi M and IMPACT study team.
> ACCEPT 2.0: Recalibrating and externally validating the Acute COPD Exacerbation Prediction Tool (ACCEPT).
> *EClinicalMedicine.* 2022; 51: 101574.
> https://doi.org/10.1016/j.eclinm.2022.101574

**ACCEPT 3.0-CPRD (UK primary care)**
> Mehareen J, Lim LHM, Adibi A, Amegadzie JE, Xia Y, De Vera MA, Law MR, Sin DD, Bhatt SP, Quint JK, Sadatsafavi M.
> Performance of multivariable risk prediction algorithms in predicting COPD exacerbations: a population-based study.
> *Thorax.* 2026.
> https://doi.org/10.1136/thorax-2026-224814

---

## Related

- [resplab/accept](https://github.com/resplab/accept) — main ACCEPT package
- [ModelsCloud platform](https://modelscloud.resp.core.ubc.ca/)
