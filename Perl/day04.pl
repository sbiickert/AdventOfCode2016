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
#my $INPUT_FILE = 'day04_test.txt';
my $INPUT_FILE = 'day04_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 04: Security Through Obscurity";

my @valid_rooms = solve_part_one(@input);
solve_part_two(@valid_rooms);

exit( 0 );

sub solve_part_one(@input) {
	my @valid_rooms = ();
	my $sector_id_sum = 0;
	for my $room (@input) {
		my %parsed = parse($room);
		if (is_valid($parsed{'name'}, $parsed{'checksum'})) {
			push(@valid_rooms, $room);
			$sector_id_sum += $parsed{'sector'};
		}
	}
	say "Part One: the sum of sector ids of valid rooms is " . $sector_id_sum;
	return @valid_rooms;
}

sub solve_part_two(@input) {
	my @LETTERS = split(//, 'abcdefghijklmnopqrstuvwxyz');
	my %index = ();
	for my $i (0 .. 25) {
		$index{ $LETTERS[$i] } = $i;
	}
	
	for my $room (@input) {
		my %parsed = parse($room);
		my @letters = ();
		for my $c (split(//, $parsed{'name'})) {
			if ($c eq '-') {
				push(@letters, ' ');
			}
			else {
				my $rotated = ($index{$c} + $parsed{'sector'}) % 26;
				push(@letters, $LETTERS[$rotated]);
			}
		}
		my $decrypted = join('', @letters);
		if ($decrypted eq 'northpole object storage') {
			say "Part Two: northpole object storage is in sector " . $parsed{'sector'};
			return;
		}
	}
}

sub is_valid($name, $checksum) {
	my %hist = ();
	$name =~ s/-//g;
	for my $c (split(//, $name)) {
		$hist{$c}++;
	}
	my @letters = sort {$hist{$b} <=> $hist{$a} || $a cmp $b} keys(%hist);
	my $calculated = join('', splice(@letters, 0, 5));
	return $calculated eq $checksum;
}

sub parse($room) {
	$room =~ m/([\w-]+)-(\d+)\[(\w+)\]/;
	my %info = ('name' => $1, 'sector' => $2, 'checksum' => $3);
	return %info;
}
