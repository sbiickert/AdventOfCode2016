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
- (void)takeGifts;
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
	GameElf *current = [[GameElf alloc] initWithID:1 andPrevious:nil];
	GameElf *previous = current;
	GameElf *elf;
	for (NSInteger i = 1; i < [input integerValue]; i++) {
		elf = [[GameElf alloc] initWithID:previous.elfID+1 andPrevious:previous];
		previous = elf;
	}
	current.prev = elf;
	elf.next = current;
	
	while ([current.next isEqualTo:current] == NO) {
		[current takeGifts];
		if (current.next.giftCount == 0) {
			[current.next removeFromCircle];
		}
		current = current.next;
	}
	
	return [NSString stringWithFormat: @"The last elf is #%ld with %ld gifts", current.elfID, current.giftCount];
}

- (NSString *)solvePartTwo:(NSString *)input {
	
	return [NSString stringWithFormat: @"World"];
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

- (void)takeGifts {
	self.giftCount += self.next.giftCount;
	self.next.giftCount = 0;
}

- (GameElf *)removeFromCircle {
	GameElf *previous = self.prev;
	GameElf *next = self.next;
	previous.next = next;
	next.prev = previous;
	return previous;
}


@end
