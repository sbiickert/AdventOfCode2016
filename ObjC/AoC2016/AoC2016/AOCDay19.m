//
//  AOCDay19.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"

@interface GameElf : NSObject

@property NSInteger elfID;
@property GameElf *prev;
@property GameElf *next;
@property NSInteger giftCount;

- (GameElf *)initWithID:(NSInteger)elfID andPrevious:(GameElf *)elf;
- (GameElf *)removeFromCircle;

@end

@implementation AOCDay19

- (AOCDay19 *)init {
	self = [super initWithDay:19 name:@"An Elephant Named Joseph"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePartOne: input[0]];
	result.part2 = [self solvePartTwo: input[0]];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)input {
	GameElf *current = [self buildRing:[input integerValue]];
	
	while ([current.next isEqualTo:current] == NO) {
		current.giftCount += current.next.giftCount;
		current.next.giftCount = 0;
		[current.next removeFromCircle];
		current = current.next;
	}
	
	return [NSString stringWithFormat: @"The last elf is #%ld with %ld gifts", current.elfID, current.giftCount];
}

- (NSString *)solvePartTwo:(NSString *)input {
	NSInteger elfCount = [input integerValue];
	GameElf *current = [self buildRing:elfCount];
	
	// Maintaining a second pointer "across the circle"
	GameElf *target = current;
	NSInteger skipCount = elfCount / 2;
	for (NSInteger i = 0; i < skipCount; i++) {
		target = target.next;
	}

	while ([current.next isEqualTo:current] == NO) {
		current.giftCount += target.giftCount;
		[target removeFromCircle];
		
		// Move the target pointer
		target = target.next;
		if (elfCount % 2 == 1) {
			target = target.next; // Skip a second if odd number of elves
		}
		
		elfCount--;
		current = current.next;
	}

	return [NSString stringWithFormat: @"The last elf is #%ld with %ld gifts", current.elfID, current.giftCount];
}

- (GameElf *)buildRing:(NSInteger)size {
	GameElf *current = [[GameElf alloc] initWithID:1 andPrevious:nil];
	GameElf *previous = current;
	GameElf *elf;
	for (NSInteger i = 1; i < size; i++) {
		elf = [[GameElf alloc] initWithID:previous.elfID+1 andPrevious:previous];
		previous = elf;
	}
	current.prev = elf;
	elf.next = current;
	return current;
}

@end

@implementation GameElf

- (GameElf *)initWithID:(NSInteger)elfID andPrevious:(GameElf *)elf {
	self = [super init];
	_elfID = elfID;
	_giftCount = 1;
	_prev = elf;
	elf.next = self;
	_next = nil;
	return self;
}

- (GameElf *)removeFromCircle {
	GameElf *previous = self.prev;
	GameElf *next = self.next;
	previous.next = next;
	next.prev = previous;
	return previous;
}


@end
