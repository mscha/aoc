use v6.d;

# Advent of Code 2019 -- Ship Computer
# Implements opcodes for day 2 and 5

class ShipComputer
{
    has Str @.instructions;
    has Int @.program;
    has Int @.input;
    has Int @.output;

    has Bool $.verbose = False;
    has Bool $.debug = False;

    has Int $.pos = 0;
    has Int $.input-pos = 0;

    has Int @!initial-program;
    has Int @!initial-input;

    enum Opcode (
        ADD => 1,
        MUL => 2,
        INP => 3,
        OUT => 4,
        JIT => 5,
        JIF => 6,
        LTH => 7,
        EQU => 8,
        HLT => 99
    );

    submethod TWEAK
    {
        # Parse instructions if program wasn't parsed yet
        if @!instructions && !@!program {
            @!program = @!instructions.join(' ').comb(/'-'?\d+/)».Int;
        }

        # Save initial program and values to be able to do a reset
        @!initial-program = @!program;
        @!initial-input = @!input;
    }

    method reset
    {
        @!program = @!initial-program;
        $!pos = 0;

        @!input = @!initial-input;
        $!input-pos = 0;

        @!output = ();
    }

    method opcode
    {
        return @!program[$!pos] % 100;
    }

    method param-mode(Int $n)
    {
        return @!program[$!pos] div 10**($n+1) % 10;
    }

    method param(Int $n, Int $mode = $.param-mode($n)) is rw
    {
        return-rw $mode ?? @!program[$!pos+$n] !! @!program[@!program[$!pos+$n]]
    }

    method input-value
    {
        die "Invalid input position $!input-pos!" if $!input-pos ≥ @!input;
        return @!input[$!input-pos++];
    }

    method run-program
    {
        say "< @!program[] >" if $!debug;
        INSTRUCTION:
        loop {
            die "Invalid program position $!pos" unless 0 ≤ $!pos < @!program;
            given $.opcode {
                when ADD {
                    say ">> $!pos: ADD - [$.param(3,1)] = $.param(1) + $.param(2)" if $!verbose;
                    $.param(3) = $.param(1) + $.param(2);
                    $!pos += 4;
                }
                when MUL {
                    say ">> $!pos: MUL - [$.param(3,1)] = $.param(1) × $.param(2)" if $!verbose;
                    $.param(3) = $.param(1) × $.param(2);
                    $!pos += 4;
                }
                when INP {
                    my $val = $.input-value;
                    say ">> $!pos: INP - [$.param(1,1)] = $val" if $!verbose;
                    $.param(1) = $val;
                    $!pos += 2;
                }
                when OUT {
                    say ">> $!pos: OUT - $.param(1)" if $!verbose;
                    @!output.append: $.param(1);
                    $!pos += 2;
                }
                when JIT {
                    say ">> $!pos: JIT - ? $.param(1) --> $.param(2)" if $!verbose;
                    if $.param(1) {
                        $!pos = $.param(2);
                    }
                    else {
                        $!pos += 3;
                    }
                }
                when JIF {
                    say ">> $!pos: JIF - ! $.param(1) --> $.param(2)" if $!verbose;
                    if !$.param(1) {
                        $!pos = $.param(2);
                    }
                    else {
                        $!pos += 3;
                    }
                }
                when LTH {
                    say ">> $!pos: LTH - [$.param(3,1)] = ($.param(1) < $.param(2))" if $!verbose;
                    $.param(3) = +($.param(1) < $.param(2));
                    $!pos += 4;
                }
                when EQU {
                    say ">> $!pos: EQU - [$.param(3,1)] = ($.param(1) == $.param(2))" if $!verbose;
                    $.param(3) = +($.param(1) == $.param(2));
                    $!pos += 4;
                }
                when HLT {
                    say ">> $!pos: HLT" if $!verbose;
                    last INSTRUCTION;
                }
                default {
                    die "Invalid instruction '@!program[$!pos]' at $!pos!";
                }
            }
            say "< @!program[] >" if $!debug;
        }
    }
}
