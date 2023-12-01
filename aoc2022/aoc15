#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 15
# https://adventofcode.com/2022/day/15
# https://github.com/mscha/aoc

class Position
{
    has Int $.x;
    has Int $.y;

    # Position is a value type
    method WHICH() { ValueObjAt.new("Position|$!x|$!y") }   # Value type

    # Stringification
    method Str { "($!x,$!y)" }
    method gist { self.Str }

    # Ranges - only purely horizontal or vertical are supported
    multi method to(Position $end where $end.x == $!x) { ($!y ... $end.y).map({ pos($!x, $^y) }) }
    multi method to(Position $end where $end.y == $!y) { ($!x ... $end.x).map({ pos($^x, $!y) }) }

    # Manhattan metric
    method abs { $!x.abs + $!y.abs }
    method distance-to($p) { ($p - self).abs }

    # Tuning frequency
    method freq { 4_000_000 × $!x + $!y }
}

sub pos(Int() $x, Int() $y) { Position.new(:$x, :$y) }

# Override ==, .., + and -
multi sub infix:<==>(Position $a, Position $b) { $a.x == $b.x && $a.y == $b.y }
multi sub infix:<..>(Position $a, Position $b) { $a.to($b) }
multi sub infix:<+>(Position $a, Position $b) { pos($a.x + $b.x, $a.y + $b.y) }
multi sub infix:<->(Position $a, Position $b) { pos($a.x - $b.x, $a.y - $b.y) }

class Sensor
{
    has Position $.location;
    has Position $.beacon;

    has Int $.range = $!location.distance-to($!beacon);

    method visibility-at-y(Int $y)
    {
        my $dx = $.range - abs($!location.y - $y);
        return Empty if $dx < 0;
        return $.location.x - $dx .. $.location.x + $dx;
    }

    method Str { "Sensor at $!location sees beacon at $!beacon, distance $!range." }
    method gist { self.Str }
}

sub sensor(Str $desc)
{
    my ($xs,$ys, $xb,$yb) = $desc.comb(/'-'?\d+/);
    return Sensor.new(:location(pos($xs,$ys)), :beacon(pos($xb,$yb)));
}

sub combine(@ranges)
{
    gather {
        my @sorted = @ranges.sort(*.min);
        my ($start, $end) = @sorted[0].minmax;
        for @sorted -> $r {
            if $r.min ≤ $end+1 {
                # Overlaps
                $end max= $r.max
            }
            else {
                # No overlap
                take $start..$end;
                ($start, $end) = $r.minmax;
            }
        }
        take $start..$end;
    }
}

sub cut-off-at(@ranges, Int $min, Int $max)
{
    gather for @ranges -> $r {
        my $start = max($r.min, $min);
        my $end = min($r.max, $max);
        take $start..$end if $start ≤ $end;
    }
}

sub num-possible-beacons-at-y(Int $y, Sensor @sensors)
{
    # Find the range of possible x locations at y for each sensor,
    # combine any overlapping ranges, count the elements,
    # and subtract the number of known beacons at this y coordinate.
    return @sensors.map(*.visibility-at-y($y)).&combine».elems.sum
         - @sensors.map(*.beacon).grep(*.y == $y)».x.unique.elems;
}

sub possible-beacon(Sensor @sensors, Int $min, Int $max)
{
    # Simply check all possible y coordinates (slow...)
    for $min..$max -> $y {
        # Find the range of possible x locations at y for each sensor,
        # combine any overlapping ranges, cut them off at the given limits.
        my @ranges = @sensors.map(*.visibility-at-y($y)).&combine.&cut-off-at($min,$max);

        # If we have fewer elements than min..max, we have a possible beacon
        if @ranges».elems.sum ≤ $max - $min {
            if @ranges == 1 {
                # Only 1 range, so one of the extremes must be a possible beacon
                return pos($min, $y) unless $min ~~ @ranges[0];
                return pos($max, $y);
            }
            else {
                # More than one range, so there is a possible beacon between them
                return pos(@ranges[0].max + 1, $y);
            }
        }
    }
}

sub MAIN(IO() $inputfile where *.f = 'aoc15.input')
{
    my Sensor @sensors = $inputfile.lines».&sensor;

    my $y = $inputfile ~~ /sample/ ?? 10 !! 2_000_000;
    say 'Part 1: ', num-possible-beacons-at-y($y, @sensors);

    my $max = $inputfile ~~ /sample/ ?? 20 !! 4_000_000;
    say 'Part 2: ', possible-beacon(@sensors, 0, $max).freq;
}
