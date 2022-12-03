#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 3 -- https://adventofcode.com/2022/day/3

multi sub priority(Str $item)
{
    given $item {
        return $item.ord - 96 when 'a' .. 'z';
        return $item.ord - 38 when 'A' .. 'Z';
    }
}

multi sub priority(@items) { @items».&priority.sum }

class Rucksack
{
    has Str $.item-list;
    has Str @.items = $!item-list.comb;
    has Int $.item-count = @!items.elems;

    method in-both-compartments
    {
        my $half = $!item-count div 2;
        return slip keys @!items.head($half) ∩ @!items.tail($half);
    }
}

sub common-items(@sacks)
{
    return slip keys [∩] @sacks».items;
}

sub MAIN(IO() $inputfile where *.f = 'aoc03.input')
{
    my @rucksacks = $inputfile.lines.map({ Rucksack.new(:item-list($_)) });
    say "Part 1: ", priority(@rucksacks».in-both-compartments);
    say "Part 2: ", priority(@rucksacks.rotor(3).map(*.&common-items));
}
