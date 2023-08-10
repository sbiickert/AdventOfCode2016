//
//  AOCDay07.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@interface IPv7Address : NSObject

@property (readonly) NSArray<NSString *> *hypernetSequences;
@property (readonly) NSArray<NSString *> *supernetSequences;

- (IPv7Address *)init:(NSString *)value;

- (BOOL)supportsTLS;
- (BOOL)supportsSSL;
+ (BOOL)containsABBA:(NSString *)sequence;

@end

@implementation AOCDay07

- (AOCDay07 *)init {
	self = [super initWithDay:7 name:@"Internet Protocol Version 7"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSMutableArray<IPv7Address *> *addresses = [NSMutableArray array];
	for (NSString *line in input) {
		[addresses addObject:[[IPv7Address alloc] init:line]];
	}
	
	result.part1 = [self solvePartOne: addresses];
	result.part2 = [self solvePartTwo: addresses];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<IPv7Address *> *)addresses {
	NSInteger count = 0;
	for (IPv7Address *address in addresses) {
		if ([address supportsTLS]) {
			count++;
		}
	}
	return [NSString stringWithFormat: @"The number of addresses supporting TLS is %ld", count];
}

- (NSString *)solvePartTwo:(NSArray<IPv7Address *> *)addresses {
	NSInteger count = 0;
	for (IPv7Address *address in addresses) {
		if ([address supportsSSL]) {
			count++;
		}
	}
	return [NSString stringWithFormat: @"The number of addresses supporting SSL is %ld", count];
}

@end

@implementation IPv7Address

- (IPv7Address *)init:(NSString *)value
{
	self = [super init];
	
	NSString *temp = [value stringByReplacingOccurrencesOfString:@"]" withString:@"[" options:0 range:NSMakeRange(0, value.length)];
	NSArray<NSString *> *sequences = [temp componentsSeparatedByString:@"["];
	NSMutableArray<NSString *> *h = [NSMutableArray array];
	NSMutableArray<NSString *> *s = [NSMutableArray array];
	
	for (NSInteger i = 0; i < sequences.count; i++) {
		if (i % 2 == 0) {
			[s addObject:sequences[i]];
		}
		else {
			[h addObject:sequences[i]];
		}
	}
	
	_supernetSequences = s;
	_hypernetSequences = h;

	return self;
}

- (BOOL)supportsTLS {
	BOOL supports = NO;
	for (NSString *sequence in self.supernetSequences) {
		if ([IPv7Address containsABBA:sequence]) {
			supports = YES;
			break;
		}
	}
	for (NSString *sequence in self.hypernetSequences) {
		if ([IPv7Address containsABBA:sequence]) {
			supports = NO;
			break;
		}
	}
	return supports;
}

+ (BOOL)containsABBA:(NSString *)sequence {
	NSArray<NSString *> *matches = [sequence matchPattern:@"([a-z])([a-z])\\2\\1"];
	if (matches == nil) {
		return NO;
	}
	return [matches[1] isEqualToString:matches[2]] == NO;
}

- (BOOL)supportsSSL {
	NSMutableArray<NSString *> *abaList = [NSMutableArray array];
	for (NSString *sequence in self.supernetSequences) {
		NSString *str = sequence;
		NSArray<NSString *> *matches = [str matchPattern:@"(([a-z])[a-z]\\2)"];
		while (matches != nil) {
			NSArray<NSString *> *letters = [matches[1] allCharacters];
			if ([letters[0] isEqualToString:letters[1]] == NO) {
				[abaList addObject:matches[1]];
			}
			
			// Trim everything up to the second character of the match
			NSRange range = [str rangeOfString:matches[1]];
			str = [str substringFromIndex:range.location+1];
			
			matches = [str matchPattern:@"(([a-z])[a-z]\\2)"];
		}
	}
	
	for (NSString *sequence in self.hypernetSequences) {
		for (NSString *aba in abaList) {
			NSArray<NSString *> *letters = [aba allCharacters];
			NSString *bab = [NSString stringWithFormat:@"%@%@%@", letters[1], letters[0], letters[1]];
			if ([sequence rangeOfString:bab].location != NSNotFound) {
				return YES;
			}
		}
	}
	return NO;
}


@end
