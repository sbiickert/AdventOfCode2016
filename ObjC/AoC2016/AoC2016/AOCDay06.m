//
//  AOCDay06.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@implementation AOCDay06

- (AOCDay06 *)init {
	self = [super initWithDay:6 name:@"Signals and Noise"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *rows = [AOCInput readGroupedInputFile:filename atIndex:index];
	NSArray<NSString *> *columns = [self rowsToColumns:rows];

	result.part1 = [self solvePartOne: columns];
	result.part2 = [self solvePartTwo: columns];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSString *> *)input {
	NSMutableString *builder = [NSMutableString string];
	
	for (NSString *column in input) {
		NSArray<NSString *> *mostLeast = [self mostAndLeastCommonLetter:column];
		[builder appendString:mostLeast[0]];
	}
	
	return [NSString stringWithFormat: @"The error-corrected message is: %@", builder];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	NSMutableString *builder = [NSMutableString string];
	
	for (NSString *column in input) {
		NSArray<NSString *> *mostLeast = [self mostAndLeastCommonLetter:column];
		[builder appendString:mostLeast[1]];
	}
	
	return [NSString stringWithFormat: @"The error-corrected message is: %@", builder];
}

- (NSArray<NSString *> *)rowsToColumns:(NSArray<NSString *> *)rows {
	NSMutableArray<NSMutableString *> *columns = [NSMutableArray array];
	
	for (NSString *row in rows) {
		NSArray<NSString *> *chars = [row allCharacters];
		for (int i = 0; i < chars.count; i++) {
			if (i >= columns.count) {
				[columns addObject:[NSMutableString string]];
			}
			[columns[i] appendString:chars[i]];
		}
	}
	return columns;
}

- (NSArray<NSString *> *)mostAndLeastCommonLetter:(NSString *)str {
	NSDictionary<NSString *, NSNumber *> *hist = [str histogram];
	NSMutableArray<NSString *> *letters = [[hist allKeys] mutableCopy];
	
	NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [[hist valueForKey:obj1] compare:[hist valueForKey:obj2]];
	}];
	
	[letters sortUsingDescriptors:@[highestToLowest]];
	return @[letters[0], letters[letters.count-1]];
}

@end
