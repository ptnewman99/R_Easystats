.onAttach <- function(...) {
  easystats_versions <- .easystats_version()
  easystats_pkgs <- c("insight", "bayestestR", "performance", "parameters", "effectsize", "see", "correlation", "modelbased", "report")
  needed <- easystats_pkgs[!is_attached(easystats_pkgs)]

  if (length(needed) == 0)
    return()

  easystats_versions <- easystats_versions[easystats_versions$package %in% needed, ]
  suppressPackageStartupMessages(suppressWarnings(lapply(easystats_versions$package, library, character.only = TRUE, warn.conflicts = FALSE)))

  needs_update <- easystats_versions$behind
  easystats_versions <- easystats_versions[, c("package", "local")]

  max_len_pkg <- max(nchar(easystats_versions$package))
  max_len_ver <- max(nchar(easystats_versions$local))

  insight::print_color("# Attaching packages", "blue")

  if (any(needs_update)) {
    insight::print_color(" (", "blue")
    insight::print_color("red", "red")
    insight::print_color(" = needs update)", "blue")
  }

  cat("\n")

  symbol_tick <- "\u2714 "
  symbol_warning <- "\u26A0 "

  for (i in 1:nrow(easystats_versions)) {
    if (needs_update[i])
      insight::print_color(symbol_warning, "red")
    else
      insight::print_color(symbol_tick, "green")

    cat(format(easystats_versions$package[i], width = max_len_pkg))
    cat(" ")
    insight::print_color(format(easystats_versions$local[i], width = max_len_ver), ifelse(needs_update[i], "red", "green"))

    if (i %% 2 == 0)
      cat("\n")
    else
      cat("   ")
  }

  cat("\n")
  if (.cran_checks()) cat("\n")

  if (any(needs_update)) {
    insight::print_color("Restart the R-Session and update packages in red with 'easystats::easystats_update()'.\n", "yellow")
  }
}

is_attached <- function(x) {
  paste0("package:", x) %in% search()
}
