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
	my @impossible = ();
	for my $line (@input) {
		$line =~ s/^\s+//; #left trim
		my @sides = split(/ +/, $line);
		@sides = sort { $a <=> $b } @sides;
		if ($sides[0] + $sides[1] > $sides[2]) {
			push(@possible, \@sides);
		}
		else {
			push(@impossible, \@sides);
		}
	}
	
	say "Part One: the number of possible triangles is " . (scalar @possible);
}

sub solve_part_two(@input) {

}
