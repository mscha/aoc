#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 5 -- https://adventofcode.com/2022/day/5

grammar StackSpec
{
    regex TOP { <stacks> \s* <cratenumbers> \s* <moves> }

    regex stacks { <stack-line>+ % \v }
    regex stack-line { <crate-spec>+ % \h }
    regex crate-spec { '   ' | '[' <crate> ']' }
    token crate { <[A..Z]> }

    rule cratenumbers { (\d+)+ % \h+ }

    rule moves { <move>+ }
    rule move { 'move' <count> 'from' <col1> 'to' <col2> }
    token count { \d+ }
    token col1 { \d+ }
    token col2 { \d+ }
}

class CrateMover
{
    has Str $.spec;
    has Int $.model = 9000;
    has Bool $.verbose = False;

    has @.stack;

    submethod TWEAK { StackSpec.parse($!spec, :actions(self)) }

    # Action methods for parsing StackSpec
    method stack-line($/)
    {
        for $<crate-spec>.kv -> $i, $c {
            with $c<crate> -> $crate {
                @!stack[$i].unshift(~$crate);
            }
        }
    }
    method stacks($/) {
        say self if $!verbose;
    }
    method move($/)
    {
        say $/.trim if $!verbose;
        given ($!model) {
            when 9000 {
                @!stack[$<col2>-1].append: @!stack[$<col1>-1].pop xx +$<count>;
            }
            when 9001 {
                @!stack[$<col2>-1].append: reverse @!stack[$<col1>-1].pop xx +$<count>;
            }
            default {
                die "Unknown CrateMover model: $!model!";
            }
        }
        say " -> ", self if $!verbose;
    }

    method stack-tops { @!stack[*;*-1].join }
    
    method Str { @!stack».join.join(' / ') }
    method gist { @!stack».join.join(' / ') }
}

sub MAIN(IO() $inputfile where *.f = 'aoc05.input', Bool :v(:$verbose) = False)
{
    my $mover = CrateMover.new(:spec($inputfile.slurp), :$verbose);
    say "Part 1: ", $mover.stack-tops;

    my $mover2 = CrateMover.new(:spec($inputfile.slurp), :model(9001), :$verbose);
    say "Part 2: ", $mover2.stack-tops;
}
