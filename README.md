# AdventOfCode2016
 Code solutions for Advent of Code 2016

## Why

Because it's there. I started [AoC](https://adventofcode.com) in 2020, and that means there's multiple years before that to do whenever. Must. Get. All. The. Stars.

## Plan

No real plan, but I've picked up BBEdit and Perl 5.36 again. I think there's an argument to be made to try the new class syntax in 5.38, but at the moment, I'm still going with the traditional approach. Well, traditional with signatures. Modern::Perl 2022. I've refactored my AOC::SpatialUtil into AOC::Geometry and AOC::Grid, separating out the basics of 1D, 2D, and 3D geometry from the Grid2D and Grid3D. There are times when I want to work with ranges, points and extents but don't need a grid for them.

## So Far

I've done six days. No problems so far. Day 6 was particularly well-suited to Perl, IMO. Surprising that Day 1 jumped right into a solution that needed 2D geometry and a grid.