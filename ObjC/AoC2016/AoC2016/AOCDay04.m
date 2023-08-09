//
//  AOCDay04.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@interface RoomCode : NSObject

@property NSString *encName;
@property NSInteger sectorID;
@property NSString *checksum;

- (RoomCode *) initWithName:(NSString *)name sectorID:(NSInteger)sector checksum:(NSString *)check;
- (NSString *) calcChecksum;
- (BOOL)isValid;

@end

@implementation AOCDay04 {
	NSString *pattern;
}

- (AOCDay04 *)init {
	self = [super initWithDay:4 name:@"Security Through Obscurity"];
	pattern = @"([a-z-]+)-(\\d+)\\[([a-z]+)\\]";
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
	NSInteger sum = 0;
	
	for (NSString *line in input) {
		NSArray<NSString *> *matches = [line match:pattern];
		if (matches == nil) {
			NSLog(@"Could not parse %@", line);
			continue;
		}
		RoomCode *rc = [[RoomCode alloc] initWithName:matches[1] sectorID:[matches[2] integerValue] checksum:matches[3]];
		if ([rc isValid]) {
			sum += rc.sectorID;
		}
	}
	return [NSString stringWithFormat: @"The sum of valid sector IDs is %ld", sum];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return [NSString stringWithFormat: @"World"];
}


@end

@implementation RoomCode

- (RoomCode *) initWithName:(NSString *)name sectorID:(NSInteger)sector checksum:(NSString *)check {
	self = [super init];
	
	_encName = name;
	_sectorID = sector;
	_checksum = check;
	
	return self;
}

- (NSString *)calcChecksum {
	NSMutableDictionary<NSString *, NSNumber *> *hist = [[self.encName histogram] mutableCopy];
	[hist removeObjectForKey:@"-"];
	
	NSSortDescriptor *byCount = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [[hist valueForKey:obj1] compare:[hist valueForKey:obj2]];
	}];
	NSSortDescriptor *byAlpha = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
	
	NSMutableArray<NSString *> *ordered = [NSMutableArray arrayWithArray: hist.allKeys];
	[ordered sortUsingDescriptors:@[byCount, byAlpha]];
	return [[ordered componentsJoinedByString:@""] substringToIndex:5];
}

- (BOOL)isValid {
	NSString *temp = [self calcChecksum];
	return [self.checksum isEqualToString:temp];
}

@end
