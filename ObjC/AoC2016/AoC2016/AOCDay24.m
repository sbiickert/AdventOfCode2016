//
//  AOCDay24.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCGrid2D.h"
#import "AOCStrings.h"

@implementation AOCDay24

- (AOCDay24 *)init {
	self = [super initWithDay:24 name:@"Air Duct Spelunking"];
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
	AOCGrid2D *maze = [self parseMaze:input];
	NSDictionary<NSNumber *, NSDictionary<NSNumber *, NSNumber *> *>*distances = [self getDistancesInMaze:maze];
	
	NSInteger shortestDistance = [self shortestTravellingSalesman:distances starting:@0 distanceSoFar:0 visited:[NSArray array]]; //442 too low
	return [NSString stringWithFormat: @"The shortest distance is %ld", shortestDistance];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return [NSString stringWithFormat: @"World"];
}

- (AOCGrid2D *)parseMaze:(NSArray<NSString *> *)input {
	AOCGrid2D *maze = [AOCGrid2D grid];
	
	for (NSInteger row = 0; row < input.count; row++) {
		NSArray<NSString *> *chars = [input[row] allCharacters];
		for (NSInteger col = 0; col < chars.count; col++) {
			[maze setObject:chars[col] atCoord:[AOCCoord2D x:col y:row]];
		}
	}
	
	//[maze print];
	return maze;
}

- (AOCCoord2D *)findCharacter:(NSString *)c inMaze:(AOCGrid2D *)maze {
	id found = [maze coordsWithValue:c].firstObject;
	return found;
}

- (NSDictionary<NSNumber *, NSDictionary<NSNumber *, NSNumber *> *>*)getDistancesInMaze:(AOCGrid2D *)maze {
	NSMutableDictionary<NSNumber *, NSMutableDictionary<NSNumber *, NSNumber *> *> *result = [NSMutableDictionary dictionary];
	
	for (int i = 0; i < 7; i++) {
		for (int j = i+1; j <= 7; j++) {
			AOCCoord2D *start = [self findCharacter:[NSString stringWithFormat:@"%d", i] inMaze:maze];
			AOCCoord2D *end = [self findCharacter:[NSString stringWithFormat:@"%d", j] inMaze:maze];
			NSNumber *iObj = [NSNumber numberWithInt:i];
			NSNumber *jObj = [NSNumber numberWithInt:j];
			if (start != nil && end != nil) {
				if ([result objectForKey:iObj] == nil) {
					result[iObj] = [NSMutableDictionary dictionary];
				}
				if ([result objectForKey:jObj] == nil) {
					result[jObj] = [NSMutableDictionary dictionary];
				}
				NSNumber *length = [NSNumber numberWithInteger: [self findShortestPathLength:start to:end inMaze:maze wall:@"#"]];
				result[iObj][jObj] = length;
				result[jObj][iObj] = length;
			}
		}
	}
	
	return result;
}

- (NSInteger)findShortestPathLength:(AOCCoord2D *)from to:(AOCCoord2D *)to inMaze:(AOCGrid2D *)maze wall:(NSString *)wall {
	NSMutableSet<AOCCoord2D *> *visited = [NSMutableSet set];
	NSMutableSet<AOCCoord2D *> *toVisit = [NSMutableSet set];
	[toVisit addObject:from];
	
	BOOL found = NO;
	NSInteger result = 0;
	while (!found) {
		assert(toVisit.count > 0);
		NSMutableSet<AOCCoord2D *> *nextToVisit = [NSMutableSet set];
		for (AOCCoord2D *coord in toVisit) {
			if ([coord isEqualToCoord2D:to]) {
				found = YES;
				break;
			}
			NSArray<AOCCoord2D *> *neighbors = [maze adjacentTo:coord];
			for (AOCCoord2D *neighbour in neighbors) {
				if ([[maze stringAtCoord:neighbour] isEqualToString:wall] == NO && [visited containsObject:neighbour] == NO) {
					[nextToVisit addObject:neighbour];
				}
			}
			[visited addObject:coord];
		}
		toVisit = nextToVisit;
		result++;
	}
	return result-1; // Off by one
}

- (NSInteger)shortestTravellingSalesman:(NSDictionary<NSNumber *, NSDictionary<NSNumber *, NSNumber *> *>*)distances
							   starting:(NSNumber *)start
						  distanceSoFar:(NSInteger)distance
								visited:(NSArray<NSNumber *>*)visited {
	int nextVisitedCount = 0;
	NSInteger shortest = 1000000;
	for (NSNumber *next in [distances[start] allKeys]) {
		if ([visited containsObject:next] == NO) {
			NSMutableArray<NSNumber *> *vCopy = [visited mutableCopy];
			[vCopy addObject:start];
			NSInteger recursiveDistance = [self shortestTravellingSalesman:distances
																  starting: next
															 distanceSoFar:distance + [distances[start][next] integerValue]
																   visited:vCopy];
			if (recursiveDistance < shortest) {
				shortest = recursiveDistance;
			}
			nextVisitedCount++;
		}
	}
	if (nextVisitedCount == 0) {
		//[[NSString stringWithFormat: @"%ld: %@, %@", distance, [visited componentsJoinedByString:@", "], start] println];
		return distance;
	}
	return shortest;
}

@end
