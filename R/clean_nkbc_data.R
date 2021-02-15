#' @export
clean_nkbc_data <- function(x, ...) {
  x <- x %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("_Varde")), as.integer) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::ends_with("sjhkod")), as.integer) %>%
    dplyr::mutate_if(
      is.character,
      # städa fritext-variabler från specialtecken
      function(y) gsub("[[:space:]]", " ", y)
    ) %>%
    dplyr::filter(
      # Kräv diagnosdatum
      !is.na(a_diag_dat)
    ) %>%
    # Rensa ev. rena dubbletter
    dplyr::distinct()

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

  return(x)
}
