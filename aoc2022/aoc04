#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 4 -- https://adventofcode.com/2022/day/4

class ElfPair
{
    has $.assignment;

    has ($!start1, $!end1);
    has ($!start2, $!end2);

    submethod TWEAK
    {
        ($!start1, $!end1, $!start2, $!end2) = $!assignment.comb(/\d+/);
    }

    method is-containing
    {
        return $!start1 ≤ $!start2 ≤ $!end2 ≤ $!end1 ||
               $!start2 ≤ $!start1 ≤ $!end1 ≤ $!end2;
    }

    method is-overlapping
    {
        return $!start1 ≤ $!start2 ≤ $!end1 ||
               $!start2 ≤ $!start1 ≤ $!end2;
    }
}

sub MAIN(IO() $inputfile where *.f = 'aoc04.input')
{
    my @pairs = $inputfile.lines.map: { ElfPair.new(:assignment($_)) };
    say "Part 1: ", @pairs».is-containing.sum;
    say "Part 2: ", @pairs».is-overlapping.sum;
}
