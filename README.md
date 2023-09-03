# AdventOfCode2016
 Code solutions for Advent of Code 2016

## Why

Because it's there. I started [AoC](https://adventofcode.com) in 2020, and that means there's multiple years before that to do whenever. Must. Get. All. The. Stars.

## Plan

No real plan, but I've picked up BBEdit and Perl 5.36 again. I think there's an argument to be made to try the new class syntax in 5.38, but at the moment, I'm still going with the traditional approach. Well, traditional with signatures. Modern::Perl 2022. I've refactored my AOC::SpatialUtil into AOC::Geometry and AOC::Grid, separating out the basics of 1D, 2D, and 3D geometry from the Grid2D and Grid3D. There are times when I want to work with ranges, points and extents but don't need a grid for them.

## So Far

I've done six days. No problems so far. Day 6 was particularly well-suited to Perl, IMO. Surprising that Day 1 jumped right into a solution that needed 2D geometry and a grid.

## Halfway

Days 12 and 13 were refreshing. Day 11 was a tough one and slow to compute. Whenever the solutions are depth-first searches of large spaces, my solutions are competent but not fast. Day 12 was interesting because a factor in the speed of my solution was Perl's slowness in calling subroutines. Apparently millions of calls to a function added 2 seconds. I flattened the code (literally pasting the function code into the caller) and gained 2 seconds. But I deleted the change b/c who wants ugly code? (says the guy writing in Perl)

There have been times (esp. Day 11) that I wished for an interactive debugger, but I've made it so far with just selective printing out to the console. BBEdit is great now that the language server is working, but autocomplete without signatures means I'm opening up my AOC modules to read the code all the time.

## Adding Objective-C

Not sure why I got the urge to change it up, but it happened. Maybe it's because I want to solve 2023 as far down the [AoC Survey Results](https://jeroenheijmans.github.io/advent-of-code-surveys/#) as I can. Last year, 39 people solved with some variant of Perl (including Raku), but only 2 with ObjC, the same as Pascal. I don't see any language lower on the list that I would even want to do.

I had the libraries from doing 2017 all ready to go, so I set ObjC up for 2016. The language is different enough that even re-doing Day 1 was a challenge. But already with Day 2 it's becoming easier.

## Finished

Another 50 ⭐️ added to my account! I finished out this year's challenges in Objective C. There were no real issues with using the language, excepting that every once in a while something that should be a one-liner takes more (sometimes much more). My AOC libraries continue to grow, providing the one-liner option for things that come up frequently.

One major note: this is the first year where I did not have to reference another person's solution. Usually there is one problem that is esoteric math where I can't figure out a solution that will finish in a reasonable time. I did have a couple of interesting ones, though:

- Day 11: I used a DFS to try to find the solution, and spent hours slowly ratcheting down the constraint on what the answer _might_ be. That constraint made the code run in reasonable time, but even so, the heuristic was sensitive to random order of the data.
- Day 22: Once I'd mapped out the grid of compute nodes, it was clear that the answer was actually doable with pen and paper. I could have written an algorithm to solve part 2, but instead I let the user control the movement of data interactively. In short, a text-based video game shifting data across the grid. It's dumb, but it worked.
- Day 23: This one was the one that typically stumps me: following the instructions literally solved part one, but then would not solve part two in a reasonable amount of time. I happened to figure out what the mathematical pattern was, which is not the usual for me.
