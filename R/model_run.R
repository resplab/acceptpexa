# Valid predictor names
.mandatory_vars <- c("ID", "age", "male", "FEV1",
                     "LastYrExacCount", "LastYrSevExacCount")
.optional_vars  <- c("LABA", "oxygen", "ICS", "LAMA",
                     "statin", "BMI", "smoker")
.symptom_vars   <- c("mMRC", "SGRQ", "CAT")

#' Run ACCEPT prediction model
#'
#' @param ... Named arguments. Supported arguments:
#'   \itemize{
#'     \item \code{model_input} Named list or data frame of patient inputs.
#'       If NULL, uses default sample patients.
#'     \item \code{version} Which version to run: "accept2" (default),
#'       "accept3", "accept1". Missing optional predictors are only
#'       auto-imputed when using version = "accept3" with country = "GBR-primary".
#'     \item \code{country} Required when version = "accept3".
#'       For UK primary care use "GBR-primary" (ACCEPT 3.0-CPRD).
#'       For UK specialty care use "GBR-specialty".
#'       Other supported countries: ARG, AUS, BRA, CAN, COL, DEU, DNK,
#'       ESP, FRA, ITA, JPN, KOR, MEX, NLD, NOR, SWE, USA.
#'   }
#' @return A tibble with predicted exacerbation probabilities and rates
#' @export
model_run <- function(...) {
  args <- list(...)

  # Validate all arguments are named
  if (!is.null(names(args)) && any(names(args) == "")) {
    stop("All arguments must be named. e.g., model_run(model_input = patients, version = 'accept2')")
  }

  # Extract arguments with defaults
  model_input <- if ("model_input" %in% names(args)) args[["model_input"]] else NULL
  version     <- if ("version"     %in% names(args)) args[["version"]]     else "accept2"
  country     <- if ("country"     %in% names(args)) args[["country"]]     else NULL

  # Validate version
  valid_versions <- c("accept1", "accept2", "accept3")
  if (!version %in% valid_versions) {
    stop(paste("Invalid version:", version,
               "- must be one of:", paste(valid_versions, collapse = ", ")))
  }

  # Validate country required for accept3
  if (version == "accept3" && is.null(country)) {
    stop("'country' is required when version = 'accept3'. ",
         "e.g., country = 'GBR-primary' or country = 'CAN'")
  }

  # Use default if no input provided
  if (is.null(model_input)) {
    model_input <- accept::samplePatients
  }

  # Convert to tibble — required by accept3_cprd and accept functions
  if (!tibble::is_tibble(model_input)) {
    model_input <- tibble::as_tibble(model_input)
  }

  # Validate mandatory columns present
  missing_cols <- setdiff(.mandatory_vars, names(model_input))
  if (length(missing_cols) > 0) {
    stop(paste("Missing required columns:",
               paste(missing_cols, collapse = ", ")))
  }

  accept::accept(newdata = model_input, version = version, country = country)
}

#' Get sample input for ACCEPT
#'
#' @param n Optional. Number of sample patients to return. Default returns all.
#' @return A data frame of sample patients in the format expected by model_run()
#' @export
get_sample_input <- function(n = NULL) {
  data <- accept::samplePatients
  if (!is.null(n)) data <- data[seq_len(n), ]
  data
}

#' Get default input for ACCEPT
#'
#' @return A data frame with one default patient
#' @export
get_default_input <- function() {
  accept::samplePatients[1, ]
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
      example = "echo(model_input = accept::samplePatients)"
    ))
  }

  if ("model_input" %in% names(args)) {
    input <- args$model_input
    return(list(
      success   = TRUE,
      timestamp = as.character(Sys.time()),
      class     = class(input),
      typeof    = typeof(input),
      nrow      = if (is.data.frame(input)) nrow(input) else NULL,
      ncol      = if (is.data.frame(input)) ncol(input) else NULL,
      names     = names(input),
      value     = input
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
