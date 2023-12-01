#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 9 -- https://adventofcode.com/2022/day/9

class Rope
{
    has Int $.knots = 2;
    has Bool $.verbose = False;

    has Int $!tail = $!knots - 1;
    has Complex @!pos = 0+0i xx $!knots;
    has %!tail-visits{Complex} = @!pos.tail => 1;

    constant %MOVEMENT = :R(1+0i), :L(-1+0i), :U(0+1i), :D(0-1i);

    method move-head(Str() $dir, Int() $count)
    {
        say "$dir $count:" if $!verbose;
        for ^$count {
            @!pos[0] += %MOVEMENT{$dir};
            say "  Head moves to @!pos[0]" if $!verbose;

            self.catchup;
        }
    }

    multi method catchup
    {
        for (^$!knots).rotor(2=>-1) -> ($h, $t) {
            self.catchup($h, $t);
        }
    }

    multi method catchup($h, $t)
    {
        if abs(@!pos[$t] - @!pos[$h]) > 1.5 {
            @!pos[$t] += sign(@!pos[$h].re - @!pos[$t].re)
                       + sign(@!pos[$h].im - @!pos[$t].im) × i;
            say "    Knot $t moves to @!pos[$t]" if $!verbose;

            %!tail-visits{@!pos[$t]}++ if $t == $!tail;
        }
    }

    method tail-visited-count { +%!tail-visits }
}

sub MAIN(IO() $inputfile where *.f = 'aoc09.input', Bool :v(:$verbose) = False)
{
    my $rope = Rope.new(:$verbose);
    for $inputfile.words -> $dir, $count {
        $rope.move-head($dir, $count);
    }
    say "Part 1: ", $rope.tail-visited-count;

    my $rope10 = Rope.new(:10knots, :$verbose);
    for $inputfile.words -> $dir, $count {
        $rope10.move-head($dir, $count);
    }
    say "Part 2: ", $rope10.tail-visited-count;
}
