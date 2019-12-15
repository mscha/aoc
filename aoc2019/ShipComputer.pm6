use v6.d;

# Advent of Code 2019 -- Ship Computer
# Implements opcodes and functionality for days 2, 5, 7 and 9.

class ShipComputer
{
    has Str @.instructions;
    has Int @.program is default(0);
    has Int @.input;
    has Int @.output;

    has Bool $.interrupt is rw = False;

    has Bool $.debug = False;
    has Bool $.verbose = False;

    has Int $!pos = 0;
    has Int $!relative-base = 0;

    has Int @!initial-program;
    has Int @!initial-input;

    has &.input-handler = sub { self.input-value };
    has &.output-handler = sub ($v) { @!output.append($v) };

    enum Opcode (
        ADD => 1,
        MUL => 2,
        INP => 3,
        OUT => 4,
        JIT => 5,
        JIF => 6,
        LTH => 7,
        EQU => 8,
        ARB => 9,
        HLT => 99
    );

    enum ParameterMode <POSITION IMMEDIATE RELATIVE>;

    submethod TWEAK
    {
        # Parse instructions if program wasn't parsed yet
        if @!instructions && !@!program {
            @!program = @!instructions.join(' ').comb(/'-'?\d+/)».Int;
        }

        # Save initial program and values to be able to do a reset
        @!initial-program = @!program;
        @!initial-input = @!input;

        # --debug implies --verbose
        $!verbose = True if $!debug;
    }

    method set-input-handler(&h)
    {
        &!input-handler = &h;
    }

    method set-output-handler(&h)
    {
        &!output-handler = &h;
    }

    method reset
    {
        @!program = @!initial-program;
        $!pos = 0;
        $!relative-base = 0;

        @!input = @!initial-input;
        @!output = ();
    }

    method opcode
    {
        return @!program[$!pos] % 100;
    }

    method poke(Int $loc, Int $val)
    {
        # This isn't really necessary, you can just do .program[$loc] = $val, but
        # this is more fun :-)
        @!program[$loc] = $val;
    }

    method param-mode(Int $n)
    {
        return @!program[$!pos] div 10**($n+1) % 10;
    }

    method param-ptr(Int $n, Int $mode = $.param-mode($n))
    {
        given $mode {
            when POSITION {
                return @!program[$!pos+$n];
            }
            when IMMEDIATE {
                return $!pos+$n;
            }
            when RELATIVE {
                return $!relative-base+@!program[$!pos+$n];
            }
        }
    }

    method param(Int $n, Int $mode = $.param-mode($n)) is rw
    {
        return-rw @!program[$.param-ptr($n, $mode)];
    }

    method input-value
    {
        die "No input left for INP at position $!pos!" unless @!input;
        return @!input.shift;
    }

    method run-program(*@input)
    {
        @!input = @input if @input;

        say "< @!program[] >" if $!debug;
        INSTRUCTION:
        loop {
            if $!interrupt {
                say ">> Interrupted" if $!verbose;
                $!interrupt = False;
                last INSTRUCTION;
            }

            die "Invalid program position $!pos" unless 0 ≤ $!pos < @!program;
            given $.opcode {
                when ADD {
                    say ">> $!pos: ADD - [$.param-ptr(3)]" ~
                        " := [$.param-ptr(1)] + [$.param-ptr(2)]" ~
                        " = $.param(1) + $.param(2)" ~
                        " = { $.param(1) + $.param(2) }" if $!verbose;
                    $.param(3) = $.param(1) + $.param(2);
                    $!pos += 4;
                }
                when MUL {
                    say ">> $!pos: MUL - [$.param-ptr(3)]" ~
                        " := [$.param-ptr(1)] × [$.param-ptr(2)]" ~
                        " = $.param(1) × $.param(2)" ~
                        " = { $.param(1) × $.param(2) }" if $!verbose;
                    $.param(3) = $.param(1) × $.param(2);
                    $!pos += 4;
                }
                when INP {
                    my $val = &!input-handler();
                    if $!interrupt {
                        say ">> Interrupted" if $!verbose;
                        $!interrupt = False;
                        last INSTRUCTION;
                    }
                    say ">> $!pos: INP - [$.param-ptr(1)] := $val" if $!verbose;
                    $.param(1) = $val;
                    $!pos += 2;
                }
                when OUT {
                    say ">> $!pos: OUT - [$.param-ptr(1)] = $.param(1)" if $!verbose;
                    &!output-handler($.param(1));
                    $!pos += 2;
                }
                when JIT {
                    say ">> $!pos: JIT - ? [$.param-ptr(1)] = $.param(1)" ~
                        " = { ?$.param(1) } --> [$.param-ptr(2)] = $.param(2)" if $!verbose;
                    if $.param(1) {
                        $!pos = $.param(2);
                    }
                    else {
                        $!pos += 3;
                    }
                }
                when JIF {
                    say ">> $!pos: JIF - ! [$.param-ptr(1)] = $.param(1)" ~
                        " = { ?$.param(1) } --> [$.param-ptr(2)] = $.param(2)" if $!verbose;
                    if !$.param(1) {
                        $!pos = $.param(2);
                    }
                    else {
                        $!pos += 3;
                    }
                }
                when LTH {
                    say ">> $!pos: LTH - [$.param-ptr(3)] := ([$.param-ptr(1)] < [$.param-ptr(2)])" ~
                        " = ($.param(1) < $.param(2))" ~
                        " = { $.param(1) < $.param(2) }" if $!verbose;
                    $.param(3) = +($.param(1) < $.param(2));
                    $!pos += 4;
                }
                when EQU {
                    say ">> $!pos: EQU - [$.param-ptr(3)] := ([$.param-ptr(1)] == [$.param-ptr(2)])" ~
                        " = ($.param(1) == $.param(2))" ~
                        " = { $.param(1) == $.param(2) }" if $!verbose;
                    $.param(3) = +($.param(1) == $.param(2));
                    $!pos += 4;
                }
                when ARB {
                    say ">> $!pos: ARB - base = $!relative-base + [$.param-ptr(1)]" ~
                        " = $!relative-base + $.param(1)" ~
                        " = { $!relative-base + $.param(1) }" if $!verbose;
                    $!relative-base += $.param(1);
                    $!pos += 2;
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
