# Hopper Check Tick Lag Test
# Tests the effect of Paper's hopper-check setting on MSPT
# using 10,000 loaded hoppers.

# -----------------------------
# Raw test data
# -----------------------------

hopper_test <- data.frame(
  run = c(
    "Baseline1",
    "HC1_1", "HC1_2",
    "HC2_1", "HC2_2",
    "HC4_1", "HC4_2",
    "HC8_1", "HC8_2",
    "HC16_1", "HC16_2",
    "ArmorStand1"
  ),
  
  hoppers = c(
    0,
    10000, 10000,
    10000, 10000,
    10000, 10000,
    10000, 10000,
    10000, 10000,
    0
  ),
  
  hopper_check = c(
    NA,
    1, 1,
    2, 2,
    4, 4,
    8, 8,
    16, 16,
    NA
  ),
  
  hopper_transfer = 8,
  
  mspt = c(
    0.435,
    8.172, 5.785,
    3.060592, 3.170968,
    2.830832, 2.380972,
    2.991, 2.5895,
    2.486862, 2.414454,
    6.289167
  ),
  
  stringsAsFactors = FALSE
)

# Save cleaned raw data
write.csv(
  hopper_test,
  "hopper_test.csv",
  row.names = FALSE
)

# -----------------------------
# Hopper-only analysis
# -----------------------------

hopper_only <- subset(
  hopper_test,
  hoppers == 10000
)

avg_data <- aggregate(
  mspt ~ hopper_check,
  data = hopper_only,
  FUN = mean
)

avg_data$percent_reduction_from_HC1 <-
  (avg_data$mspt[1] - avg_data$mspt) /
  avg_data$mspt[1] * 100

avg_data$marginal_improvement <-
  c(NA, -diff(avg_data$mspt))

print(avg_data)

# -----------------------------
# Plot
# -----------------------------


plot(
  avg_data$hopper_check,
  avg_data$mspt,
  type = "b",
  log = "x",
  pch = 19,
  lwd = 2,
  cex = 1.3,
  xaxt = "n",
  xlim = c(0.8, 18),
  ylim = c(0, 8),
  xlab = "Hopper Check Setting",
  ylab = "Average Median MSPT",
  main = "Impact of Hopper-Check Setting on MSPT with 10,000 Hoppers"
)

axis(
  1,
  at = c(1, 2, 4, 8, 16),
  labels = c("1", "2", "4", "8", "16")
)

abline(
  h = 0.435,
  lty = 2,
  lwd = 1.5
)

text(
  avg_data$hopper_check,
  avg_data$mspt,
  labels = round(avg_data$mspt, 2),
  pos = 3,
  cex = 0.9
)

text(
  8,
  0.435,
  "Empty-server baseline = 0.435 MSPT",
  pos = 3,
  cex = 0.85
)
