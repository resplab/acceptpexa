#' # Valid predictor names
.mandatory_vars <- c("ID", "age", "male", "FEV1",
                     "LastYrExacCount", "LastYrSevExacCount")
.optional_vars  <- c("LABA", "oxygen", "ICS", "LAMA",
                     "statin", "BMI", "smoker")
.symptom_vars   <- c("mMRC", "SGRQ", "CAT")

#' Run ACCEPT prediction model
#' @param model_input Named list or data frame of patient inputs in the same
#'   format as accept::samplePatients. If NULL, uses default sample patients.
#' @param version Which version to run. Options: "accept2" (default),
#'   "accept3", "accept1". Note: accept2 requires all predictors to be present.
#'   Missing optional predictors are only auto-imputed when using
#'   version = "accept3" with country = "GBR-primary".
#' @param country Three-letter ISO country code required for accept3.
#'   For UK primary care use "GBR-primary" (ACCEPT 3.0-CPRD).
#'   For UK specialty care use "GBR-specialty".
#'   Other supported countries: ARG, AUS, BRA, CAN, COL, DEU, DNK, ESP,
#'   FRA, ITA, JPN, KOR, MEX, NLD, NOR, SWE, USA.
#' @return A tibble with predicted exacerbation probabilities and rates
#' @export
model_run <- function(model_input = NULL, version = "accept2", country = NULL) {
  if (is.null(model_input)) {
    model_input <- accept::samplePatients
  }
  if (is.list(model_input) && !is.data.frame(model_input)) {
    model_input <- as.data.frame(model_input)
  }
  accept::accept(newdata = model_input, version = version, country = country)
}

#' Get sample input for ACCEPT
#' @param n number of sample patients to return. Default returns all.
#' @return A data frame of sample patients in the format expected by model_run()
#' @export
get_sample_input <- function(n = NULL) {
  data <- accept::samplePatients
  if (!is.null(n)) data <- data[seq_len(n), ]
  data
}

#' Get default input for ACCEPT
#' @return A data frame with one default patient
#' @export
get_default_input <- function() {
  accept::samplePatients[1, ]
}
