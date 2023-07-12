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
#my $INPUT_FILE = 'day02_test.txt';
my $INPUT_FILE = 'day02_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 02: Bathroom Security";

our $dirs = {	"U" => c2_make(0,-1),
				"D" => c2_make(0, 1),
				"L" => c2_make(-1,0),
				"R" => c2_make( 1,0) };

my $code = solve(make_numpad_part_one(), c2_make(1,1), @input);
say "Part One: numpad code is $code";
$code = solve(make_numpad_part_two(), c2_make(0,2), @input);
say "Part Two: numpad code is $code";

exit( 0 );

sub solve($numpad, $loc, @lines) {
	my $code = "";
	foreach my $line (@lines) {
		my @moves = split(//, $line);
		foreach my $move (@moves) {
			my $newloc = c2_add($loc, $dirs->{$move});
			$loc = $newloc if g2_get($numpad, $newloc) ne ".";
		}
		$code .= g2_get($numpad, $loc);
	}
	return $code;
}

sub make_numpad_part_one {
	my $np = g2_make();
	g2_set($np, c2_make(0,0), "1");
	g2_set($np, c2_make(1,0), "2");
	g2_set($np, c2_make(2,0), "3");
	g2_set($np, c2_make(0,1), "4");
	g2_set($np, c2_make(1,1), "5");
	g2_set($np, c2_make(2,1), "6");
	g2_set($np, c2_make(0,2), "7");
	g2_set($np, c2_make(1,2), "8");
	g2_set($np, c2_make(2,2), "9");
	return $np;
}

sub make_numpad_part_two {
	my $np = g2_make();
	g2_set($np, c2_make(2,0), "1");
	g2_set($np, c2_make(1,1), "2");
	g2_set($np, c2_make(2,1), "3");
	g2_set($np, c2_make(3,1), "4");
	g2_set($np, c2_make(0,2), "5");
	g2_set($np, c2_make(1,2), "6");
	g2_set($np, c2_make(2,2), "7");
	g2_set($np, c2_make(3,2), "8");
	g2_set($np, c2_make(4,2), "9");
	g2_set($np, c2_make(1,3), "A");
	g2_set($np, c2_make(2,3), "B");
	g2_set($np, c2_make(3,3), "C");
	g2_set($np, c2_make(2,4), "D");
	return $np;
}