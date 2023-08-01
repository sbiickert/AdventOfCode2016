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
#use Digest::MD5 qw(md5_hex);
use Math::Combinatorics qw(combine);
use Storable 'dclone';
no warnings 'recursion';

use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
#my $INPUT_FILE = 'day11_test.txt';
my $INPUT_FILE = 'day11_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2016, Day 11: Radioisotope Thermoelectric Generators";

my %state = parse_input(@input);

our $label_regex = qr/([cg])-(\w+)/;

solve_part_one(%state);
#solve_part_two(@input);

exit( 0 );

our %tried;
our $min_steps;

sub solve_part_one(%initial_state) {
	%tried = ();
	# Originally set to 1000000, but first tests allow for a lower starting limit
	$min_steps = 717; #67900;
	try_state(\%initial_state);
	
	say "Part One: reached goal in $min_steps.";
}

sub solve_part_two(@input) {

}

sub try_state($test_state) {
	$tried{$test_state->{'key'}} = $test_state->{'count'};
	
	my $estimate = theoretical_steps_to_complete($test_state);
	if ($test_state->{'count'} + $estimate >= $min_steps) {
		return 0;
	}
	if (is_state_complete($test_state)) {
		$min_steps = $test_state->{'count'};
		say "Reached goal in $min_steps.";
		#print_state($test_state);
		return 1;
	}
	
	my @states_to_try = valid_child_states($test_state);
	while (scalar @states_to_try > 0) {
		my $child_state = pop(@states_to_try);
		if (exists( $tried{$child_state->{'key'}} )) {
			if ($tried{$child_state->{'key'}} <= $child_state->{'count'}) {
				#say "already done.";
				next;
			}
		}
		last if try_state($child_state); # Only one child state can be complete. 
		say scalar(keys(%tried)) if scalar(keys(%tried)) % 1000 == 0;
	}
	return 0;
}

sub valid_child_states($s_ref) {
	my @states = ();
	my $current_floor = $s_ref->{'me'};
	
	# What are we taking on the elevator with us?
	my @taking = ();
	my @stuff_on_current_floor = keys(%{$s_ref->{'floors'}[$current_floor]});
	
	my @combinations = combine(2, @stuff_on_current_floor); # Two items
	push(@taking, @combinations);
	push(@taking, map { [$_] } @stuff_on_current_floor); # One item
	
	for my $dest_floor ($current_floor+1, $current_floor-1) {
		if ($dest_floor >= 0 && $dest_floor <= 3) {
			#print Dumper(@taking);
			for my $elevator_contents (@taking) {
#				say "Heading to floor $dest_floor with " . join(',', @{$elevator_contents});
				if (!will_fry($elevator_contents, $s_ref->{'floors'}[$dest_floor])) {
					my $new_state = make_child($s_ref, $elevator_contents, $dest_floor);
					push(@states, $new_state);
				}
			}
		}
	}
# 	say "Valid child states:";
# 	for my $s (@states) {
# 		print_state($s);
# 	}
# 	say "***************";
	return @states;
}

sub will_fry($elevator, $floor) {
	# if any chip without their generator is on a floor with a generator
	# $elevator is an array ref with 1 or 2 items (what you've got with you)
	# $floor is a hash ref of the contents on the floor you've arrived at
	my %everything = ();
	
	for my $elevator_content ( @{$elevator} ) {
		$everything{$elevator_content} = 1;
	}
	for my $label ( keys %{$floor} ) {
		$everything{$label} = 1;
	}
	
	my $is_unshielded_chip = 0;
	my $is_generator = 0;
	for my $label ( keys %everything ) {
		$label =~ m/$label_regex/;
		if ($1 eq 'c' && !exists( $everything{'g-'.$2} )) {
			$is_unshielded_chip = 1;
		}
		if ($1 eq 'g') {
			$is_generator = 1;
		}
	}
	
	
	#print Dumper($elevator, $floor, $is_unshielded_chip, $is_generator);
	
	return ($is_unshielded_chip && $is_generator);
}

sub make_child($s_ref, $elevator, $dest_floor) {
	# clone
	my $child = dclone($s_ref);
	
	# remove elevator contents from current floor
	# add elevator contents to dest floor 
	for my $e ( @{$elevator} ) {
		delete $child->{'floors'}[$child->{'me'}]{$e};
		$child->{'floors'}[$dest_floor]{$e} = 1;
	}

	# change floor
	$child->{'me'} = $dest_floor;
	
	# increment count
	$child->{'count'}++;
	
	# key, parent
	$child->{'key'} = state_key_str($child);
	$child->{'parent'} = $s_ref->{'key'};
	
# 	say "Original:";
# 	print_state($s_ref);
# 	say "Child:";
# 	print_state($child);
	
	return $child;
}

sub parse_input(@input) {
	my %state;
	$state{'me'} = 0; # Going with zero-based floor numbering
	$state{'count'} = 0; # The number of tried moves

	my @floors;
	
	for my $line (@input) {
		my %floor_info;
		my %stuff = ();
		$line =~ s/-compatible//g;
		while ( $line =~ m/a ([a-z]+) ([a-z]+)/g ) {
			my $element = $1;
			if ($2 eq 'microchip') {
				$stuff{'c-'.$element} = 1;
			}
			else {
				$stuff{'g-'.$element} = 1;
			}
		}
		push(@floors, \%stuff);
	}
	$state{'floors'} = \@floors;
	$state{'parent'} = '';
	$state{'key'} = state_key_str(\%state);
	
	return %state;
}

sub print_state($state) {
	say "Moves: $state->{'count'}";
	say "Key: $state->{'key'}";
	say "Parent: $state->{'parent'}";
	for (my $i = 3; $i >= 0; $i--) {
		print $i . ($state->{'me'} == $i ? " * " : "   ");
		my @sorted_keys = sort keys(%{$state->{'floors'}[$i]});
		say join(' ', @sorted_keys);
	}
	print "\n";
}

sub state_key_str($s_ref) {
	my @key = ($s_ref->{'me'});
	for my $i ( 0 .. 3 ) {
		push(@key, $i);
		my @sorted_keys = sort keys(%{$s_ref->{'floors'}[$i]});
		push(@key, join(',', @sorted_keys));
	}

	return join('|', @key);
	#return md5_hex(join('|', @key));
}

sub is_state_complete($s_ref) {
	for my $i (0 .. 2) {
		return 0 if (scalar keys (%{$s_ref->{'floors'}[$i]}) > 0);
	}
	return 1;
}

sub theoretical_steps_to_complete($s_ref) {
	# This is a very rough optimistic estimate to determine how many steps a state could
	# theoretically take to completion. Will allow pruning of states.
	my $estimate = 0;
	my $moved_count = 0;
	for my $i (0 .. 2) {
		# Each item in a floor has to move up 3 - $i floors.
		my $count_on_floor = scalar keys (%{$s_ref->{'floors'}[$i]});
		while ($moved_count < 2 && $count_on_floor > 0) {
			$estimate += (3 - $i);
			$moved_count++;
			$count_on_floor--;
		}
		$estimate += (3 - $i) * $count_on_floor * 2;
	}
	return $estimate;
}