#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 6 -- https://adventofcode.com/2022/day/6

sub packet-start(Str $stream, Int :$length = 4)
{
    return $/.pos if $stream ~~ /
                . ** {$length}                      # Any $length characters
                <?{ $/.comb.unique == $length }>    # where all are unique
            /;
    return -1;  # if none found
}

sub MAIN(IO() $inputfile where *.f = 'aoc06.input')
{
    my $stream = $inputfile.slurp.trim;
    say "Part 1: ", packet-start($stream);
    say "Part 2: ", packet-start($stream, :length(14));
}
