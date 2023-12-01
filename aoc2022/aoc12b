#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 12 -- https://adventofcode.com/2022/day/12

constant %ALTITUDE = ('a'..'z' Z=> 0..25), 'S'=>0, 'E'=>25;

class Area
{
    has Str $.map;

    has @.grid = $!map.lines».comb;
    has @.altitude = $!map.lines.map({ %ALTITUDE{$_.comb} });

    has Int $.width = +@!grid[0];
    has Int $.height = +@!grid;

    has @.distance;

    # Position of a certain type of point ('S' or 'E')
    method pos-of(Str $char)
    { 
        return (^$!width X ^$!height).first(-> ($x, $y) { @!grid[$y;$x] eq $char });
    }

    # Coordinates of neighbours that can reach this point
    # (i.e. this point has an altitude at most 1 higher)
    method reachable-from-neighbours(Int $x, Int $y)
    {
        return (($x-1,$y), ($x,$y-1), ($x+1,$y), ($x,$y+1))
                    .grep(-> ($u,$v) { 0 ≤ $u < $!width && 0 ≤ $v < $!height
                                       && @!altitude[$y;$x] ≤ @!altitude[$v;$u] + 1 });
    }

    # Calculate distance to the end point from any (reachable) point on the grid
    method calc-distance()
    {
        # The end point has distance 0, obviously
        my ($end-x, $end-y) = self.pos-of('E');
        @!distance[$end-y;$end-x] = 0;
        my @at-distance;
        @at-distance[0].push: ($end-x,$end-y);

        # Look for points with distance 1, 2, ...
        for 1..∞ -> $d {
            # Consider all points with distance d-1
            for @at-distance[$d-1][] -> ($x,$y) {
                # Check all neighbours that can reach this point, and if they don't
                # have a distance yet, assign distance d
                for self.reachable-from-neighbours($x,$y) -> ($u, $v) {
                    without @!distance[$v;$u] {
                        @!distance[$v;$u] = $d;
                        @at-distance[$d].push: ($u,$v);
                    }
                }
            }

            # No points with distance d?  We're done.
            last unless @at-distance[$d];
        }
    }

    # Distance from start point to end point
    method distance-to-end
    {
        my ($start-x, $start-y) = self.pos-of('S');
        return @!distance[$start-y;$start-x];
    }

    # Shortest distance from any point with altitude 0 to the end point
    method shortest-hiking-distance
    {
        return (^$!width X ^$!height).grep(-> ($x,$y) { @!altitude[$y;$x] == 0 })
                                     .map(-> ($x,$y) { @!distance[$y;$x] })
                                     .min;
    }
}

sub MAIN(IO() $inputfile where *.f = 'aoc12.input')
{
    my $area = Area.new(:map($inputfile.slurp));
    $area.calc-distance;
    say "Part 1: ", $area.distance-to-end;
    say "Part 2: ", $area.shortest-hiking-distance;
}
