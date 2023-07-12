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
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
#my $INPUT_FILE = 'day03_test.txt';
my $INPUT_FILE = 'day03_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 03: Squares With Three Sides";

solve_part_one(@input);
solve_part_two(@input);

exit( 0 );

sub solve_part_one(@input) {
	my @possible = ();
	for my $line (@input) {
		$line =~ s/^\s+//; #left trim
		my @sides = split(/ +/, $line);
		@sides = sort { $a <=> $b } @sides;
		if ($sides[0] + $sides[1] > $sides[2]) {
			push(@possible, \@sides);
		}
	}
	
	say "Part One: the number of possible triangles is " . (scalar @possible);
}

sub solve_part_two(@input) {
	my @possible = ();

	my @all = (); 	# first column
	my @col1 = ();	# second column
	my @col2 = ();	# third column
	for my $line (@input) {
		$line =~ s/^\s+//; #left trim
		my @nums = split(/ +/, $line);
		push @all, $nums[0];
		push @col1, $nums[1];
		push @col2, $nums[2];
	}
	push @all, @col1; # push second column onto first
	push @all, @col2; # push third column onto the first and second
	
	while (scalar @all > 0) {
		my @sides = (pop(@all), pop(@all), pop(@all)); # take three numbers
		@sides = sort { $a <=> $b } @sides;
		if ($sides[0] + $sides[1] > $sides[2]) {
			push(@possible, \@sides);
		}
	}
	
	say "Part Two: the number of possible triangles is " . (scalar @possible);
}
