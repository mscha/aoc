#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 18
# https://adventofcode.com/2022/day/18
# https://github.com/mscha/aoc

class Pos
{
    has Int $.x;
    has Int $.y;
    has Int $.z;

    # Pos is a value type
    method WHICH() { ValueObjAt.new("Pos|$!x|$!y|$!z") }   # Value type

    # Neighbours
    method neighbours
    {
        gather for (1,0,0), (-1,0,0), (0,1,0), (0,-1,0), (0,0,1), (0,0,-1) -> ($dx,$dy,$dz) {
            take pos($!x+$dx, $!y+$dy, $!z+$dz);
        }
    }

    # Stringification
    method Str { "($!x,$!y,$!z)" }
    method gist { self.Str }
}

sub pos(Int() $x, Int() $y, Int() $z) { Pos.new(:$x, :$y, :$z) }

# Override ==, .., + and -
multi sub infix:<==>(Pos $a, Pos $b) { $a.x == $b.x && $a.y == $b.y && $a.z == $b.z }
multi sub infix:<+>(Pos $a, Pos $b) { pos($a.x + $b.x, $a.y + $b.y, $a.z + $b.z) }
multi sub infix:<->(Pos $a, Pos $b) { pos($a.x - $b.x, $a.y - $b.y, $a.z - $b.z) }

class Lava
{
    has Pos @.cube-pos;
    has Set $!cubes = set @!cube-pos;

    # Boundaries of the lava droplet, with 1 padding
    has Int $!x-min = @!cube-pos».x.min - 1;
    has Int $!x-max = @!cube-pos».x.max + 1;
    has Int $!y-min = @!cube-pos».y.min - 1;
    has Int $!y-max = @!cube-pos».y.max + 1;
    has Int $!z-min = @!cube-pos».z.min - 1;
    has Int $!z-max = @!cube-pos».z.max + 1;

    method in-bounds(Pos $p)
    {
        return $!x-min ≤ $p.x ≤ $!x-max &&
               $!y-min ≤ $p.y ≤ $!y-max &&
               $!z-min ≤ $p.z ≤ $!z-max;
    }

    method neighbours(Pos $p) { $p.neighbours.grep({ self.in-bounds($^p) && $^p ∈ $!cubes }) }
    method exposed(Pos $p) { $p.neighbours.grep({ self.in-bounds($^p) && $^p ∉ $!cubes }) }

    method surface-area
    {
        return @.cube-pos.map({ +self.exposed($^p) }).sum;
    }

    method exterior
    {
        my Pos $start = pos($!x-min,$!y-min,$!z-min);
        my Pos @current = $start;
        my Pos @points = @current;
        my %seen{Pos} = $start => True;
        while (@current) {
            @current = gather for @current -> $p {
                for self.exposed($p).grep(-> $q { !%seen{$q} }) -> $r {
                    %seen{$r} = True;
                    take $r;
                }
            }
            @points.append(@current);
        }

        return set @points;
    }

    method exterior-surface-area
    {
        my $ext = self.exterior;
        return @.cube-pos.map({ +self.exposed($^p).grep({ $^q ∈ $ext }) }).sum;
    }
}

sub MAIN(IO() $inputfile where *.f = 'aoc18.input')
{
    my $lava = Lava.new(:cube-pos($inputfile.comb(/'-'?\d+/).map(-> $x,$y,$z { pos($x,$y,$z) })));
    say "Part 1: ", $lava.surface-area;
    say "Part 2: ", $lava.exterior-surface-area;
}
