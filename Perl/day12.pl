#!/usr/bin/env perl
BEGIN {
    use Cwd;
    our $directory = cwd;
    our $local_lib = $ENV{"HOME"} . '/perl5/lib/perl5';
}

use lib $directory;
use lib $local_lib;

use Modern::Perl 2022;
use autodie;
use Data::Dumper;
use feature 'signatures';
#use Storable 'dclone';

use AOC::Util;

my $INPUT_PATH = '../input';
#my $INPUT_FILE = 'day12_test.txt';
my $INPUT_FILE = 'day12_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 12: Leonardo's Monorail";

our @instructions = parse_input(@input);

solve_part_one();
solve_part_two();

exit( 0 );

sub solve_part_one() {
	my %reg = ('a' => 0, 'b' => 0, 'c' => 0, 'd' => 0);
	my $ptr = 0;
	while ($ptr <= $#instructions) {
		$ptr = exec_instruction(\%reg, $instructions[$ptr], $ptr);
		#print_registers(%reg);
	}
	
	say "Part One: the value in register a is $reg{'a'}.";
}

sub solve_part_two(@input) {
	my %reg = ('a' => 0, 'b' => 0, 'c' => 1, 'd' => 0);
	my $ptr = 0;
	while ($ptr <= $#instructions) {
		$ptr = exec_instruction(\%reg, $instructions[$ptr], $ptr);
		#print_registers(%reg);
		# Tried inlining exec_instruction here. Saved 2 seconds, not worth it.
	}
	
	say "Part Two: the value in register a is $reg{'a'}.";
}

sub exec_instruction($registers, $instr, $ptr) {
	if ($instr->[0] eq 'cpy') {
		my $value = $instr->[1];
		if ($value =~ m/[a-z]/) {
			$value = $registers->{$value};
		}
		$registers->{$instr->[2]} = $value;
		$ptr++;
	}
	elsif ($instr->[0] eq 'inc') {
		$registers->{$instr->[1]} = $registers->{$instr->[1]} + 1;
		$ptr++;
	}
	elsif ($instr->[0] eq 'dec') {
		$registers->{$instr->[1]} = $registers->{$instr->[1]} - 1;
		$ptr++;
	}
	elsif ($instr->[0] eq 'jnz') {
		my $value = $instr->[1];
		if ($value =~ m/[a-z]/) {
			$value = $registers->{$value};
		}
		if ($value != 0) {
			$ptr += $instr->[2];
		}
		else {
			$ptr++;
		}
	}
	return $ptr;
}

sub parse_input(@input) {
	my @instructions = ();
	for my $line (@input) {
		my @i = split(/ +/, $line);
		push(@instructions, \@i);
	}
	return @instructions;
}

sub print_registers(%reg) {
	for my $r (sort keys( %reg )) {
		print "$r -> $reg{$r}\t";
	}
	say "";
}