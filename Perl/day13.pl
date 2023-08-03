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
use Storable 'dclone';

use AOC::Util;
use AOC::Geometry;
use AOC::Grid;

my $INPUT_PATH = '../input';
#my $INPUT_FILE = 'day13_test.txt';
my $INPUT_FILE = 'day13_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 13: A Maze of Twisty Little Cubicles";

our $boss_number = $input[0];
our $start = c2_make(1,1);
our $goal = c2_make(split(',', $input[1]));

solve_part_one();
solve_part_two();

exit( 0 );

sub solve_part_one() {
	my $map = make_map( $goal );
	#g2_print($map);
	my $count = 0;
	my $min_steps;
	my @current = ($start);
	while (!defined $min_steps) {
		my %next = ();
		while (scalar(@current) > 0) {
			my $pos = pop(@current);
			if (g2_get($map, $pos) eq "G") {
				$min_steps = $count;
				last;
			}
			g2_set($map, $pos, $count);
			for my $n (g2_neighbors($map, $pos)) {
				if (!is_positive_coord($n)) { next; }
				my $value = g2_get($map, $n);
				if ($value eq g2_default($map)) {
					expand_map_by($map, 5, 5);
					$value = g2_get($map, $n);
				}
				if ($value eq ' ' || $value eq 'G') {
					$next{c2_to_str($n)} = $n;
				}
			}
		
		}
		$count++;
		@current = values %next;
	}
	
	say "Part One: the min steps to reach goal is $min_steps.";
}

sub solve_part_two(@input) {
	my $map = make_map( c2_make(100,100) );
	my $count = 0;
	my @current = ($start);
	while ($count <= 50) {
		my %next = ();
		while (scalar(@current) > 0) {
			my $pos = pop(@current);
			g2_set($map, $pos, $count);
			for my $n (g2_neighbors($map, $pos)) {
				if (!is_positive_coord($n)) { next; }
				my $value = g2_get($map, $n);
				if ($value eq g2_default($map)) {
					expand_map_by($map, 5, 5);
					$value = g2_get($map, $n);
				}
				if ($value eq ' ' || $value eq 'G') {
					$next{c2_to_str($n)} = $n;
				}
			}
		
		}
		$count++;
		@current = values %next;
	}
	
	my $hist = g2_histogram($map);
	my $sum = 0;
	for my $k (keys %{$hist}) {
		$sum += $hist->{$k} if ( $k =~ m/\d+/ );
	}
	
	say "Part Two: the number of reachable squares in 50 steps is $sum.";
}

sub make_map($c_max) {
	my $map = g2_make();
	expand_map($map, $c_max);
	g2_set($map, $start, '0');
	g2_set($map, $goal, 'G');
	return $map;
}

sub expand_map($map, $c_max) {
	my $ext = dclone(g2_extent($map));
	for my $x (0 .. $c_max->[0]) {
		for my $y (0 .. $c_max->[1]) {
			if (!e2_contains($ext, c2_make($x, $y))) {
				my $is_wall = is_wall($x, $y);
				g2_set($map, c2_make($x, $y), $is_wall ? "#" : " ");
			}
		}
	}
}

sub expand_map_by($map, $x, $y) {
	my $ext = g2_extent($map);
	my $c_max = e2_max($ext);
	my $new_max = c2_add($c_max, c2_make($x, $y));
	expand_map($map, $new_max);
}

sub is_wall($x, $y) {
	my $value = $x*$x + 3*$x + 2*$x*$y + $y + $y*$y + $boss_number;
	my $bin = sprintf ("%b", $value);
	my @bits = split(//, $bin);
	my @ones = grep(/1/, @bits);
	return scalar(@ones) % 2;
}

sub is_positive_coord($c) {
	return $c->[0] >= 0 && $c->[1] >= 0;
}
