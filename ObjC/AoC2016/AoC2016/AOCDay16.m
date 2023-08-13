//
//  AOCDay16.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@implementation AOCDay16

- (AOCDay16 *)init {
	self = [super initWithDay:16 name:@"Dragon Checksum"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];

	NSArray<NSString *> *temp = [input[0] componentsSeparatedByString:@","];
	NSInteger diskSize = [temp[0] integerValue];
	NSString *data = temp[1];

	result.part1 = [self solvePart:data diskSize:diskSize];
	
	if (diskSize == 272) {
		diskSize = 35651584;
	}
	result.part2 = [self solvePart:data diskSize:diskSize];
	
	return result;
}

- (NSString *)solvePart:(NSString *)data diskSize:(NSInteger)diskSize {
	while (data.length < diskSize) {
		data = [self dragonCurve:data];
	}
	data = [data substringToIndex:diskSize];
	
	NSString *checkSum = [self checkSum:data];
	
	return [NSString stringWithFormat: @"The checksum is %@", checkSum];
}

- (NSString *)dragonCurve:(NSString *)a {
	NSString *b = [a reverse];
	NSMutableString *bBitFlipped = [NSMutableString string];
	[b enumerateSubstringsInRange:NSMakeRange(0,[b length])
						  options:(NSStringEnumerationByComposedCharacterSequences)
					   usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
										[bBitFlipped appendString:[substring isEqualToString:@"1"] ? @"0" : @"1"];
									}];
	return [NSString stringWithFormat:@"%@0%@", a, bBitFlipped];
}

- (NSString *)checkSum:(NSString *)data {
	NSMutableString *checkSum = [NSMutableString string];
	while (checkSum.length % 2 == 0) {
		checkSum = [NSMutableString string];
		for (int i = 0; i < data.length; i+=2) {
			BOOL areCharsEqual = [[data substringWithRange:NSMakeRange(i, 1)]
								  isEqualToString:[data substringWithRange:NSMakeRange(i+1, 1)]];
			[checkSum appendString: (areCharsEqual ? @"1" : @"0")];
		}
		data = checkSum;
	}
	return checkSum;
}

@end
