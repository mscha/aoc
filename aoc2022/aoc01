#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 1 -- https://adventofcode.com/2022/day/1

sub MAIN(IO() $inputfile where *.f = 'aoc01.input', Bool :v(:$verbose) = False)
{
    my @cal-counts = $inputfile.split(/\n\n/)».words».sum;
    dd @cal-counts if $verbose;
    say "Part 1: ", @cal-counts.max;
    say "Part 2: ", @cal-counts.sort(-*).head(3).sum;
}
