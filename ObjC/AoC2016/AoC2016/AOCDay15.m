//
//  AOCDay15.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@interface Disc : NSObject
- (Disc *)init:(NSString *)value;

@property (readonly) NSInteger number;
@property (readonly) NSInteger positionCount;
@property (readonly) NSInteger startPosition;

- (NSInteger)offsetAtZero;
- (BOOL)isAlignedAtTime:(NSInteger)time;

@end

@implementation AOCDay15

- (AOCDay15 *)init {
	self = [super initWithDay:15 name:@"Timing is Everything"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSMutableArray<Disc *> *discs = [NSMutableArray array];
	for (NSString *line in input) {
		[discs addObject:[[Disc alloc] init:line]];
	}
	// This was important!!!
	[discs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return ([obj1 positionCount] < [obj2 positionCount]) ? NSOrderedAscending : NSOrderedDescending;
	}];
	
	result.part1 = [self solvePartOne: discs];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<Disc *> *)discs {
	NSInteger step = discs[0].positionCount;
	NSInteger time = discs[0].offsetAtZero;
	for (NSInteger d = 1; d < discs.count; d++) {
		NSLog(@"Disc #%ld", d);
		while (YES) {
			if ([discs[d] isAlignedAtTime:time]) {
				step *= discs[d].positionCount;
				break;
			}
			time += step;
		}
	}
	return [NSString stringWithFormat: @"Discs aligned at time %ld", time];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return [NSString stringWithFormat: @"World"];
}

@end

@implementation Disc

- (Disc *)init:(NSString *)value {
	self = [super init];
	NSArray<NSString *> *matches = [value matchPattern:@"#(\\d+) has (\\d+).+position (\\d+)"];
	if (matches != nil) {
		_number = [matches[1] integerValue];
		_positionCount = [matches[2] integerValue];
		_startPosition = [matches[3] integerValue];
	}
	return self;
}

- (NSInteger)offsetAtZero {
	return (self.number + self.startPosition) % self.positionCount;
}

- (BOOL)isAlignedAtTime:(NSInteger)time {
	return ([self offsetAtZero] + time) % self.positionCount == 0;
}

@end
