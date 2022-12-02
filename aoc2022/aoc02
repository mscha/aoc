#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 2 -- https://adventofcode.com/2022/day/2

constant %SCORES1 = 'A X' => 4, 'A Y' => 8, 'A Z' => 3,
                    'B X' => 1, 'B Y' => 5, 'B Z' => 9,
                    'C X' => 7, 'C Y' => 2, 'C Z' => 6;

constant %SCORES2 = 'A X' => 3, 'A Y' => 4, 'A Z' => 8,
                    'B X' => 1, 'B Y' => 5, 'B Z' => 9,
                    'C X' => 2, 'C Y' => 6, 'C Z' => 7;

sub MAIN(IO() $inputfile where *.f = 'aoc02.input')
{
    say "Part 1: ", %SCORES1{$inputfile.lines}.sum;
    say "Part 2: ", %SCORES2{$inputfile.lines}.sum;
}
