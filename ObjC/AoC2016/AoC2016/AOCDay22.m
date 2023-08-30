//
//  AOCDay22.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"
#import "AOCGrid2D.h"

@interface GridNode : NSObject <AOCGridRepresentable>

@property (class) NSInteger immovableSize;

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
	
	GridNode.immovableSize = 0;
	
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
	AOCGrid2D *grid = [self parseGrid:input];
	
	GridNode *goal = [self getNodeAt:[AOCCoord2D x:31 y:0] in:grid];
	goal.content = 59; // Unique amount, allowing tracking

	// World's most boring video game :-)
	[grid print]; // 195
	
	NSInteger count = 0;
	AOCCoord2D *empty = [self findEmptyNodeIn:grid];

	while ([self getNodeAt:[AOCCoord2D origin] in:grid].content != 59) {
		NSString *dir = [self getMoveDirection];
		if (dir != nil) {
			GridNode *source = [self getNodeAt:[empty offset:dir] in: grid];
			[source moveDataTo:[self getNodeAt:empty in:grid]];
			empty = [self findEmptyNodeIn:grid];
			[grid print];
			count++;
		}
		NSLog(@"Move count: %ld", count);
	}
	return [NSString stringWithFormat: @"The fewest number of moves is %ld", count];
}

- (AOCGrid2D *)parseGrid:(NSArray<NSString *> *)input {
	AOCGrid2D *grid = [AOCGrid2D grid];
	NSInteger sumSize = 0;
	NSInteger count = 0;
	
	for (NSString *line in input) {
		if ([[line allCharacters][0] isEqualToString:@"/"]) {
			GridNode *node = [[GridNode alloc] init:line];
			[grid setObject:node atCoord:node.coord];
			sumSize += node.size;
			count++;
		}
	}
	
	GridNode.immovableSize = sumSize / count;
	
	return grid;
}

- (GridNode *)getNodeAt:(AOCCoord2D *)coord in:(AOCGrid2D *)grid {
	NSObject *o = [grid objectAtCoord:coord];
	if ([o isKindOfClass:[GridNode class]]) {
		return (GridNode *)o;
	}
	return nil;
}

- (NSString *)getMoveDirection {
	NSFileHandle *stdin = NSFileHandle.fileHandleWithStandardInput;
	NSData *data = stdin.availableData;
	NSString *inStr = [[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] uppercaseString] allCharacters][0];
	if ([inStr isEqualToString:@"U"]) 	{	return UP;	}
	if ([inStr isEqualToString:@"D"]) 	{	return DOWN;	}
	if ([inStr isEqualToString:@"L"]) 	{	return LEFT;	}
	if ([inStr isEqualToString:@"R"]) 	{	return RIGHT;	}
	[NSString stringWithFormat:@"%@ is not a valid direction. U,D,L,R", inStr];
	return nil;
}

- (AOCCoord2D *)findEmptyNodeIn:(AOCGrid2D *)grid {
	for (AOCCoord2D *coord in grid.coords) {
		if ([self getNodeAt:coord in:grid].content == 0) {
			return coord;
		}
	}
	return nil;
}

@end

@implementation GridNode

static NSInteger _IMMOVABLE_SIZE = 0;

+ (NSInteger)immovableSize {
	return _IMMOVABLE_SIZE;
}

+ (void)setImmovableSize:(NSInteger)value {
	_IMMOVABLE_SIZE = value;
}

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


- (NSString *)stringRepresentation {
	if (self.content == 0) {
		return @" ";
	}
	if (self.content == 59) {
		return @"G";
	}
	if (self.size > GridNode.immovableSize) {
		return @"#";
	}
	return @".";
}

@end
