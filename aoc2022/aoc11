#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 11 -- https://adventofcode.com/2022/day/11

grammar MonkeyList
{
    rule TOP { ^ <monkey-spec>+ $ }

    rule monkey-spec {
        'Monkey' <id>':'
          'Starting items:' <level>+ % ','
          'Operation: new = ' <term> <oper> <term>
          'Test: divisible by' <div-by>
            'If true: throw to monkey' <true-monkey>
            'If false: throw to monkey' <false-monkey>
    }

    token id { \d+ }
    token level { \d+ }
    token term { \d+ | 'old' }
    token oper { '+' | '*' }
    token div-by { \d+ }
    token true-monkey { \d+ }
    token false-monkey { \d+ }
}

class MonkeyBarrel { ... }

class Monkey
{
    has Int $.id;               # ID
    has Int @.items;            # Worry levels of items
    has Str @.terms;            # Terms used in the new level calculation (number or 'old')
    has Sub $.operation;        # Operation used in the new level calculation (+ or *)
    has Int $.div-by;           # Number used in "divisibly by" check
    has Int $.true-monkey;      # Monkey to throw to if divisible
    has Int $.false-monkey;     # Monkey to throw to if not divisible

    has MonkeyBarrel $.barrel;  # Our monkey barrel
    has Bool $.relief = True;   # Are we relieved that our item did not break?
    has Int $.modulo is rw;     # Keep worry levels modulo this, if set
    has Bool $.verbose = False; # Verbose output

    has Int $.inspect-count = 0;

    # Play a turn of Keep Away
    method play
    {
        for @!items -> $i {
            # Calculate new worry level
            my $level = self.new-level($i);
            $level div= 3 if $!relief;      # Divide by 3 if we're relieved
            $level %= $!modulo if $!modulo; # Use modulo calculation if provided

            # Throw the item to the correct monkey
            my $new-monkey = $level %% $!div-by ?? $!true-monkey !! $!false-monkey;
            say "Monkey $!id: $i => $level; to monkey $new-monkey" if $!verbose;
            $!barrel.monkeys[$new-monkey].items.append($level);

            $!inspect-count++;
        }

        # We have no items left
        @!items = ();
    }

    # Determine a new worry level
    method new-level(Int $old)
    {
        return self.operation.(|@!terms.map({ $^t eq 'old' ?? $old !! +$^t }));
    }

    method Str { "Monkey $!id: @!items.join(', '); $!inspect-count inspections." }
    method gist { self.Str }
}

class MonkeyBarrel
{
    has Str $.monkey-list;      # Specification of monkeys
    has Bool $.relief = True;   # Are we relieved that our item did not break?
    has Bool $.verbose = False; # Verbose output

    has Monkey @.monkeys;       # Monkeys in the barrel
    has Int $.round = 0;        # Number of rounds played (only used in verbose output)

    submethod TWEAK
    {
        # Parse the list of monkeys
        MonkeyList.parse($!monkey-list, :actions(self)) or die "Invalid specification!";

        # Worry levels are getting too big if we don't get relief,
        # so we have to use worry levels modulo something.
        # Determine the smallest modulo we can use
        if (!$!relief) {
            my $modulo = [lcm] @!monkeys».div-by;
            .modulo = $modulo for @!monkeys;
            say "Worry levels are modulo $modulo" if $!verbose;
        }
    }

    # Store a parsed monkey
    method monkey-spec($/)
    {
        my $monkey = Monkey.new(:id(+$<id>),
                                :items(@<level>».Int),
                                :terms(@<term>».Str),
                                :operation(qq:!f/&infix:«$<oper>»/.EVAL),
                                :div-by(+$<div-by>),
                                :true-monkey(+$<true-monkey>),
                                :false-monkey(+$<false-monkey>),
                                :barrel(self),
                                :$!relief,
                                :$!verbose);
        @!monkeys[$<id>] = $monkey;
        say "Init: $monkey" if $!verbose;
    }

    # Play a round of Keep Away
    method play-round
    {
        $!round++;
        @!monkeys».play;
        say "After round $!round: $_" if $!verbose for @!monkeys;
    }

    # Calculate the level of monkey business
    method monkey-business { [*] @!monkeys».inspect-count.sort.tail(2) }
}

sub MAIN(IO() $inputfile where *.f = 'aoc11.input', Bool :v(:$verbose) = False)
{
    my $barrel = MonkeyBarrel.new(:monkey-list($inputfile.slurp), :$verbose);
    $barrel.play-round for ^20;
    say 'Part 1: ', $barrel.monkey-business;

    # Don't pass $verbose for part 2, it's too much output
    $barrel = MonkeyBarrel.new(:monkey-list($inputfile.slurp), :!relief);
    $barrel.play-round for ^10_000;
    say 'Part 2: ', $barrel.monkey-business;
}
