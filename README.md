
<!-- README.md är genererad från README.Rmd. Vänligen redigera den filen. -->

# nkbcgeneral

[![Build
Status](https://travis-ci.org/oc1lojo/nkbcgeneral.svg?branch=master)](https://travis-ci.org/oc1lojo/nkbcgeneral)
[![Build
status](https://ci.appveyor.com/api/projects/status/6sejow2uewcd5t03/branch/master?svg=true)](https://ci.appveyor.com/project/oc1lojo/nkbcgeneral/branch/master)

Planen är att lägga generella verktyg för bearbetning av NKBC-data här.

Visionen är att detta R-paket kommer vara en **central** plats för
definition, implementering och dokumentation av generell bearbetning av
NKBC-data i **alla** utdata-kanaler.

  - Planerad använding på INCA
      - NKBC Koll på läget (KPL), med R-paketet
        [rccKPL](https://bitbucket.org/cancercentrum/rcckpl)
      - NKBC Vården i siffror, med R-paketet
        [incavis](https://bitbucket.org/cancercentrum/incavis)
      - NKBC onlinerapporter innanför inloggning på INCA (snart med
        R-paketet
        [rccShiny](https://bitbucket.org/cancercentrum/rccshiny))
  - Planerad använding lokalt på RCC Stockholm-Gotland
      - Framtagande av NKBC Interaktiva Årsrapport med R-paketet
        [rccShiny](https://bitbucket.org/cancercentrum/rccshiny)
          - <https://bitbucket.org/cancercentrum/nkbc-arsrapportshiny>
      - Datauttagsärenden inom NKBC
          - jfr
            <https://www.cancercentrum.se/samverkan/vara-uppdrag/kunskapsstyrning/kvalitetsregister/datauttag/>
      - Andra sammanställningar

Jfr
<https://www.cancercentrum.se/samverkan/vara-uppdrag/statistik/kvalitetsregisterstatistik/>

## Installation

``` r
if (!requireNamespace("remotes"))
  install.packages("remotes")

remotes::install_bitbucket("cancercentrum/nkbcgeneral")
```

## Användning

``` r
library(dplyr)
library(tidyr)
library(lubridate)
library(nkbcgeneral)
```

Läs in ögonblickskopia av NKBC exporterad från INCA.

``` r
load(
  unzip(
    file.path(Sys.getenv("BRCA_DATA_DIR"), "2019-09-02", "nkbc_nat_id 2019-09-02 09-02-35.zip"),
    exdir = tempdir()
  )
)
```

Generell förbearbetning av NKBC-data.

``` r
df_main <- df %>%
  mutate_if(is.factor, as.character) %>%
  rename_all(stringr::str_replace, "_Värde", "_Varde") %>%
  clean_nkbc_data() %>%
  mutate_nkbc_d_vars()
```
