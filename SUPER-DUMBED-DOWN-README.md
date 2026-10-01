## Simple Explanation

Okay guys, I know the other README is super complicated and "verbose," so lemme break it down.

Basically, I hosted a creative Minecraft server and tested how much lag 10,000 unlocked hoppers caused.

I first measured the server with no hoppers as a baseline. Then I loaded 10,000 hoppers and tested different `hopper-check` settings: 1, 2, 4, 8, and 16.

`hopper-check` controls how often hoppers check for items. A setting of 1 means they check every tick, while a setting of 8 means they only check every 8 ticks.

The server I normally play on uses `hopper-check = 8` to reduce lag. The downside is that a setting that high can interfere with multi-item sorters and other more complicated redstone machines that depend on hoppers checking frequently.

So the whole point of this test was to see if we could lower the setting and get more vanilla-like hopper behavior without causing a huge increase in lag.

The biggest performance improvement happened between `hopper-check = 1` and `hopper-check = 2`. After that, the improvements got much smaller.

Based on these tests, `hopper-check = 2` looks like a pretty good middle ground. It keeps hopper behavior much closer to vanilla while still cutting a large amount of the hopper-related lag compared with a setting of 1.

Basically: setting it to 8 helps performance, but my testing suggests you may not need to go that high to get most of the benefit.
