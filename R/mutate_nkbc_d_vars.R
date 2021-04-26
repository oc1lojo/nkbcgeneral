#' @export
mutate_nkbc_d_vars <- function(x, ...) {
  dplyr::mutate(x,
    # Primär behandling
    # - 1: Primär operation
    # - 2: Preoperativ onkologisk behandling eller konservativ behandling
    # - 3: Ej operation eller fjärrmetastas/-er vid diagnos
    d_prim_beh_Varde = dplyr::coalesce(op_kir_Varde, a_planbeh_typ_Varde),

    # Invasivitet
    # - 1: Invasiv cancer
    # - 2: Enbart cancer in situ
    d_invasiv_Varde = dplyr::case_when(
      a_pad_invasiv_Varde %in% 1 | op_pad_invasiv_Varde %in% 1 ~ 1L,
      a_pad_invasiv_Varde %in% 2 | op_pad_invasiv_Varde %in% 2 ~ 2L,
      TRUE ~ NA_integer_
    ),

    # ER-status
    # - 1: Positiv
    # - 2: Negativ
    d_er_op_Varde = dplyr::case_when(
      op_pad_erproc < 10 | is.na(op_pad_erproc) & op_pad_er_Varde %in% 2 ~ 2L,
      op_pad_erproc >= 10 | is.na(op_pad_erproc) & op_pad_er_Varde %in% 1 ~ 1L
    ),
    d_er_a_Varde = dplyr::case_when(
      a_pad_erproc < 10 | is.na(a_pad_erproc) & a_pad_er_Varde %in% 2 ~ 2L,
      a_pad_erproc >= 10 | is.na(a_pad_erproc) & a_pad_er_Varde %in% 1 ~ 1L
    ),
    d_er_Varde = dplyr::case_when(
      d_invasiv_Varde == 1 & d_prim_beh_Varde == 1 ~ d_er_op_Varde,
      d_invasiv_Varde == 1 & d_prim_beh_Varde %in% c(2, 3) ~ d_er_a_Varde,
      TRUE ~ NA_integer_
    ),

    # PgR-status
    # - 1: Positiv
    # - 2: Negativ
    d_pr_op_Varde = dplyr::case_when(
      op_pad_prproc < 10 | is.na(op_pad_prproc) & op_pad_pr_Varde %in% 2 ~ 2L,
      op_pad_prproc >= 10 | is.na(op_pad_prproc) & op_pad_pr_Varde %in% 1 ~ 1L
    ),
    d_pr_a_Varde = dplyr::case_when(
      a_pad_prproc < 10 | is.na(a_pad_prproc) & a_pad_pr_Varde %in% 2 ~ 2L,
      a_pad_prproc >= 10 | is.na(a_pad_prproc) & a_pad_pr_Varde %in% 1 ~ 1L
    ),
    d_pr_Varde = dplyr::case_when(
      d_invasiv_Varde == 1 & d_prim_beh_Varde == 1 ~ d_pr_op_Varde,
      d_invasiv_Varde == 1 & d_prim_beh_Varde %in% c(2, 3) ~ d_pr_a_Varde,
      TRUE ~ NA_integer_
    ),

    # HER2-status
    # - 1: Positiv
    # - 2: Negativ
    d_her2_op_Varde = dplyr::case_when(
      op_pad_her2_Varde %in% 3 | op_pad_her2ish_Varde %in% 1 ~ 1L,
      op_pad_her2_Varde %in% c(1, 2) | op_pad_her2ish_Varde %in% 2 ~ 2L
    ),
    d_her2_a_Varde = dplyr::case_when(
      a_pad_her2_Varde %in% 3 | a_pad_her2ish_Varde %in% 1 ~ 1L,
      a_pad_her2_Varde %in% c(1, 2) | a_pad_her2ish_Varde %in% 2 ~ 2L
    ),
    d_her2_Varde = dplyr::case_when(
      d_invasiv_Varde == 1 & d_prim_beh_Varde == 1 ~ d_her2_op_Varde,
      d_invasiv_Varde == 1 & d_prim_beh_Varde %in% c(2, 3) ~ d_her2_a_Varde,
      TRUE ~ NA_integer_
    ),

    # Biologisk subtyp
    # Jfr https://bitbucket.org/cancercentrum/nkbcind/src/master/R/nkbc-pop-subtyp-09d.R
    # -  1: Luminal
    # -  2: HER2
    # -  3: TNBC
    d_trigrp_Varde = dplyr::case_when(
      d_er_Varde %in% 2 & d_pr_Varde %in% 2 & d_her2_Varde %in% 2 ~ 3L,
      is.na(d_er_Varde) | is.na(d_pr_Varde) | is.na(d_her2_Varde) ~ NA_integer_,
      d_her2_Varde %in% 1 ~ 2L,
      d_er_Varde %in% 1 | d_pr_Varde %in% 1 ~ 1L,
      TRUE ~ NA_integer_
    )
  )
}
