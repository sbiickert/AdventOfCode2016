//
//  AoCDay01.m
//  AoC2016
//
//  Created by Simon Biickert on 2023-08-06.
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"

@implementation AOCDay01

- (AOCDay01 *)init {
	self = [super initWithDay:1 name:@"No Time for a Taxicab"];
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
	
	return @"Hello";
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return @"World";
}

@end
