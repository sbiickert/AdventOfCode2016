//
//  AOCDay02.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCGrid2D.h"
#import "AOCStrings.h"

@implementation AOCDay02 {
	NSDictionary<NSString *, NSString *> *dirLookup;
}

- (AOCDay02 *)init {
	self = [super initWithDay:2 name:@"Bathroom Security"];
	dirLookup = @{@"U": UP, @"D": DOWN, @"L": LEFT, @"R": RIGHT};
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePartOne: input];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSString *> *)input {
	AOCGrid2D *keyPad = [AOCGrid2D grid];
	[keyPad setObject:@"1" atCoord:[AOCCoord2D x:0 y:0]];
	[keyPad setObject:@"2" atCoord:[AOCCoord2D x:1 y:0]];
	[keyPad setObject:@"3" atCoord:[AOCCoord2D x:2 y:0]];
	[keyPad setObject:@"4" atCoord:[AOCCoord2D x:0 y:1]];
	[keyPad setObject:@"5" atCoord:[AOCCoord2D x:1 y:1]];
	[keyPad setObject:@"6" atCoord:[AOCCoord2D x:2 y:1]];
	[keyPad setObject:@"7" atCoord:[AOCCoord2D x:0 y:2]];
	[keyPad setObject:@"8" atCoord:[AOCCoord2D x:1 y:2]];
	[keyPad setObject:@"9" atCoord:[AOCCoord2D x:2 y:2]];

	[keyPad print];

	AOCCoord2D *location = [AOCCoord2D x:1 y:1]; //5
	
	NSString *code = [self findCode:keyPad withInput:input startingAt:location];
	
	return [NSString stringWithFormat: @"The PIN code is %@", code];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	AOCGrid2D *keyPad = [AOCGrid2D grid];
	[keyPad setObject:@"1" atCoord:[AOCCoord2D x:2 y:0]];
	[keyPad setObject:@"2" atCoord:[AOCCoord2D x:1 y:1]];
	[keyPad setObject:@"3" atCoord:[AOCCoord2D x:2 y:1]];
	[keyPad setObject:@"4" atCoord:[AOCCoord2D x:3 y:1]];
	[keyPad setObject:@"5" atCoord:[AOCCoord2D x:0 y:2]];
	[keyPad setObject:@"6" atCoord:[AOCCoord2D x:1 y:2]];
	[keyPad setObject:@"7" atCoord:[AOCCoord2D x:2 y:2]];
	[keyPad setObject:@"8" atCoord:[AOCCoord2D x:3 y:2]];
	[keyPad setObject:@"9" atCoord:[AOCCoord2D x:4 y:2]];
	[keyPad setObject:@"A" atCoord:[AOCCoord2D x:1 y:3]];
	[keyPad setObject:@"B" atCoord:[AOCCoord2D x:2 y:3]];
	[keyPad setObject:@"C" atCoord:[AOCCoord2D x:3 y:3]];
	[keyPad setObject:@"D" atCoord:[AOCCoord2D x:2 y:4]];

	[keyPad print];
	
	AOCCoord2D *location = [AOCCoord2D x:0 y:2]; //5
	
	NSString *code = [self findCode:keyPad withInput:input startingAt:location];
	
	return [NSString stringWithFormat: @"The PIN code is %@", code];
}

- (NSString *)findCode:(AOCGrid2D *)keyPad withInput:(NSArray<NSString *> *)input startingAt:(AOCCoord2D *)location {
	NSMutableArray<NSString *> *code = [NSMutableArray array];
	
	for (NSString *line in input) {
		NSArray<NSString *> *moves = [line getAllCharacters];
		for (NSString *move in moves) {
			AOCCoord2D *nextKey = [location offset:[dirLookup valueForKey:move]];
			if ([[keyPad stringAtCoord:nextKey] isEqualToString: keyPad.defaultValue.description] == NO) {
				location = nextKey;
			}
		}
		[code addObject:[keyPad stringAtCoord:location]];
	}
	
	return [code componentsJoinedByString:@""];
}

@end
