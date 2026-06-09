#' Run ACCEPT prediction model
#' @param model_input A tibble of patients in the same format as accept::samplePatients
#' @param version Which version to run. Options: "accept3" (default), "accept2", "accept1"
#' @param country Three-letter ISO country code required for accept3.
#'   For UK primary care use "GBR-primary" (ACCEPT 3.0-CPRD).
#'   For UK specialty care use "GBR-specialty".
#'   Other supported countries: ARG, AUS, BRA, CAN, COL, DEU, DNK, ESP,
#'   FRA, ITA, JPN, KOR, MEX, NLD, NOR, SWE, USA.
#' @return A tibble with predicted exacerbation probabilities and rates
#' @export
model_run <- function(model_input, version = "accept3", country = NULL) {
  accept::accept(newdata = model_input, version = version, country = country)
}

#' Get sample input for ACCEPT
#' @param n number of sample patients to return. Default returns all.
#' @return A tibble of sample patients
#' @export
get_sample_input <- function(n = NULL) {
  data <- accept::samplePatients
  if (!is.null(n)) data <- data[seq_len(n), ]
  data
}

#' Get default input for ACCEPT
#' @return A tibble with one default patient
#' @export
get_default_input <- function() {
  accept::samplePatients[1, ]
}
