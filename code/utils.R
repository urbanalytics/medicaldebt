
## 80/20 ratio: compute the top percentile t that
## owns the share of 1-t in numeric vector x
r80.20 <- function(x) {
   ## share of top t quantile
   st <- function(t, x) {
      sum(x[x > quantile(x, 1-t, na.rm=TRUE)], na.rm=TRUE)/sum(x, na.rm=TRUE)
   }
   diff <- function(t, x) {
      1 - t - st(t, x)
   }
   uniroot(diff, c(0, 1), x=x)$root
}
