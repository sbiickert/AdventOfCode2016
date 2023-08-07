//
//  AoCDay01.m
//  AoC2016
//
//  Created by Simon Biickert on 2023-08-06.
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCCoord.h"
#import "AOCGrid2D.h"
#import "AOCStrings.h"

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
	AOCCoord2D *location = [AOCCoord2D origin];
	int facing = 0;
	
	for (NSString *instr in instructions) {
		int turn = [[instr substringToIndex: 1] isEqualToString:@"L"] ? -1 : 1;
		int dist = [[instr substringFromIndex:1] intValue];
		facing = (facing + turn + 4) % 4;
		location = [self move:location facing:facing by:dist];
	}
	
	NSInteger md = [location manhattanDistanceTo:[AOCCoord2D origin]];
	
	return [NSString stringWithFormat:@"The Manhattan distance to the office is %ld", md];
}

- (NSString *)solvePartTwo:(NSString *)input {
	AOCGrid2D *map = [AOCGrid2D grid];
	NSArray<NSString *> *instructions = [input componentsSeparatedByString:@", "];
	AOCCoord2D *location = [AOCCoord2D origin];
	int facing = 0;
	AOCCoord2D *crossing;
	
	[map setObject:@"X" atCoord:location];
	for (NSString *instr in instructions) {
		int turn = [[instr substringToIndex: 1] isEqualToString:@"L"] ? -1 : 1;
		int dist = [[instr substringFromIndex:1] intValue];
		facing = (facing + turn + 4) % 4;
		for (int i = 0; i < dist; i++) {
			location = [self move:location facing:facing by:1];
			if ([[map objectAtCoord:location] isEqualTo: @"X"]) {
				[map setObject:@"#" atCoord:location];
				crossing = location;
//				[map print];
				break;
			}
			[map setObject:@"X" atCoord:location];
		}
		if (crossing != nil) {
			break;
		}
		[map setObject:@"X" atCoord:location];
	}
	
	NSInteger md = [crossing manhattanDistanceTo:[AOCCoord2D origin]];
	

	return [NSString stringWithFormat:@"The Manhattan distance to the first location visited twice is %ld", md];
}



- (AOCCoord2D *)move:(AOCCoord2D *)location facing:(int)dir by:(int)dist {
	AOCCoord2D *result;
	if (dir == 0) {
		result = [location add:[AOCCoord2D x:0 y:dist]];
	}
	else if (dir == 1) {
		result = [location add:[AOCCoord2D x:dist y:0]];
	}
	else if (dir == 2) {
		result = [location add:[AOCCoord2D x:0 y:-1 * dist]];
	}
	else {
		result = [location add:[AOCCoord2D x:-1 * dist y:0]];
	}
	return result;
}

@end
