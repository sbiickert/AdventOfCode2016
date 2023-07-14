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
#my $INPUT_FILE = 'day06_test.txt';
my $INPUT_FILE = 'day06_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 06: Signals and Noise";

solve(@input);

exit( 0 );

sub solve(@input) {
	my @most_frequent = ();
	my @least_frequent = ();
	my $message_length = length($input[0]);
	my $col = 0;
	while ($col < $message_length) {
		my %hist = ();
		for my $line (@input) {
			$hist{substr($line, $col, 1)}++;
		}
		my @chars = keys(%hist);
		my @sorted = sort {$hist{$b} <=> $hist{$a}} @chars;
		push(@most_frequent, $sorted[0]);
		push(@least_frequent, $sorted[$#sorted]);
		$col++;
	}
	
	my $message = join('', @most_frequent);
	say "Part One: the message is $message";
	$message = join('', @least_frequent);
	say "Part Two: the message is $message";
}
