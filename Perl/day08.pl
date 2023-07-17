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
#my $INPUT_FILE = 'day08_test.txt';
my $INPUT_FILE = 'day08_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 08: Two-Factor Authentication";

solve(@input);

exit( 0 );

sub solve(@input) {
	my $screen = init_screen(50, 6);
	if ($INPUT_FILE =~ m/test/) {
		$screen = init_screen(7,3);
	}
	for my $cmd (@input) {
		if ($cmd =~ m/^rect (\d+)x(\d+)/) {
			draw_rect($screen, e2_make(c2_make(0,0), c2_make($1-1, $2-1)));
		}
		elsif ($cmd =~ m/rotate column x=(\d+) by (\d+)/) {
			rotate_col($screen, $1, $2);
		}
		elsif ($cmd =~ m/rotate row y=(\d+) by (\d+)/) {
			rotate_row($screen, $1, $2);
		}
		#say "";
		#g2_print($screen);
	}
	my $lit_count = g2_histogram($screen)->{'#'};
	say "Part One: the number of lit pixels is $lit_count";
	say "Part Two:";
	g2_print($screen);
}

sub init_screen($cols, $rows) {
	my $screen = g2_make("0", "rook");
	for my $row ( 0 .. $rows-1 ) {
		for my $col ( 0 .. $cols-1 ) {
			g2_set($screen, c2_make($col, $row), '.');
		}
	}
	return $screen;
}

sub draw_rect($screen, $extent) {
	for my $c (e2_all_coords($extent)) {
		g2_set($screen, $c, '#');
	}
}

sub rotate_col($screen, $col, $count) {
	my @values = ();
	my $h = e2_height(g2_extent($screen)) - 1;
	for my $row (0 .. $h) {
		my $c = c2_make($col, $row);
		push(@values, g2_get($screen, $c));
	}
	rotate(\@values, $count);
	for my $row (0 .. $h) {
		my $c = c2_make($col, $row);
		g2_set($screen, $c, shift(@values));
	}
}

sub rotate_row($screen, $row, $count) {
	my @values = ();
	my $w = e2_width(g2_extent($screen)) - 1;
	for my $col (0 .. $w) {
		my $c = c2_make($col, $row);
		push(@values, g2_get($screen, $c));
	}
	rotate(\@values, $count);
	for my $col (0 .. $w) {
		my $c = c2_make($col, $row);
		g2_set($screen, $c, shift(@values));
	}
}

sub rotate($values, $count) {
	for (1 .. $count) {
		my $val = pop( @{$values} );
		unshift( @{$values}, $val);
	}
}