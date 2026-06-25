# Valid predictor names
.mandatory_vars <- c("ID", "age", "male", "FEV1",
                     "LastYrExacCount", "LastYrSevExacCount")
.optional_vars  <- c("LABA", "oxygen", "ICS", "LAMA",
                     "statin", "BMI", "smoker")
.symptom_vars   <- c("mMRC", "SGRQ", "CAT")

#' Run ACCEPT prediction model
#'
#' @param model_input A named list with three fields:
#'   \itemize{
#'     \item \code{patients_data} An array of patient records. Each record
#'       must contain the mandatory predictors. See Mandatory Predictors below.
#'     \item \code{version} Which version to run: "accept2" (default),
#'       "accept3", "accept1". Missing optional predictors are only
#'       auto-imputed when using version = "accept3" with country = "GBR-primary".
#'     \item \code{country} Required when version = "accept3".
#'       For UK primary care use "GBR-primary" (ACCEPT 3.0-CPRD).
#'       For UK specialty care use "GBR-specialty".
#'       Other supported countries: ARG, AUS, BRA, CAN, COL, DEU, DNK,
#'       ESP, FRA, ITA, JPN, KOR, MEX, NLD, NOR, SWE, USA.
#'   }
#'   If NULL, uses the default sample patient with version = "accept2".
#' @return A tibble with predicted exacerbation probabilities and rates
#' @export
model_run <- function(model_input = NULL) {

  # Use default if no input provided
  if (is.null(model_input)) {
    model_input <- list(
      patients_data = as.list(accept::samplePatients[1, ]),
      version       = "accept2",
      country       = NULL
    )
  }

  # Extract version and country
  version <- if ("version" %in% names(model_input)) model_input[["version"]] else "accept2"
  country <- if ("country" %in% names(model_input)) model_input[["country"]] else NULL

  # Extract patient data
  if (!"patients_data" %in% names(model_input)) {
    stop("'patients_data' not found in model_input. ",
         "model_input must be a list with 'patients_data', 'version', and 'country' fields.")
  }
  patient_data <- model_input[["patients_data"]]

  # Validate version
  valid_versions <- c("accept1", "accept2", "accept3")
  if (!version %in% valid_versions) {
    stop(paste("Invalid version:", version,
               "- must be one of:", paste(valid_versions, collapse = ", ")))
  }

  # Validate country required for accept3
  if (version == "accept3" && is.null(country)) {
    stop("'country' is required when version = 'accept3'. ",
         "e.g., add country = 'GBR-primary' to your model_input list.")
  }

  # Convert to data frame if needed
  if (is.list(patient_data) && !is.data.frame(patient_data)) {
    patient_data <- as.data.frame(patient_data, stringsAsFactors = FALSE)
  }

  # Validate mandatory columns present
  missing_cols <- setdiff(.mandatory_vars, names(patient_data))
  if (length(missing_cols) > 0) {
    stop(paste("Missing required columns in patients_data:",
               paste(missing_cols, collapse = ", ")))
  }

  # Serialise to JSON — accept::accept(format = "json") reconstructs a proper
  # tibble internally, which is required by accept3_cprd and other functions.
  json_input <- jsonlite::toJSON(patient_data, dataframe = "rows", auto_unbox = FALSE)

  accept::accept(newdata = json_input, format = "json", version = version, country = country)
}

#' Get sample input for ACCEPT
#'
#' @param n Optional. Number of sample patients to return. Default returns all.
#' @return A list with patients_data, version and country fields
#' @export
get_sample_input <- function(n = NULL) {
  data <- accept::samplePatients
  if (!is.null(n)) data <- data[seq_len(n), ]
  list(
    patients_data = data,
    version       = "accept2",
    country       = NULL
  )
}

#' Get default input for ACCEPT
#'
#' Returns a single default patient with default version and country fields,
#' ready to pass directly to model_run().
#'
#' @return A list with one default patient plus version and country fields
#' @export
get_default_input <- function() {
  list(
    patients_data = accept::samplePatients[1, ],
    version       = "accept2",
    country       = NULL
  )
}

#' Echo input back for testing API connectivity and serialization
#'
#' Returns diagnostic information about what the server received.
#' Use this to verify that data is being correctly passed to the server.
#'
#' @param ... Any arguments passed to the function
#' @return A list with diagnostic information about the received input
#' @export
echo <- function(...) {
  args <- list(...)

  if (length(args) == 0) {
    return(list(
      success = FALSE,
      message = "No input received. Pass model_input to test serialization.",
      example = "echo(model_input = get_default_input())"
    ))
  }

  if ("model_input" %in% names(args)) {
    input <- args$model_input
    return(list(
      success       = TRUE,
      timestamp     = as.character(Sys.time()),
      class         = class(input),
      typeof        = typeof(input),
      names         = names(input),
      version       = if ("version"       %in% names(input)) input[["version"]]       else "not provided",
      country       = if ("country"       %in% names(input)) input[["country"]]       else "not provided",
      patients_data = if ("patients_data" %in% names(input)) input[["patients_data"]] else "not provided"
    ))
  }

  list(
    success   = TRUE,
    timestamp = as.character(Sys.time()),
    argCount  = length(args),
    argNames  = names(args),
    args      = args
  )
}
