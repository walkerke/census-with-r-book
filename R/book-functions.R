style_data <- function(dat, n_rows = NULL, caption = NULL) {
  
  if (is.null(n_rows)) {
    if (nrow(dat) < 10) {
      n_rows <- nrow(dat)
    } else {
      n_rows <- 10
    }
  }
  
  dat[1:n_rows,] |>
    knitr::kable(caption = caption) |>
    kableExtra::kable_styling()
}

# Set the knitr options
knitr::opts_chunk$set(warning = FALSE, message = FALSE, out.width = "100%")
