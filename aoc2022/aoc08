#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 8 -- https://adventofcode.com/2022/day/8

class TreeGrid
{
    has Str $.map;

    has @!height = $!map.lines.map(*.comb».Int);
    has Int $!max-x = @!height[0].end;
    has Int $!max-y = @!height.end;

    method in-bounds(Int $x, Int $y) { 0 ≤ $x ≤ $!max-x && 0 ≤ $y ≤ $!max-y }

    method is-visible(Int $x, Int $y)
    {
        return any(all(@!height[$y;^$x]),
                   all(@!height[$y;$x^..$!max-x]),
                   all(@!height[^$y;$x]),
                   all(@!height[$y^..$!max-y;$x])) < @!height[$y;$x];
    }

    method count-visible
    {
        return (0..$!max-x X 0..$!max-y)
                    .map(-> ($x,$y) { ?self.is-visible($x,$y) })
                    .sum;
    }

    method scenic-score(Int $x, Int $y)
    {
        return [×] ((-1,0), (1,0), (0,-1), (0,1)).map: -> ($dx,$dy) {
            my $visible = 0;
            my ($u,$v) = ($x,$y);
            loop {
                ($u,$v) »+=« ($dx,$dy);
                last unless self.in-bounds($u,$v);
                $visible++;
                last if @!height[$v;$u] ≥ @!height[$y;$x];
            }
            $visible;
        }
    }

    method max-scenic-score
    {
        return (0^..^$!max-x X 0^..^$!max-y)
                    .map(-> ($x,$y) { self.scenic-score($x,$y) })
                    .max;
    }
}

sub MAIN(IO() $inputfile where *.f = 'aoc08.input')
{
    my $grid = TreeGrid.new(:map($inputfile.slurp));
    say "Part 1: ", $grid.count-visible;
    say "Part 2: ", $grid.max-scenic-score;
}
