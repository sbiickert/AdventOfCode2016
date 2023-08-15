//
//  AOCDay20.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"

@interface BlockingRange : NSObject

@property (readonly) NSRange range;

- (BlockingRange *)initWithString:(NSString *)value;
- (BlockingRange *)initWithRange:(NSRange)range;
- (NSComparisonResult)compare:(BlockingRange *)other;
- (BlockingRange *)unionWith:(BlockingRange *) other;
- (NSUInteger)upperBound;

@end

@implementation AOCDay20

- (AOCDay20 *)init {
	self = [super initWithDay:20 name:@"Firewall Rules"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSArray<BlockingRange *> *ranges = [self parseRanges:input];
	NSArray<BlockingRange *> *reduced = [self reduceRanges:ranges];

	result.part1 = [self solvePartOne: reduced];
	result.part2 = [self solvePartTwo: reduced];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<BlockingRange *> *)reduced {
	return [NSString stringWithFormat: @"The first allowed IP is %ld", [reduced[0] upperBound] + 1];
}

- (NSString *)solvePartTwo:(NSArray<BlockingRange *> *)reduced {
	NSInteger allowedCount = reduced[0].range.location; // Zero, but let's be dilligent
	
	for (NSInteger b = 1; b < reduced.count; b++) {
		allowedCount += reduced[b].range.location - [reduced[b-1] upperBound] - 1;
	}
	
	allowedCount += 4294967295 - [reduced.lastObject upperBound]; // 218 too high
	
	return [NSString stringWithFormat: @"The number of allowed IPs is %ld", allowedCount];
}

- (NSArray<BlockingRange *> *)parseRanges:(NSArray<NSString *> *)input {
	NSMutableArray<BlockingRange *> *ranges = [NSMutableArray array];
	
	for (NSString *line in input) {
		[ranges addObject:[[BlockingRange alloc] initWithString:line]];
	}
	[self sortRanges:ranges];
	return ranges;
}

- (void)sortRanges:(NSMutableArray<BlockingRange *> *)ranges {
	NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [obj1 compare:obj2];
	}];
	
	[ranges sortUsingDescriptors:@[sorter]];
}

- (NSArray<BlockingRange *> *)reduceRanges:(NSArray<BlockingRange *> *)ranges {
	NSMutableArray<BlockingRange *> *reduced = [NSMutableArray array];
	
	NSInteger ptr = 0;
	while (ptr < ranges.count) {
		BlockingRange *r = ranges[ptr];
		ptr++;
		if (ptr >= ranges.count) {break;}
		BlockingRange *u = [r unionWith:ranges[ptr]];
		while (u != nil) {
			r = u;
			ptr++;
			if (ptr >= ranges.count) {break;}
			u = [r unionWith:ranges[ptr]];
		}
		[reduced addObject:r];
	}
	return reduced;
}

@end

@implementation BlockingRange

- (BlockingRange *)initWithString:(NSString *)value {
	self = [super init];
	NSArray<NSString *> *split = [value componentsSeparatedByString:@"-"];
	NSUInteger loc = [split[0] integerValue];
	NSUInteger len = [split[1] integerValue] - loc;
	
	_range = NSMakeRange(loc, len);
	
	return self;
}

- (BlockingRange *)initWithRange:(NSRange)range {
	self = [super init];
	_range = range;
	return self;
}


- (NSComparisonResult)compare:(BlockingRange *)other {
	if (self.range.location == other.range.location) {
		if (self.range.length == other.range.length) {
			return NSOrderedSame;
		}
		else {
			return (self.range.length > other.range.length) ? NSOrderedAscending : NSOrderedDescending; // longest first
		}
	}
	return (self.range.location < other.range.location) ? NSOrderedAscending : NSOrderedDescending;
}

- (BlockingRange *)unionWith:(BlockingRange *) other {
	NSRange intersection = NSIntersectionRange(_range, other.range);
	if (intersection.length == 0 && other.range.location > [self upperBound] + 1) {
		return nil;
	}
	return [[BlockingRange alloc] initWithRange:NSUnionRange(_range, other.range)];
}

- (NSUInteger)upperBound {
	return _range.location + _range.length;
}

@end
