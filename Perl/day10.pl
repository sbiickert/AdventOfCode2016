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
#my $INPUT_FILE = 'day10_test.txt';
my $INPUT_FILE = 'day10_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 10: Balance Bots";

our @rules;
our @bots;
our @output;

my $bot_with_two_values = parse_input(@input);

solve_part_one($bot_with_two_values, 17, 61);
solve_part_two();

exit( 0 );

sub solve_part_one($bot_with_two_values, $test0, $test1) {
	my @queue = ($bot_with_two_values);
	my $handler = -1;
	while ( scalar(@queue) > 0 ) {
		$bot_with_two_values = shift(@queue);
		if ($bots[$bot_with_two_values][0] == $test0 && 
			$bots[$bot_with_two_values][1] == $test1 ) {
			$handler = $bot_with_two_values;
		}
		push( @queue, exec_rule($bot_with_two_values) );
	}
	say "Part One: the bot responsible for comparing $test0 and $test1 is $handler.";
}

sub solve_part_two() {
	say "Part Two: the product of output 0, 1 and 2 is " .
		($output[0] * $output[1] * $output[2]);
}

sub exec_rule($rule) {
	my @bots_with_two_values = ();
# 	say "$rule bot (" . join(',', @{$bots[$rule]}) . ') ' .
# 	 "lo -> $rules[$rule]{'lo_type'} $rules[$rule]{'lo'}, " . 
# 	 "hi -> $rules[$rule]{'hi_type'} $rules[$rule]{'hi'}";
	if ($rules[$rule]{'lo_type'} eq 'bot') {
		my $count = push_value_on_bot($bots[$rule][0], $rules[$rule]{'lo'});
		push( @bots_with_two_values, $rules[$rule]{'lo'} ) if $count == 2;
	}
	else {
		$output[$rules[$rule]{'lo'}] = $bots[$rule][0];
	}
	if ($rules[$rule]{'hi_type'} eq 'bot') {
		my $count = push_value_on_bot($bots[$rule][1], $rules[$rule]{'hi'});
		push( @bots_with_two_values, $rules[$rule]{'hi'} ) if $count == 2;
	}
	else {
		$output[$rules[$rule]{'hi'}] = $bots[$rule][1];
	}
	$bots[$rule] = undef;
	return @bots_with_two_values;
}

sub parse_input(@input) {
	my $bot_with_two_values;
	
	for my $line (@input) {
		if ( $line =~ m/(\d+) gives .+ (\w+) (\d+) .+ (\w+) (\d+)/ ) {
			my $rule = { 'lo_type' => $2, 'lo' => $3+0,
						 'hi_type' => $4, 'hi' => $5+0};
			$rules[$1] = $rule;
		}
		elsif ( $line =~ m/^value (\d+) goes to bot (\d+)/ ) {
			if (push_value_on_bot($1, $2) > 1) {
				$bot_with_two_values = $2;
			}
		}
	}
	return $bot_with_two_values;
}

sub push_value_on_bot($value, $index) {
	if ( !defined($bots[$index]) ) {
		$bots[$index] = [$value+0];
		return 1;
	}

	my @temp = ($bots[$index][0], $value);
	@temp = sort { $a <=> $b } @temp;
	$bots[$index] = \@temp;
	return 2;
}