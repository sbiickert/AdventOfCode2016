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
use Digest::MD5 qw(md5_hex);
#use Storable 'dclone';

use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
#my $INPUT_FILE = 'day05_test.txt';
my $INPUT_FILE = 'day05_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 05: How About a Nice Game of Chess?";

solve_part_one($input[0]);
solve_part_two($input[0]);

exit( 0 );

sub solve_part_one($input) {
	my $index = 0;
	my @chars = ();
	
	while (scalar(@chars) < 8) {
		my $hash = md5_hex($input . $index);
		if ($hash =~ m/^00000(.)/) {
			push(@chars, $1);
			say "$hash: " . join('', @chars);
		}
		$index++;
	}
	
	say "Part One: the password is " . join('', @chars);
}

sub solve_part_two($input) {
	my $index = 0;
	my @chars = ("_") x 8;
	my $count = 0;
	
	while ($count < 8) {
		my $hash = md5_hex($input . $index);
		if ($hash =~ m/^00000(\d)(.)/) {
			my $pos = $1;
			my $char = $2;
			if (defined($chars[$pos]) && $chars[$pos] eq "_") {
				$chars[$pos] = $char;
				say "$hash: " . join('', @chars);
				$count++;
			}
		}
		$index++;
	}
	
	say "Part Two: the password is " . join('', @chars);
}
