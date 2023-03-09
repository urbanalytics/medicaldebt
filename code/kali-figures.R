#!/usr/bin/env Rscript
### 
### Total & principal histograms: Can you create matching histograms for total
### and principal, starting at $200 and going up to $15,000, with as many $
### groups as possible ($200, $500, $750, $1000, etc.)? I think the “skinny”
### histogram bars make it easier to read/more helpful.
### 
### Does that make sense? Sorry I’m not a better statistician!!
### 
### If you send me the CSV file and the R code you’ve been using I can probably
### tinker with it and get what I’m looking for.


library(tidyverse, quietly=TRUE)
source(file.path(Sys.getenv("HOME"), "tyyq", "social", "medicaldebt", "code", "conf.R"))
source(file.path(CODEDIR, "utils.R"))
options(readr.show_col_types = FALSE)
figuredir <- file.path(PROJECTDIR, "figures")

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
      sample_n(min(4, n())) %>%
      print()
   cat("\n")
}
extactedResults <- extractedResults %>%
   select(!c(`principal amount`, `total amount`))

## Load validation data (Zoe's data)
cat("Load validation (by Zoe) results:\n")
validationResults <- read_delim(
   file.path(DATAROOT, "results", "validation-results.csv.bz2")
                           # no good name for 1st column
                           # comes out as `...1`
) %>%
   rename(
      case = `...1`,
      medical = `Medical debt? (Yes/No)`
   )
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
nValidation <- summarize(
   validationResults,
   n = sum(!is.na(medical) | !is.na(Provider) | !is.na(Name))
) %>%
   pull(n)
cat(nValidation, "filled-out validation cases\n")

## ---------- plots ----------
## Principal-total
lim <- c(0, 2500)
cat("\nTotal vs principal, full")
p <- ggplot(extractedResults, aes(principal, total)) +
   geom_point(size=0.5, alpha=0.5,
              na.rm=TRUE) +
   geom_abline(slope=1, col="gray") +
   labs(x="Principal amount", y="Total amount")
ggsave(file.path(figuredir, "principal-total-full.pdf"), p,
       width=150, height=120, units="mm")
cat("\nTotal vs principal, detail")
p <- p +
   coord_cartesian(xlim = lim, ylim = lim)
ggsave(file.path(figuredir, "principal-total-detail.pdf"), p,
       width=150, height=120, units="mm")
## ---------- total/principal histograms ----------
cat("\nTotal/principal histograms")
## make new combined dataset
hdata <- rbind(
   data.frame(
      principal = extractedResults$principal,
      total = extractedResults$total,
      source = "Extracted"),
   data.frame(
      principal = validationAmounts$principal,
      total = validationAmounts$total,
      source = "Validated"))
lim <- c(170, 2.1e4)
bins <- 10
theme <- theme(axis.title.y = element_blank(),
         axis.text.y = element_blank(),
         axis.ticks.y = element_blank())
h1 <- ggplot(
   hdata,
   aes(principal, y = ..density.., fill=source)
) +
   geom_histogram(
      position = "dodge",
      col="black",
      bins=bins, na.rm=TRUE
   ) +
   guides(fill = "none") +
   labs(x = "Case civil suit amount ($)", title="Principal") +
   coord_cartesian(xlim=lim) +
   theme
h2 <- ggplot(
   hdata,
   aes(total, y = ..density.., fill=source)
) +
   geom_histogram(
      position = "dodge",
      col="black",
      bins=bins
   ) +
   guides(fill = "none") +
   labs(x = "Case civil suit amount ($)", title="Total") +
   coord_cartesian(xlim=lim) +
   theme
p <- gridExtra::grid.arrange(h1, h2, nrow=1)
ggsave(
   file.path(figuredir, "principal-total-histogram.pdf"), p,
   width=150, height=120, units="mm")
cat("\nPrincipal/total histogram log")
h1 <- h1 +
   scale_x_log10()
h2 <- h2 +
   scale_x_log10()
p <- gridExtra::grid.arrange(h1, h2, nrow=1)
ggsave(
   file.path(figuredir, "principal-total-histogram-log.pdf"), p,
   width=150, height=120, units="mm")
##
cat("\nAll done\n")
