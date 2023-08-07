//
//  AoCDay01.m
//  AoC2016
//
//  Created by Simon Biickert on 2023-08-06.
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCPosition.h"
#import "AOCGrid2D.h"

@implementation AOCDay01

- (AOCDay01 *)init {
	self = [super initWithDay:1 name:@"No Time for a Taxicab"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSString *input = [AOCInput readGroupedInputFile:filename atIndex:index][0];
	
	result.part1 = [self solvePartOne: input];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)input {
	NSArray<NSString *> *instructions = [input componentsSeparatedByString:@", "];
	AOCPosition *pos = [AOCPosition origin];
	
	for (NSString *instr in instructions) {
		[pos rotate:instr];
		NSInteger dist = [[instr substringFromIndex:1] integerValue];
		[pos moveForward:dist];
	}
	
	NSInteger md = [pos.location manhattanDistanceTo:[AOCCoord2D origin]];
	
	return [NSString stringWithFormat:@"The Manhattan distance to the office is %ld", md];
}

- (NSString *)solvePartTwo:(NSString *)input {
	AOCGrid2D *map = [AOCGrid2D grid];
	NSArray<NSString *> *instructions = [input componentsSeparatedByString:@", "];
	AOCPosition *pos = [AOCPosition origin];
	AOCCoord2D *crossing;
	
	[map setObject:@"X" atCoord:pos.location];
	for (NSString *instr in instructions) {
		[pos rotate:instr];
		NSInteger dist = [[instr substringFromIndex:1] integerValue];
		for (NSInteger i = 0; i < dist; i++) {
			[pos moveForward:1];
			if ([[map objectAtCoord:pos.location] isEqualTo: @"X"]) {
				[map setObject:@"#" atCoord:pos.location];
				crossing = pos.location;
//				[map print];
				break;
			}
			[map setObject:@"X" atCoord:pos.location];
		}
		if (crossing != nil) {
			break;
		}
		[map setObject:@"X" atCoord:pos.location];
	}
	
	NSInteger md = [crossing manhattanDistanceTo:[AOCCoord2D origin]];

	return [NSString stringWithFormat:@"The Manhattan distance to the first location visited twice is %ld", md];
}

@end
