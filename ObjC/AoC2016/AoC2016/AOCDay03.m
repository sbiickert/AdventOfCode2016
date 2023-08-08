//
//  AOCDay03.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@implementation AOCDay03 {
	NSSortDescriptor *highestToLowest;
}

- (AOCDay03 *)init {
	self = [super initWithDay:3 name:@"Squares With Three Sides"];
	highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
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
	int validCount = 0;
	
	for (NSString *line in input) {
		NSMutableArray<NSNumber *> *triangle = [self parseNumbers:line];
		[triangle sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];

		if ([triangle[0] integerValue] < ([triangle[1] integerValue] + [triangle[2] integerValue])) {
			validCount++;
		}
	}
	
	return [NSString stringWithFormat:@"The number of valid triangles is %d", validCount];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	NSMutableArray<NSMutableArray<NSNumber *> *> *triangles = [NSMutableArray array];
	for (int i = 0; i < input.count; i++) {
		[triangles addObject: [NSMutableArray array]];
	}
	
	int index = 0;
	int lineNumber = 0;
	
	for (NSString *line in input) {
		NSArray<NSNumber *> *numbers = [self parseNumbers:line];
		[triangles[index + 0] addObject:numbers[0]];
		[triangles[index + 1] addObject:numbers[1]];
		[triangles[index + 2] addObject:numbers[2]];
		lineNumber++;
		if (lineNumber % 3 == 0) {
			index += 3;
		}
	}
	
	int validCount = 0;
	for (NSMutableArray<NSNumber *> *triangle in triangles) {
		[triangle sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
		if ([triangle[0] integerValue] < ([triangle[1] integerValue] + [triangle[2] integerValue])) {
			validCount++;
		}
	}

	return [NSString stringWithFormat:@"The number of valid triangles is %d", validCount];
}

- (NSMutableArray<NSNumber *> *)parseNumbers:(NSString *)line {
	NSArray<NSString *> *strings = [line splitOnSpaces];
	NSMutableArray<NSNumber *> *numbers = [NSMutableArray array];
	[strings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[numbers addObject:[NSNumber numberWithInteger:[[obj description] integerValue]]];
	}];
	return numbers;
}

@end
