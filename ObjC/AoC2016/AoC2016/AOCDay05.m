//
//  AOCDay05.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@implementation AOCDay05

- (AOCDay05 *)init {
	self = [super initWithDay:5 name:@"How About a Nice Game of Chess?"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	NSString *prefix = input[0];
	
	result.part1 = [self solvePartOne: prefix];
	result.part2 = [self solvePartTwo: prefix];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)input {
	NSInteger i = 0;
	NSMutableArray<NSString *> *builder = [NSMutableArray array];
	NSString *format = @"%@%ld";
	
	while (builder.count < 8) {
		NSString *md5 = [[NSString stringWithFormat:format, input, i] md5Hex];
		if ([[md5 substringToIndex:5] isEqualToString:@"00000"]) {
			[builder addObject:[md5 allCharacters][5]];
		}
		i++;
	}
	
	return [NSString stringWithFormat: @"The password is %@", [builder componentsJoinedByString:@""]];
}

- (NSString *)solvePartTwo:(NSString *)input {
	NSInteger i = 0;
	NSMutableArray<NSString *> *builder = [NSMutableArray arrayWithArray:@[@"_",@"_",@"_",@"_",@"_",@"_",@"_",@"_"]];
	NSString *format = @"%@%ld";
	int foundCharacterCount = 0;

	// Using precompiled regex
	NSError *err;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^0{5}([0-7])(\\w)" options:0 error:&err];

	while (foundCharacterCount < 8) {
		NSString *md5 = [[NSString stringWithFormat:format, input, i] md5Hex];
		NSArray<NSString *> *matches = [md5 match:regex];
		
		if (matches != nil) {
			NSInteger slot = [matches[1] integerValue];
			if ([builder[slot] isEqualToString:@"_"]) {
				builder[slot] = matches[2];
				foundCharacterCount++;
				[[builder componentsJoinedByString:@""] println];
			}
		}
		i++;
	}
	
	return [NSString stringWithFormat: @"The password is %@", [builder componentsJoinedByString:@""]];
}

@end
