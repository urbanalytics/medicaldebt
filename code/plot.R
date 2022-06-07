#!/usr/bin/env Rscript
#
library(ggplot2)
library(magrittr)
library(data.table)
library(gridExtra)

source(file.path(Sys.getenv("HOME"), "tyyq", "social",
                 "medicaldebt", "code", "conf.R"))

casedata <- readODS::read_ods(file.path(DATAROOT, "cases.ods")) %>%
   setDT()
casedata[, amount := as.numeric(gsub("[$,]", "",
                                     `Case Civil Suit Amount`))][
  , `Case Civil Suit Amount` := NULL]


## histogram of suit amount
h1 <- ggplot(casedata) +
   geom_histogram(aes(amount),
                  fill = "skyblue", col="black") +
   labs(x = "Case civil suit amount ($)")
h2 <- h1 +
   scale_x_log10()
p <- grid.arrange(h1, h2, nrow=1)
print(p)
