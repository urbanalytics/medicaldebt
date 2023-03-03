#!/usr/bin/env Rscript

library(tidyverse)
source(file.path(Sys.getenv("HOME"), "tyyq", "social", "medicaldebt", "code", "conf.R"))
source(file.path(CODEDIR, "utils.R"))

## Load data from the original table--a list of all cases where
## Dynamic collectors were involved (?)
cat("Load the original case list\n")
casedata <- readODS::read_ods(file.path(DATAROOT, "cases.ods"))
                           # contains 0-length variable names
names(casedata)[names(casedata) == ""] <- "v"
suppressWarnings(
   casedata <- casedata %>%
      mutate(amount = as.numeric(
                gsub("[$,]", "", `Case Civil Suit Amount`))
             )
   )
cat("  Read", nrow(casedata), "Dynamic Collectors' cases\n")
## Check numbers that did not work:
if(sum(is.na(casedata$amount)) > 0) {
   cat("  Not all suit amounts come out good:\n")
   wrongNumbers <- casedata %>%
      mutate(`row#` = row_number()) %>%
      filter(is.na(amount)) %>%
      select(`row#`, amount, `Case Civil Suit Amount`) %>%
      print()
   cat("\n")
}

## Load extracted data (by Bingbing)
cat("Load extracted (by Bingbing) results:\n")
extractedResults <- read_delim(file.path(
   DATAROOT, "results", "extracted-results.csv.bz2")) %>%
   select(case = `case number`, `principal amount`, `total amount`)
extractedResults <- suppressWarnings(
   extractedResults %>%
   ## convert extracted amounts to numbers.  They are (mostly) in form:
   ## ... $ 1234. ...
   mutate(
      principal = as.numeric(gsub(".*\\$ ?([[:digit:].]+).*", "\\1",
          `principal amount`))) %>%
   mutate(
      total = as.numeric(gsub(".*\\$ ([[:digit:].]+).*", "\\1", `total amount`))
   )
)
cat(" ", nrow(extractedResults), "rows\n")
## Check numbers that did not work:
if((nWrong <- sum(is.na(extractedResults$principal) |
       is.na(extractedResults$total))) > 0) {
   cat(" ", nWrong, "money amounts did not come out good",
       "\n  sample of such cases:\n")
   extractedResults %>%
      mutate(`row#` = row_number()) %>%
      filter(is.na(principal) | is.na(total)) %>%
      select(`row#`,
             principal, `principal amount`,
             total, `total amount`) %>%
      sample_n(min(5, n())) %>%
      print()
   cat("\n")
}
extactedResults <- extractedResults %>%
   select(!c(`principal amount`, `total amount`))

## Load validation data (Zoe's data)
validationResults <- read_delim(
   file.path(DATAROOT, "results", "validation-results.csv.bz2"),
   header=TRUE) %>%
   rename(case = V1, medica = `Medical debt? (Yes/No)`)
validationAmounts <- validationResults %>%
   filter(tolower(medical) == "yes") %>%
   select(case, medical, `Judgment Amount`, `Principal Amount`) %>%
   ## in case of judgement amount: comma separated list, retain the largest value
   ## only
   mutate(total = gsub(" +", "", `Judgment Amount`) %>%
             strsplit(",") %>%
             sapply(function(x) max(as.numeric(x)))
          ) %>%
   mutate(total = ifelse(total < 0, NA, total)) %>%
   mutate(
      principal = as.numeric(gsub(" +", "", `Principal Amount`))
   ) %>%
   select(!c(medical, `Judgment Amount`, `Principal Amount`))
## How many rows in validation data?  It is a bit tricky because all
## case numbers are filled out..
nValidation <- summarize(validationResults,
                         n = sum(medical != "" | Provider != "" | Name != "")
                         ) %>%
   pull(n)

