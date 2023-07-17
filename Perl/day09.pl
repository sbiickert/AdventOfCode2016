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
#my $INPUT_FILE = 'day09_test.txt';
my $INPUT_FILE = 'day09_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 09: Explosives in Cyberspace";

solve_part_one($input[0]);
#solve_part_two(@input);

exit( 0 );

sub solve_part_one($content) {
	#say $content;
	my @builder = ();
	my $index = 0;
	my $count;
	
	while ( $content =~ m/(\((\d+)x(\d+)\))/g) {
		my $marker = $1;
		my $marker_length = length($marker);
		my $length = $2;
		my $repeat = $3;
		my $end_match_index = pos($content);
		
		$count = $end_match_index - ($index+$marker_length);
		push(@builder, substr($content, $index, $count));
		
		for (1 .. $repeat) {
			push(@builder, substr($content, $end_match_index, $length));
		}
		#say "Moving pos from $end_match_index to " . ($end_match_index + $length);
		$index = $end_match_index + $length;
		pos($content) = $index;
	}
	
	$count = length($content) - $index;
	push(@builder, substr($content, $index, $count));
	
	my $result = join('', @builder);
	#say $result;
	say "Part One: the decompressed length is " . length($result);
}

sub solve_part_two(@input) {

}
