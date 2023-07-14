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
#my $INPUT_FILE = 'day07_test.txt';
my $INPUT_FILE = 'day07_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 07: Internet Protocol Version 7";

solve_part_one(@input);
solve_part_two(@input);

exit( 0 );

sub solve_part_one(@input) {
	my @supported = ();
	for my $line (@input) {
		my @ip = parse_ip($line);
		my $supports_tls = 0;
		for (my $i = 0; $i <= $#ip; $i++) {
			my $has_abba = find_abba($ip[$i]);
			if ($i % 2 == 0) {
				# Eval $ip[$i] as outside brackets (supernet)
				$supports_tls = 1 if $has_abba;
			}
			else {
				# Eval $ip[$i] as inside brackets (hypernet)
				$supports_tls = 0 if $has_abba;
				last if $has_abba;
			}
		}
		push(@supported, \@ip) if $supports_tls;
	}
	
	say "Part One: number of IPs supporting TLS: " . scalar(@supported);
}

sub solve_part_two(@input) {
	my @supported = ();
	for my $line (@input) {
		my $supports_ssl = find_aba_bab($line);
		push(@supported, $line) if $supports_ssl;
	}
	
	say "Part Two: number of IPs supporting SSL: " . scalar(@supported);
}

sub parse_ip($ip) {
	#hypernet [ ] blocks are even indexes
	return split(/[\[\]]/, $ip);
}

sub find_abba($str) {
	if ($str =~ m/([a-z])([a-z])\2\1/) {
		return $1 ne $2;
	}
	return 0;
}

sub find_aba_bab($str) {
	my @ip = parse_ip($str);
	my @aba_list = ();
	for (my $i = 0; $i <= $#ip; $i += 2) {
		my @matches = ();
		while ($ip[$i] =~ m/(([a-z])[a-z]\2)/g) {
			push(@matches, $1);
			my $p = pos($ip[$i]);
			pos($ip[$i]) = $p - 2; # rewind two characters
		}
		@matches = map {substr($_, 0, 1) ne substr($_, 1, 1) ? ($_) : ()} @matches;
		push(@aba_list, @matches);
	}
	
	my @bab_list = ();
	for (my $i = 1; $i <= $#ip; $i += 2) {
		for my $aba (@aba_list) {
			my $search = substr($aba,1,1) . substr($aba,0,1) . substr($aba,1,1);
			if ($ip[$i] =~ m/($search)/) {
				push(@bab_list, $1);
			}
		}
	}
	
	return scalar @bab_list;
}