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
use AOC::Geometry;
use AOC::Grid;

my $INPUT_PATH = '../input';
#my $INPUT_FILE = 'day01_test.txt';
my $INPUT_FILE = 'day01_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 01: No Time for a Taxicab";

our @instr = parse_instructions($input[0]);
#print Dumper(@instr);

solve_part_one();
solve_part_two();

exit( 0 );

sub solve_part_one {
	my $loc = c2_make(0,0);
	my $dir = c2_make(0,-1);
	for (my $i = 0; $i <= $#instr; $i++) {
		$dir = turn($dir, $instr[$i][0]);
		for (my $j = 1; $j <= $instr[$i][1]; $j++) {
			$loc = c2_add($loc, $dir);
		}
	}
	my $md = c2_manhattan($loc, c2_make(0,0));
	say "Part One: The Easter Bunny Office is $md away.";
}

sub solve_part_two {
	my $loc = c2_make(0,0);
	my $dir = c2_make(0,-1);
	my $g = g2_make(".", "rook");
	g2_set($g, $loc, "O");
	
	for (my $i = 0; $i <= $#instr; $i++) {
		$dir = turn($dir, $instr[$i][0]);
		for (my $j = 1; $j <= $instr[$i][1]; $j++) {
			$loc = c2_add($loc, $dir);
			if (g2_get($g, $loc) ne ".") {
				#g2_print($g);
				my $md = c2_manhattan($loc, c2_make(0,0));
				say "Part Two: The Easter Bunny Office is $md away.";
				return;
			}
			g2_set($g, $loc, "X");
		}
	}
	die;
}

sub parse_instructions($input) {
	my @instr = split(/, /, $input);
	for (my $i = 0; $i <= $#instr; $i++) {
		$instr[$i] =~ m/([LR])(\d+)/;
		$instr[$i] = [$1, $2];
	}
	return @instr;
}

sub turn($dir, $lr) {
	#     [0,-1]
	#  [-1,0] [1,0]
	#     [0, 1]
	if ($dir->[0] == 0) {
		return $lr eq "L" ? c2_make($dir->[1], 0) : c2_make($dir->[1]*-1, 0);
	}
	return $lr eq "R" ? c2_make(0, $dir->[0]) : c2_make(0, $dir->[0]*-1);
}