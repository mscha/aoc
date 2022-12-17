#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 17
# https://adventofcode.com/2022/day/17
# https://github.com/mscha/aoc

class Rocktris
{
    has @.jet-pattern;

    has Int $.width = 7;
    has Int $.height = 0;
    has Int $.tower-height = 0;

    has @!grid;
    has @!rock;
    has Int $!rock-x;
    has Int $!rock-y;
    has Int $.rock-count = 0;
    has Int $.jet-count = 0;

    has Int $.dropped = 0;
    has Int @!tower-heights = 0,;

    has Int $!cycle-start;
    has Int $!cycle-length;
    has Int $!cycle-increase;

    constant @ROCKS = (((1,1,1,1,),),
                       ((0,1,0),(1,1,1),(0,1,0)),
                       ((1,1,1),(0,0,1),(0,0,1)),
                       ((1,),(1,),(1,),(1,)),
                       ((1,1),(1,1)));

    constant EMPTY = '░░ ';
    constant FALLING = '▓▓ ';
    constant SOLID = '██ ';

    method extend-grid(Int $height) {
        return if $height ≤ $!height;
        for ^$!width X ($!height ..^ $height) -> ($x, $y) {
            @!grid[$y;$x] //= EMPTY;
        }
        $!height = $height;
    }

    method add-rock(Str $block = FALLING)
    {
        self.extend-grid($!rock-y + @!rock);
        for ^@!rock[0] X ^@!rock -> ($x, $y) {
            @!grid[$!rock-y + $y; $!rock-x + $x] = $block if @!rock[$y;$x];
        }

        if $block eq SOLID {
            $!tower-height max= $!rock-y + @!rock;
        }
    }

    method remove-rock
    {
        for ^@!rock[0] X ^@!rock -> ($x, $y) {
            @!grid[$!rock-y + $y; $!rock-x + $x] = EMPTY if @!rock[$y;$x];
        }
    }

    method rock-fits-at(Int $rx, Int $ry)
    {
        return False if $ry < 0 || $rx < 0 || $rx + @!rock[0] > $!width;
        for ^@!rock[0] X ^@!rock -> ($x, $y) {
            return False if @!rock[$y;$x] && @!grid[$ry + $y;$rx + $x] eq SOLID;
        }
        return True;
    }

    method drop-rock
    {
        @!rock = @ROCKS[$!rock-count++ % @ROCKS];
        ($!rock-x, $!rock-y) = (2, $!tower-height + 3);
        self.add-rock;

        loop {
            given @!jet-pattern[$!jet-count++ % @!jet-pattern] {
                when '>' {
                    if self.rock-fits-at($!rock-x+1, $!rock-y) {
                        self.remove-rock;
                        $!rock-x++;
                        self.add-rock;
                    }
                }
                when '<' {
                    if self.rock-fits-at($!rock-x-1, $!rock-y) {
                        self.remove-rock;
                        $!rock-x--;
                        self.add-rock;
                    }
                }
            }

            if self.rock-fits-at($!rock-x, $!rock-y - 1) {
                self.remove-rock;
                $!rock-y--;
                self.add-rock;
            }
            else {
                self.add-rock(SOLID);
                last;
            }
        }

        @!tower-heights.push($!tower-height);
    }

    method determine-cycle-length
    {
        # Look for cyclic behaviour in the tower.
        # Ensure the tower is high enough to compare the top 100 rows.
        # (Not sure how many are really needed, since the top of the tower
        # is jagged.  10 turns out to be too few, so 100 to be safe.)
        self.drop-rock until $!tower-height ≥ 100;

        my %seen;
        loop {
            self.drop-rock;

            # We're looking for a repeat of the same state, so:
            #  - The top of the tower is the same,
            #  - The next rock will be the same
            #  - We're in the same position in the jet pattern
            my $key = join('|', $!rock-count % @ROCKS,
                                $!jet-count % @!jet-pattern,
                                $@!grid.tail(100)».join.join("\n"));
            if %seen{$key} {
                # If we've seen this state before, we have a cycle.
                # Remember the length and the tower height increase
                $!cycle-start = %seen{$key};
                $!cycle-length = $!rock-count - %seen{$key};
                $!cycle-increase = $!tower-height - @!tower-heights[%seen{$key}];
                last;
            }
            %seen{$key} = $!rock-count;
        }
    }

    method tower-height-after(Int $n)
    {
        # Find a cycle, if necessary
        self.determine-cycle-length unless $!cycle-length;

        # Give the answer if we already have it
        return @!tower-heights[$n] if @!tower-heights[$n];

        # Determine the answer based on the found cycle
        my $m = $n - $!cycle-start;
        return @!tower-heights[$!cycle-start + $m % $!cycle-length]
                    + $m div $!cycle-length × $!cycle-increase;
    }

    method Str { ($!height ^... 0).map({ @!grid[$^y].join ~ "\n\n" }).join() }
    method gist { self.Str };
}

sub MAIN(IO() $inputfile where *.f = 'aoc17.input', Bool :v(:$verbose) = False)
{
    my $game = Rocktris.new(:jet-pattern($inputfile.comb(/<[<>]>/)));
    for ^2022 {
        $game.drop-rock;
        say $game if $verbose;
    }
    say "Part 1: ", $game.tower-height;

    say "Part 2: ", $game.tower-height-after(1_000_000_000_000);
}
