#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 10 -- https://adventofcode.com/2022/day/10

class CPU
{
    has Int $.X = 1;
    has Int $.cycle = 1;
    has Int $.pos = 0;

    has Int @.signal = $!X;
    has Str $.output = '';

    constant LIT = '▓▓';
    constant DARK = '░░';

    method tick
    {
        @!signal[$!cycle] = $!X * $!cycle;
        $!output ~= $!X - 1 ≤ $!pos ≤ $!X + 1 ?? LIT !! DARK;

        $!cycle++;
        $!pos++; $!pos %= 40;
        $!output ~= "\n" if $!pos == 0;
    }

    method run(@instr)
    {
        for @instr {
            when 'noop' { self.tick; }
            when /addx \s+ (\-?\d+)/ { self.tick; self.tick; $!X += $0; }
        }
    }
}

sub MAIN(IO() $inputfile where *.f = 'aoc10.input')
{
    my $cpu = CPU.new;
    $cpu.run($inputfile.lines);
    say "Part 1: ", $cpu.signal[20,60...220].sum;
    say "Part 2: "; say $cpu.output;
}
