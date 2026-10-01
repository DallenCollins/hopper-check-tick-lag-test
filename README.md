# Hopper Check Tick Lag Test

I wanted to figure out how much Paper's `hopper-check` setting actually affects server lag, and whether a lower setting could still perform well enough without messing with hopper-based redstone as much.

The server I normally play on uses `hopper-check = 8` to reduce lag. The problem is that a setting that high can interfere with multi-item sorters and other more complicated redstone machines that rely on hoppers checking for items frequently.

So I made a controlled test server and tested it myself.

## Simple Explanation

Basically, I hosted a creative Minecraft server, measured how laggy it was by itself, then filled the loaded area with 10,000 unlocked hoppers and measured it again.

After that, I changed `hopper-check` to:

- 1
- 2
- 4
- 8
- 16

and tested each setting.

A tick is basically one update of the Minecraft server. Minecraft normally runs at 20 ticks per second.

So:

- `hopper-check = 1` means hoppers check every tick
- `hopper-check = 2` means every 2 ticks
- `hopper-check = 8` means every 8 ticks

The idea was to find a balance between less lag and keeping hopper behavior closer to vanilla.

## What I Found

The biggest improvement happened when changing `hopper-check` from 1 to 2.

Going from 1 to 2 reduced average median MSPT by about **55%**.

After that, the improvements got much smaller. Settings 4, 8, and 16 all ended up in roughly the same performance range.

Based on this test, `hopper-check = 2` looks like a pretty good middle ground.

It keeps hopper behavior much closer to vanilla while still getting most of the performance improvement.

Basically: setting it to 8 does help performance, but these tests suggest you may not need to go that high.

## Benchmark Graph

![Hopper Check vs MSPT](HopperLagGraph.png)

Lower MSPT is better.

MSPT means **milliseconds per tick**, which is basically how long the server takes to process one game tick.

## Results

| Hopper Check | Average Median MSPT | MSPT Reduction vs HC1 |
|---|---:|---:|
| 1 | 6.9785 | 0% |
| 2 | 3.1158 | 55.35% |
| 4 | 2.6059 | 62.66% |
| 8 | 2.7903 | 60.02% |
| 16 | 2.4507 | 64.88% |

**Empty-server baseline:** 0.435 MSPT

## Test Setup

- Paper test server
- 10,000 loaded, unlocked hoppers
- 289 loaded chunks
- 1 player
- `hopper-transfer = 8`
- Each test ran for about 60 seconds
- MSPT measured with Spark
- Two runs were performed for each `hopper-check` setting

## Test Method

First, I measured the server with no hoppers loaded to get a baseline.

Then I loaded 10,000 hoppers and ran Spark profiler tests at each `hopper-check` setting.

Each test ran for about 60 seconds.

Two runs were performed for each setting, and the median MSPT from the two runs was averaged for comparison.

The tested settings were:

`1, 2, 4, 8, 16`

## Notes and Limitations

This was a small controlled benchmark, not a full production-server performance study.

Only two runs were performed for each setting, and HC1 showed more variation between runs than the higher settings.

The exact improvement on a live server will depend on things like hopper count, loaded chunks, entities, plugins, redstone activity, and other server load.

Because of that, the main takeaway is not that HC2 is always better than HC8 in every situation.

The takeaway is that, in this test, most of the performance improvement happened immediately between HC1 and HC2, while increasing the setting further produced much smaller gains.

## Raw Data and Analysis

The repository includes:

- `hopper_test.csv` — recorded benchmark data
- `Hopper_Lag_test.R` — R analysis and graphing code
- `spark-profiles/` — raw Spark profiler files
- `HopperLagGraph.png` — benchmark graph

All raw Spark profiles, the CSV data, and the R analysis used to generate these results are included so the test can be checked or reproduced.

## Viewing the Spark Profiles

The `.sparkprofile` files are meant to be viewed with the Spark web viewer.

Download a profile from the `spark-profiles` folder and upload it here:

https://spark.lucko.me/

That will open the full interactive Spark profiler report.
