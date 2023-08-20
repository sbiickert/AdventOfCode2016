//
//  AOCDay22.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"
#import "AOCGrid2D.h"

@interface GridNode : NSObject

@property (readonly) NSString *nodeID;
@property (readonly) AOCCoord2D *coord;
@property (readonly) NSInteger size;
@property NSInteger content;

- (GridNode *)init:(NSString *)dfInfo;

- (NSInteger)available;
- (NSInteger)percentFull;
- (BOOL)isViablePairWith:(GridNode *)target;
- (BOOL)canMoveDataTo:(GridNode *)target;
- (void)moveDataTo:(GridNode *)target;

@end

@implementation AOCDay22

- (AOCDay22 *)init {
	self = [super initWithDay:22 name:@"Grid Computing"];
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
	AOCGrid2D *grid = [self parseGrid:input];
	
	NSMutableSet<NSString *> *viablePairs = [NSMutableSet set];
	
	NSArray<AOCCoord2D *> *coords = [grid coords];
	for (NSInteger i = 0; i < coords.count - 1; i++) {
		GridNode *g1 = (GridNode *)[grid objectAtCoord:coords[i]];
		for (NSInteger j = i+1; j < coords.count; j++) {
			GridNode *g2 = (GridNode *)[grid objectAtCoord:coords[j]];
			if ([g1 isViablePairWith:g2]) {
				NSString *relation = [NSString stringWithFormat:@"%@ -> %@", g1.nodeID, g2.nodeID];
				[viablePairs addObject:relation];
			}
			else if ([g2 isViablePairWith:g1]) {
				NSString *relation = [NSString stringWithFormat:@"%@ -> %@", g2.nodeID, g1.nodeID];
				[viablePairs addObject:relation];
			}
		}
	}

	return [NSString stringWithFormat: @"The number of viable pairs is %ld", viablePairs.count]; // 318 is too low
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return [NSString stringWithFormat: @"World"];
}

- (AOCGrid2D *)parseGrid:(NSArray<NSString *> *)input {
	AOCGrid2D *grid = [AOCGrid2D grid];
	
	for (NSString *line in input) {
		GridNode *node = [[GridNode alloc] init:line];
		[grid setObject:node atCoord:node.coord];
	}
	
	return grid;
}

@end

@implementation GridNode

- (GridNode *)init:(NSString *)dfInfo {
	self = [super init];
	
	NSArray<NSString *> *matches = [dfInfo matchPattern:@"node-x(\\d+)-y(\\d+) +(\\d+)T +(\\d+)T"];
	_coord = [AOCCoord2D x:[matches[1] integerValue] y:[matches[2] integerValue]];
	_nodeID = [NSString stringWithFormat:@"%ld-%ld", self.coord.x, self.coord.y];
	_size = [matches[3] integerValue];
	_content = [matches[4] integerValue];
	
	return self;
}

- (NSInteger)available {
	return _size - _content;
}

- (NSInteger)percentFull {
	return round( (double)_content / (double)_size);
}

- (BOOL)isViablePairWith:(GridNode *)target {
	return (self.content > 0) && (target.available > self.content);
}

- (BOOL)canMoveDataTo:(GridNode *)target {
	return (target.available > self.content) &&
	([target.coord manhattanDistanceTo:self.coord] == 1);
}

- (void)moveDataTo:(GridNode *)target {
	assert([self canMoveDataTo:target]);
	target.content += self.content;
	self.content = 0;
}


@end
