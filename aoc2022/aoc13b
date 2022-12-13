#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 13
# https://adventofcode.com/2022/day/13
# https://github.com/mscha/aoc

use JSON::Fast;

sub compare($p, $q, Bool :v(:$verbose) = False)
{
    state $level = -1;
    temp $level; $level++;
    say '  ' x $level, $p, ' vs ', $q, ' ?' if $verbose;

    my $cmp;
    if $p ~~ Int && $q ~~ Int {
        # Comparing two integers
        $cmp = $p <=> $q;
    }
    else {
        # Comparing two lists
        # (or one list and an integer, we can treat the integer as a list)
        # Compare each item until we find one that's different
        # If all items are the same, compare the lengths of the lists
        $cmp = ($p[] Z $q[]).map(-> ($l, $r) { compare($l, $r, :$verbose) })
                            .first(* ≠ Same)
                    || $p.elems <=> $q.elems;
    }

    say '  ' x $level, $p, ' vs ', $q, ': ', $cmp if $verbose;
    say '-' x 60 if $verbose && $level == 0;
    return $cmp;
}

sub MAIN(IO() $inputfile where *.f = 'aoc13.input', Bool :v(:$verbose) = False)
{
    my @packets = $inputfile.lines.grep(/\S/)».&from-json;
    say 'Part 1: ', @packets.rotor(2)
                            .grep(-> ($p,$q) { compare($p,$q, :$verbose) eq Less }, :k)
                            .map(* + 1)    # Using 1-based indexing, sigh
                            .sum;

    my @dividers = ('[[2]]', '[[6]]')».&from-json;
    @packets.append(@dividers);
    @packets .= sort(&compare);
    say "Part 2: ", [×] @packets.grep(* ∈ @dividers, :k).map(* + 1);
}
