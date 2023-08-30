//
//  AOCDay23.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"

@implementation AOCDay23

- (AOCDay23 *)init {
	self = [super initWithDay:23 name:@"Safe Cracking"];
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
	
	return [NSString stringWithFormat: @"Hello"];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return [NSString stringWithFormat: @"World"];
}

@end
