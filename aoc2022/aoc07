#!/usr/bin/env raku
use v6.d;
$*OUT.out-buffer = False;   # Autoflush

# Advent of Code 2022 day 7 -- https://adventofcode.com/2022/day/7

role DirEntry
{
    has Str $.name;
    has DirEntry $.parent = Nil;

    method size() { ... }

    method Str
    {
        return $!name if !$!parent;
        return $!parent ~ $!name if $!parent.name.ends-with('/');
        return $!parent ~ '/' ~ $!name;
    }
    method gist { self.Str }
}

class File does DirEntry
{
    has Int $.size;
}

class Directory does DirEntry
{
    has DirEntry @!children;
    has DirEntry %!child;

    method size { @!children».size.sum }

    method add(DirEntry $entry)
    {
        @!children.append($entry);
        %!child{$entry.name} = $entry;
        return $entry;
    }

    method subdir(Str $name)
    {
        if my $dir = %!child{$name} {
            die "$dir is not a directory!" unless $dir ~~ Directory;
            return $dir;
        }
        else {
            return self.add(Directory.new(:$name, :parent(self)));
        }
    }

    method recursive-dirs
    {
        gather {
            for @!children -> $c {
                if $c ~~ Directory {
                    .take for $c.recursive-dirs;
                }
            }
            take self;
        }
    }
}

sub parse-session($input, :$verbose = False)
{
    my $root = Directory.new(:name</>);
    my $cwd = $root;

    for $input.lines {
        say "$cwd: $_" if $verbose;

        # cd
        # Change to the appropriate directory
        when '$ cd /' { $cwd = $root }
        when '$ cd ..' { $cwd .= parent }
        when /^ '$ cd' \s* (\S+) $/ { $cwd .= subdir(~$0) }

        # ls
        # Nothing to do, we're going to recognize the output anyway
        when '$ ls' { }

        # Output from ls
        # Store the directory or file
        when /^ 'dir' \s* (\S+) $/ {
            $cwd.add(Directory.new(:name(~$0), :parent($cwd)))
        }
        when /^ (\d+) \s* (\S+) $/ {
            $cwd.add(File.new(:name(~$1), :size(+$0)))
        }

        default { die "Unrecognized line: $_" }
    }

    return $root;
}

sub MAIN(IO() $inputfile where *.f = 'aoc07.input', Bool :v(:$verbose) = False)
{
    my $root = parse-session($inputfile, :$verbose);
    my @dirs = $root.recursive-dirs;
    if $verbose {
        say '';
        say "List of directories:";
        say "$_ ($_.size())" for @dirs;
        say '';
    }

    say "Part 1: ", @dirs.grep(*.size ≤ 100_000)».size.sum;

    my $to-delete = $root.size - 40_000_000;
    my @candidates = @dirs.grep(*.size ≥ $to-delete);
    my $best = @candidates.min(*.size);
    if $verbose {
        say '';
        say "Need to delete: $to-delete";
        say "Candidates: ";
        say " - $_ ($_.size())" for @candidates;
        say "Best directory to delete: $best ($best.size())";
        say '';
    }
    say "Part 2: ", $best.size;
}
