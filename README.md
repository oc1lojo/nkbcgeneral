
<!-- README.md är genererad från README.Rmd. Vänligen redigera den filen. -->

nkbcgeneral
===========

[![Build
Status](https://travis-ci.com/oc1lojo/nkbcgeneral.svg?branch=master)](https://travis-ci.com/oc1lojo/nkbcgeneral)
[![Build
status](https://ci.appveyor.com/api/projects/status/6sejow2uewcd5t03/branch/master?svg=true)](https://ci.appveyor.com/project/oc1lojo/nkbcgeneral/branch/master)

Generella verktyg för bearbetning av data från Nationellt
kvalitetsregister för bröstcancer (NKBC).

Detta R-paket är en **central** plats för definition, implementering och
dokumentation av **generell bearbetning** av NKBC-data i **alla**
utdata-kanaler.

-   Användning på INCA tillsammans med R-paketet
    [nkbcind](https://cancercentrum.bitbucket.io/nkbcind)
    -   NKBC onlinerapporter innanför inloggning på INCA med R-paketet
        [rccShiny](https://cancercentrum.bitbucket.io/rccshiny)
        -   <a href="https://bitbucket.org/cancercentrum/nkbc-onlinerapporter/" class="uri">https://bitbucket.org/cancercentrum/nkbc-onlinerapporter/</a>
            (RCC-internt kodförråd)
    -   NKBC Koll på läget (KPL), med R-paketet
        [rccKPL](https://bitbucket.org/cancercentrum/rcckpl)
        -   <a href="https://bitbucket.org/cancercentrum/nkbc-kpl/" class="uri">https://bitbucket.org/cancercentrum/nkbc-kpl/</a>
            (RCC-internt kodförråd)
    -   NKBC Vården i siffror, med R-paketet
        [incavis](https://bitbucket.org/cancercentrum/incavis)
        -   <a href="https://bitbucket.org/cancercentrum/nkbc-vis/" class="uri">https://bitbucket.org/cancercentrum/nkbc-vis/</a>
            (RCC-internt kodförråd)
-   Användning lokalt på RCC Stockholm-Gotland
    -   Framtagande av NKBC Interaktiva Årsrapport med R-paketen
        [nkbcind](https://bitbucket.org/cancercentrum/nkbcind) och
        [rccShiny](https://bitbucket.org/cancercentrum/rccshiny)
        -   <a href="https://bitbucket.org/cancercentrum/nkbc-arsrapportshiny" class="uri">https://bitbucket.org/cancercentrum/nkbc-arsrapportshiny</a>
            (publikt kodförråd)
    -   Datauttagsärenden inom NKBC
        -   jfr
            <a href="https://www.cancercentrum.se/samverkan/vara-uppdrag/kunskapsstyrning/kvalitetsregister/datauttag/" class="uri">https://www.cancercentrum.se/samverkan/vara-uppdrag/kunskapsstyrning/kvalitetsregister/datauttag/</a>
    -   Andra sammanställningar

Jfr
<a href="https://www.cancercentrum.se/samverkan/vara-uppdrag/statistik/kvalitetsregisterstatistik/" class="uri">https://www.cancercentrum.se/samverkan/vara-uppdrag/statistik/kvalitetsregisterstatistik/</a>

Installation
------------

    if (!requireNamespace("remotes")) {
      install.packages("remotes")
    }

    remotes::install_bitbucket("cancercentrum/nkbcgeneral")

Användning
----------

    library(dplyr)
    library(tidyr)
    library(lubridate)
    library(nkbcgeneral) # https://cancercentrum.bitbucket.io/nkbcgeneral/

Läs in ögonblicksbild av NKBC exporterad från INCA.

    load(
      file.path(Sys.getenv("BRCA_DATA_DIR"), "2020-05-04", "nkbc_nat_avid 2020-05-04 10-04-17.RData")
    )

Generell förbearbetning av NKBC-data.

    df_main <- df %>%
      mutate_if(is.factor, as.character) %>%
      rename_all(stringr::str_replace, "_Värde", "_Varde") %>%
      clean_nkbc_data() %>%
      mutate_nkbc_d_vars()
