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
use Digest::MD5 qw(md5_hex);

use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
#my $INPUT_FILE = 'day14_test.txt';
my $INPUT_FILE = 'day14_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 14: One-Time Pad";

our $salt = $input[0];

my $result1 = solve(0);
say "Part One: the 64th index is $result1";

my $result2 = solve(2016);
say "Part Two: the 64th index is $result2";

exit( 0 );

sub solve($additional_hashings) {
	my $current_index = 0;
	my @hashes = ();
	my %found_keys = ();
	my %triples = ();
	
	while ( scalar(keys %found_keys) < 64 ) {
		my $hash = md5_hex($salt.$current_index);
		for (1 .. $additional_hashings) {
			$hash = md5_hex($hash);
		}
		push(@hashes, $hash);
		
		if ( $hash =~ m/(.)\1{4}/ ) {
			# Found a five-of-a-kind
			my $triple = $1.$1.$1;
			if (exists( $triples{$triple} )) {
				# We are searching for this.
				for my $i (@{$triples{$triple}}) {
					if ($current_index - $i < 1000) {
						$found_keys{$i} = $hashes[$i];
					}
				}
				delete $triples{$triple};
			}
		}
		
		if ( $hash =~ m/((.)\2{2})/ ) {
			if (!exists($triples{$1})) {
				$triples{$1} = [];
			}
			push(@{ $triples{$1} }, $current_index);
		}
		
		$current_index++;
	}
	
	# my $count = 1;
# 	for my $index (sort {$a <=> $b} keys( %found_keys )) {
# 		say "$count: $index $found_keys{$index}";
# 		$count++;
# 	}
	
	my @found_key_indexes = sort {$a <=> $b} keys( %found_keys );
	return $found_key_indexes[63];
}

sub solve_part_two(@input) {

}
