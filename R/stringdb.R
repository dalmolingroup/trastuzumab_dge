# Get interaction network from STRINGdb
get_string_network <-
  function(ids,
           species = "9606",
           required_score = 0) {
    ids_collapsed <- paste0(ids, collapse = "%0d")

    jsonlite::fromJSON(
      RCurl::postForm(
        "https://string-db.org/api/json/network",
        identifiers = ids_collapsed,
        echo_query  = "1",
        required_score = as.character(required_score),
        species = species
      ),
    )
  }

# Get identifiers from STRINGdb
get_string_ids <- function(ids, species = "9606") {
  ids_collapsed <- paste0(ids, collapse = "%0d")

  jsonlite::fromJSON(
    RCurl::postForm(
      "https://string-db.org/api/json/get_string_ids",
      identifiers = ids_collapsed,
      echo_query  = "1",
      species = species
    ),
  )
}

# Function to combine scores according to the STRINGdb algorithm
combinescores <- function(dat,
                          evidences = "all",
                          confLevel = 0.4) {
  if (evidences[1] == "all") {
    edat <- dat[, -c(1, 2, ncol(dat))]
  } else {
    if (!all(evidences %in% colnames(dat))) {
      stop("NOTE: one or more 'evidences' not listed in 'dat' colnames!")
    }
    edat <- dat[, evidences]
  }
  if (any(edat > 1)) {
    edat <- edat / 1000
  }
  edat <- 1 - edat
  sc <- apply(
    X = edat,
    MARGIN = 1,
    FUN = function(x)
      1 - prod(x)
  )
  dat <- cbind(dat[, c(1, 2)], combined_score = sc)
  idx <- dat$combined_score >= confLevel
  dat <- dat[idx, ]
  return(dat)
}
