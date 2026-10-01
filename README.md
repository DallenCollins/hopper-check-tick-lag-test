# Hopper Check Tick Lag Test

Testing how Paper's `hopper-check` setting affects server MSPT and hopper-related tick lag using 10,000 loaded hoppers.

## Test Setup

- Paper test server
- 10,000 loaded hoppers
- 289 loaded chunks
- 1 player
- `hopper-transfer = 8`
- Each test ran for about 60 seconds
- MSPT measured with Spark
- Two runs were performed for each hopper-check setting

## Results

| Hopper Check | Average Median MSPT | Reduction vs HC1 |
|---|---:|---:|
| 1 | 6.9785 | 0% |
| 2 | 3.1158 | 55.35% |
| 4 | 2.6059 | 62.66% |
| 8 | 2.7903 | 60.02% |
| 16 | 2.4507 | 64.88% |

## Benchmark Graph

![Hopper Check vs MSPT](HopperLagGraph.png)

**Empty-server baseline:** 0.435 MSPT

## Main Finding

The largest improvement occurred when `hopper-check` was increased from 1 to 2.

HC2 reduced average median MSPT by about 55% compared with HC1.

Increasing `hopper-check` beyond 4 produced much smaller improvements, with HC4, HC8, and HC16 all testing in roughly the same performance range.

This suggests strong diminishing returns after approximately HC2-HC4.

## Notes

The test used two runs per setting, so the data should be treated as a small benchmark rather than a definitive performance study.

HC1 also showed more run-to-run variation than the higher hopper-check settings.
