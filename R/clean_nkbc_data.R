#' @export
clean_nkbc_data <- function(x, ...) {
  x <- x %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("_Varde")), as.integer) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("sjhkod")), as.integer) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("dat", ignore.case = FALSE)), lubridate::ymd) %>%
    dplyr::mutate_if(
      is.character,
      # städa fritext-variabler från specialtecken
      function(y) gsub("[[:space:]]", " ", y)
    )

  if ("VITALSTATUSDATUM_ESTIMAT" %in% names(x)) {
    x <- x %>%
      dplyr::mutate(
        VITALSTATUSDATUM_ESTIMAT = lubridate::ymd(VITALSTATUSDATUM_ESTIMAT)
      )
  }

  # Kräv att diagnosdatum är satt
  if ("a_diag_dat" %in% names(x)) {
    x <- dplyr::filter(x, !is.na(a_diag_dat))
  }

  # Rensa ev. rena dubbletter
  if ("R44T139_ID" %in% names(x)) {
    x <- dplyr::distinct(x)
  }

  # Rensa operationsformulärdata om inte operationsdatum är satt
  if ("op_kir_dat" %in% names(x)) {
    x[is.na(x$op_kir_dat), tidyselect::vars_select(names(x), tidyselect::starts_with("op_"))] <- NA
  }

  # Rensa formulärdata om inte pat_sida är vald för formulär
  if ("op_pat_sida_Varde" %in% names(x)) {
    x[is.na(x$op_pat_sida_Varde), tidyselect::vars_select(names(x), tidyselect::starts_with("op_"))] <- NA
  }
  if ("pre_pat_sida_Varde" %in% names(x)) {
    x[is.na(x$pre_pat_sida_Varde), tidyselect::vars_select(names(x), tidyselect::starts_with("pre_"))] <- NA
  }
  if ("post_pat_sida_Varde" %in% names(x)) {
    x[is.na(x$post_pat_sida_Varde), tidyselect::vars_select(names(x), tidyselect::starts_with("post_"))] <- NA
  }
  if ("r_pat_sida_Varde" %in% names(x)) {
    x[is.na(x$r_pat_sida_Varde), tidyselect::vars_select(names(x), tidyselect::starts_with("r_"))] <- NA
  }

  # Korrigera värden
  if ("op_pad_lglmetant" %in% names(x)) {
    if (!("op_pad_lglusant" %in% names(x))) {
      stop("För att korrigera op_pad_lglmetant behöver op_pad_lglusant vara med.")
    } else {
      x <- x %>%
        dplyr::mutate(
          # Kräv att totalt antal undersökta lymfkörtlar från samtliga axillingrepp (op_pad_lglusant) > 0
          # för att totalt antal lymfkörtlar med metastas från samtliga axillingrepp (op_pad_lglmetant) skall ha ett värde
          op_pad_lglmetant = dplyr::if_else(op_pad_lglusant > 0, op_pad_lglmetant, NA_integer_)
        )
    }
  }

  return(x)
}
