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

my $content = $input[0];

say "Advent of Code 2016, Day 09: Explosives in Cyberspace";
#say $content;

our $re = qr/(\((\d+)x(\d+)\))/;

solve_part_one($content);
solve_part_two($content);

exit( 0 );

sub solve_part_one($content) {
	my $result = decompress( $content, 0 );
	say "Part One: the decompressed length is " . length($result);
}

sub solve_part_two($content) {
	my $result = decompress( $content, 1 );
	say "Part Two: the decompressed length is $result";
}

# This function returns the decompressed string if $recurse is false.
# It returns only the LENGTH of the decompressed string if $recurse is true.
sub decompress( $content, $recurse ) {
	#say "Decompressing $content";
	my @builder = ();		# For non-recursive
	my $result_length = 0;	# For recursive
	my $index = 0;
	
	while ( $content =~ m/$re/g) {
		my $marker = $1;
		my $marker_length = length($marker);
		my $length = $2;
		my $repeat = $3;
		my $end_match_index = pos($content);
		my $prefix_size = $end_match_index - ($index+$marker_length);
		
		my $prefix = substr($content, $index, $prefix_size);
		my $data = substr($content, $end_match_index, $length);
		
		if ($recurse) {
			$result_length += length($prefix);
			my $data_length += decompress( $data, 1 );
			$result_length += $data_length * $repeat;
		}
		else {
			push(@builder, $prefix);
			for (1 .. $repeat) {
				push(@builder, $data);
			}
		}
		
		# Moving pos (the Perl regex pointer for global searches) to the end
		# of the match (i.e. the marker) plus the length of the data
		#say "Moving pos from $end_match_index to " . ($end_match_index + $length);
		$index = $end_match_index + $length;
		pos($content) = $index;
	}
	
	my $suffix_size = length($content) - $index;
	if ($recurse) {
		$result_length += $suffix_size;
		return $result_length;
	}
	else {
		push(@builder, substr($content, $index, $suffix_size));
		my $result = join('', @builder);
		#say $result;
		return $result;	
	}	
}