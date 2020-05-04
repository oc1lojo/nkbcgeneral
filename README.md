
<!-- README.md är genererad från README.Rmd. Vänligen redigera den filen. -->

# nkbcgeneral

[![Build
Status](https://travis-ci.org/oc1lojo/nkbcgeneral.svg?branch=master)](https://travis-ci.org/oc1lojo/nkbcgeneral)
[![Build
status](https://ci.appveyor.com/api/projects/status/6sejow2uewcd5t03/branch/master?svg=true)](https://ci.appveyor.com/project/oc1lojo/nkbcgeneral/branch/master)

Generella verktyg för bearbetning av data från Nationellt
kvalitetsregister för bröstcancer (NKBC).

Detta R-paket är en **central** plats för definition, implementering och
dokumentation av **generell bearbetning** av NKBC-data i **alla**
utdata-kanaler.

  - Användning på INCA tillsammans med R-paketet
    [nkbcind](https://bitbucket.org/cancercentrum/nkbcind)
      - NKBC onlinerapporter innanför inloggning på INCA med R-paketet
        [rccShiny](https://bitbucket.org/cancercentrum/rccshiny)
          - <https://bitbucket.org/cancercentrum/nkbc-onlinerapporter/>
            (RCC-internt kodförråd)
      - NKBC Koll på läget (KPL), med R-paketet
        [rccKPL](https://bitbucket.org/cancercentrum/rcckpl)
          - <https://bitbucket.org/cancercentrum/nkbc-kpl/> (RCC-internt
            kodförråd)
      - NKBC Vården i siffror, med R-paketet
        [incavis](https://bitbucket.org/cancercentrum/incavis)
          - <https://bitbucket.org/cancercentrum/nkbc-vis/> (RCC-internt
            kodförråd)
  - Användning lokalt på RCC Stockholm-Gotland
      - Framtagande av NKBC Interaktiva Årsrapport med R-paketen
        [nkbcind](https://bitbucket.org/cancercentrum/nkbcind) och
        [rccShiny](https://bitbucket.org/cancercentrum/rccshiny)
          - <https://bitbucket.org/cancercentrum/nkbc-arsrapportshiny>
            (publikt kodförråd)
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
library(nkbcgeneral) # https://cancercentrum.bitbucket.io/nkbcgeneral/
```

Läs in ögonblicksbild av NKBC exporterad från INCA.

``` r
load(
  file.path(Sys.getenv("BRCA_DATA_DIR"), "2020-05-04", "nkbc_nat_avid 2020-05-04 10-04-17.RData")
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
