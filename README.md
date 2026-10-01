# Hopper Check Tick Lag Test

I wanted to find out how much Paper's `hopper-check` setting actually affects server lag, and whether a lower setting could still perform well without interfering with hopper-based redstone as much.

The server I normally play on uses `hopper-check = 8` to reduce lag. The downside is that a setting that high can interfere with multi-item sorters and other more complicated redstone machines that rely on hoppers checking for items frequently.

So I made a controlled creative test server and tested it myself.

## TL;DR

In this test, changing `hopper-check` from 1 to 2 cut average median MSPT by about 55%.

Going higher than 2 gave much smaller additional improvements, so HC2 looked like a good balance between performance and keeping hopper behavior closer to vanilla.

## Simple Explanation

Basically, I measured how laggy the server was by itself, then filled the loaded area with 10,000 unlocked hoppers and measured it again.

After that, I tested different `hopper-check` settings:

- 1
- 2
- 4
- 8
- 16

`hopper-check` is a setting in the server's `spigot.yml` config that controls how often hoppers check for items they can pick up.

This includes checking for item entities sitting on top of the hopper and checking inventories of connected containers.

A tick is basically one update of the Minecraft server. Minecraft normally runs at 20 ticks per second.

So:

- `hopper-check = 1` means hoppers check every tick
- `hopper-check = 2` means every 2 ticks
- `hopper-check = 4` means every 4 ticks
- `hopper-check = 8` means every 8 ticks
- `hopper-check = 16` means every 16 ticks

Lower values keep hopper behavior closer to vanilla.

Higher values reduce how often the server has to perform hopper checks, which can reduce server load.

The point of the test was to find a good balance between server performance and normal hopper/redstone behavior.

If you still don't get it, or you don't play minecraft there is a more simplified version at the bottom of the README

## What I Found

The biggest improvement happened when changing `hopper-check` from 1 to 2.

Going from 1 to 2 reduced average median MSPT by about **55%**.

After that, the improvements became much smaller.

HC4, HC8, and HC16 all tested in roughly the same performance range.

Based on this test, `hopper-check = 2` looks like a good middle ground.

It keeps hopper behavior much closer to vanilla while still getting most of the performance improvement.

Basically: setting it to 8 does help performance, but these tests suggest you may not need to go that high.

## Benchmark Graph

![Hopper Check vs MSPT](HopperLagGraph.png)

Lower MSPT is better.

MSPT means **milliseconds per tick**, which is how long the server takes to process one game tick.

The slight increase from HC4 to HC8 is probably normal run-to-run variation and should not be taken as evidence that HC8 is inherently slower than HC4.

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

- Minecraft version: 26.1.2
- Paper version: 26.1.2-74
- Creative mode
- 10,000 loaded, unlocked hoppers
- 289 loaded chunks
- 1 player
- `hopper-transfer = 8`
- Each test ran for about 60 seconds
- MSPT measured with Spark
- Two runs were performed for each `hopper-check` setting

## Test Method

The same general setup was used for each test.

1. Start or restart the server.
2. Allow the server to stabilize.
3. Keep the same test area and loaded chunks.
4. Load 10,000 unlocked hoppers for the hopper tests.
5. Set `hopper-check` to the value being tested.
6. Run the Spark profiler for approximately 60 seconds.
7. Record the median MSPT.
8. Repeat the test a second time.
9. Average the median MSPT values from the two runs.

The settings tested were:

`1, 2, 4, 8, 16`

A separate empty-server baseline was also recorded.

## Why This Matters

Lower `hopper-check` values preserve more normal hopper behavior and are more compatible with timing-sensitive redstone.

Higher values reduce how frequently the server checks hoppers, which can reduce server load.

The goal was not just to find the setting with the lowest MSPT possible.

The goal of this test was to find the lowest `hopper-check` value that still provided a meaningful performance improvement while preserving as much normal hopper behavior as possible.

## Notes and Limitations

This was a small controlled benchmark, not a full production-server performance study.

Only two runs were performed for each setting.

HC1 also showed noticeably more variation between runs than the higher settings.

The exact performance difference on a live server will depend on things such as:

- number of loaded hoppers
- loaded chunks
- entities
- redstone activity
- plugins
- player count
- other server load

Because of this, the results should not be interpreted as saying HC2 will always be the best setting for every server.

The main result is that, in this test, most of the performance improvement happened immediately between HC1 and HC2, while increasing the setting further gave much smaller additional gains.

## Raw Data and Analysis

This repository includes:

- `hopper_test.csv` — recorded benchmark data
- `Hopper_Lag_test.R` — R analysis and graphing code
- `spark-profiles/` — raw Spark profiler files
- `HopperLagGraph.png` — benchmark graph

All raw Spark profiles, the CSV data, and the R analysis used to generate the results are included so the test can be checked or reproduced.

## Viewing the Spark Profiles

The `.sparkprofile` files are meant to be opened with the Spark web viewer.

Download one of the `.sparkprofile` files from the `spark-profiles` folder and upload it to:

https://spark.lucko.me/

That will open the full interactive Spark profiler report.

## Super dumbed-down version for people who don't play Minecraft

Imagine you're a little kid who really loves ice cream, and you want to eat it all the time. But your mom has a rule: you can only have ice cream once every eight days because she thinks eating it more often would be too unhealthy.

Instead of just accepting that eight days is the right number, you decide to actually test it. You compare what happens if you eat ice cream every 8 days, 6 days, 4 days, 2 days, and so on, and measure the health effects of each one.

Then you graph the results to look for the **sweet spot**: the point where you can have ice cream much more often without your health getting significantly worse.

Maybe eating ice cream every 2 days turns out to be almost as healthy as eating it every 8 days. If that's the case, then the 8-day rule may be much more restrictive than it actually needs to be.

Now translate that back to Minecraft:

- Instead of days, we're talking about **1/20ths of a second**, also called game ticks.
- Instead of ice cream, it's a **hopper**.
- Instead of eating the ice cream, the hopper is **checking inventories to see if there are items it can pull**.
- Instead of my mom making the rule, it's **the person who owns the server
