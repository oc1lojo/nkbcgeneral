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
    )

  # Rensa operationsformulärdata om inte operationsdatum är satt
  x[is.na(x$op_kir_dat), tidyselect::vars_select(names(x), tidyselect::starts_with("op_"))] <- NA

  # Rensa formulärdata om inte pat_sida är vald för formulär
  x[is.na(x$op_pat_sida_Varde), tidyselect::vars_select(names(x), tidyselect::starts_with("op_"))] <- NA
  x[is.na(x$pre_pat_sida_Varde), tidyselect::vars_select(names(x), tidyselect::starts_with("pre_"))] <- NA
  x[is.na(x$post_pat_sida_Varde), tidyselect::vars_select(names(x), tidyselect::starts_with("post_"))] <- NA
  x[is.na(x$r_pat_sida_Varde), tidyselect::vars_select(names(x), tidyselect::starts_with("r_"))] <- NA

  return(x)
}
