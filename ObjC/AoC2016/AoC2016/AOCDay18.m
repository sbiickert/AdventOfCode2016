//
//  AOCDay18.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCGrid2D.h"
#import "AOCStrings.h"

@implementation AOCDay18

- (AOCDay18 *)init {
	self = [super initWithDay:18 name:@"Like a Rogue"];
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
	AOCGrid2D *map = [self createMap:input];
	
	NSInteger nRows = map.extent.width; // Default square
	if (map.extent.width == 100) {
		nRows = 40;
	}

	[self populateMap:map rows:nRows];
	//[map print];
	NSInteger safeCount = [map coordsWithValue:@"."].count;
	return [NSString stringWithFormat: @"The number of safe tiles is %ld", safeCount];
}

- (NSString *)solvePartTwo:(NSString *)input {
	NSInteger nRows = 400000;
	NSInteger nCols = input.length;
	NSInteger safeCount = 0; // 3224145 too low, 21999993 too high
	NSArray<NSString *> *firstRow = [input allCharacters];
	
	// Switched from using NSString and NSArray to an array of ints for speed
	// 0 = safe, 1 = trap
	int prevRow[nCols];
	int thisRow[nCols];
	for (int i = 0; i < nCols; i++) {
		if ([firstRow[i] isEqualToString:@"."]) {
			safeCount++;
			prevRow[i] = 0;
		}
		else {
			prevRow[i] = 1;
		}
	}
		
	for (NSInteger r = 1; r < nRows; r++) {
		for (NSInteger c = 0; c < nCols; c++) {
			int left =   (c > 0) ? prevRow[c-1] : 0;
			int center = prevRow[c];
			int right =  (c < nCols - 1) ? prevRow[c+1] : 0;
			
			BOOL isTrap = (left == 1 && center == 1 && right == 0) ||
						  (left == 0 && center == 1 && right == 1) ||
						  (left == 1 && center == 0 && right == 0) ||
						  (left == 0 && center == 0 && right == 1);
			thisRow[c] = isTrap ? 1 : 0;
			if (!isTrap) { safeCount++; }
		}
		
		for (NSInteger c = 0; c < nCols; c++) {
			prevRow[c] = thisRow[c];
		}
	}
	
	return [NSString stringWithFormat: @"The number of safe tiles is %ld", safeCount];
}

- (AOCGrid2D *)createMap:(NSString *)firstRow {
	AOCGrid2D *map = [[AOCGrid2D alloc] initWithDefault:@"." adjacency:QUEEN];
	NSArray<NSString *> *letters = [firstRow allCharacters];
	for (NSInteger x = 0; x < letters.count; x++) {
		[map setObject:letters[x] atCoord:[AOCCoord2D x:x y:0]];
	}
	return map;
}

- (void)populateMap:(AOCGrid2D *)map rows:(NSInteger)nRows {
	for (NSInteger row = 1; row < nRows; row++) { // square map, so use width to define n rows
		for (NSInteger col = 0; col < map.extent.width; col++) {
			NSString *left =   [map stringAtCoord:[AOCCoord2D x:col-1 y:row-1]];
			NSString *center = [map stringAtCoord:[AOCCoord2D x:col+0 y:row-1]];
			NSString *right =  [map stringAtCoord:[AOCCoord2D x:col+1 y:row-1]];
			
			BOOL isTrap = ([left isEqualToString:@"^"] && [center isEqualToString:@"^"] && [right isEqualToString:@"."]) ||
						  ([left isEqualToString:@"."] && [center isEqualToString:@"^"] && [right isEqualToString:@"^"]) ||
						  ([left isEqualToString:@"^"] && [center isEqualToString:@"."] && [right isEqualToString:@"."]) ||
						  ([left isEqualToString:@"."] && [center isEqualToString:@"."] && [right isEqualToString:@"^"]);
			[map setObject:(isTrap ? @"^" : @".") atCoord:[AOCCoord2D x:col y:row]];
		}
	}
}

@end
