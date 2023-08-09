//
//  AOCStrings.m
//  AoC2017
//
//  Created by Simon Biickert .
//

#import <Foundation/Foundation.h>
#import "AOCStrings.h"

@implementation NSString (AOCString)

+ (NSString *)binaryStringFromInteger:(int)number width:(int)width
{
	NSMutableString * string = [[NSMutableString alloc] init];

	int binaryDigit = 0;
	int integer = number;
	
	while( binaryDigit < width )
	{
		binaryDigit++;
		[string insertString:( (integer & 1) ? @"1" : @"0" )atIndex:0];
		integer = integer >> 1;
	}
	
	return string;
}


-(NSArray<NSString *> *)allCharacters {
	NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self length]];
	for (int i=0; i < [self length]; i++) {
		NSString *ichar  = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
		[characters addObject:ichar];
	}
	return characters;
}

- (void)print
{
	printf("%s", [self cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)println
{
	printf("%s\n", [self cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)stringByReplacingWithPattern:(NSString *)pattern withTemplate:(NSString *)withTemplate error:(NSError **)error {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
																		   options:NSRegularExpressionCaseInsensitive
																			 error:error];
	return [regex stringByReplacingMatchesInString:self
										   options:0
											 range:NSMakeRange(0, self.length)
									  withTemplate:withTemplate];
}

- (BOOL)isAllDigits
{
	NSMutableCharacterSet* nonNumbers = [[[NSCharacterSet decimalDigitCharacterSet] invertedSet] mutableCopy];
	[nonNumbers removeCharactersInString:@"-"];
	NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
	return r.location == NSNotFound && self.length > 0;
}

- (NSArray<NSString *> *)splitOnSpaces {
	NSPredicate *p = [NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
		return [[object description] isEqualToString:@""] == NO;
	}];
	NSArray<NSString *> *strings = [[self componentsSeparatedByString:@" "] filteredArrayUsingPredicate:p];
	return strings;
}

- (NSArray<NSNumber *> *)integersFromCSV {
	NSArray<NSString *> *strings = [self componentsSeparatedByString:@","];
	NSMutableArray<NSNumber *> *numbers = [NSMutableArray array];
	[strings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[numbers addObject:[NSNumber numberWithInteger:[[obj description] integerValue]]];
	}];
	return numbers;
}

- (NSArray<NSString *> *)match:(NSString *)pattern {
	NSMutableArray<NSString *> *result = nil;
	NSError *err;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&err];
	long n = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
	if (n > 0) {
		NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
		result = [NSMutableArray array];
		
		for (NSTextCheckingResult *match in matches) {
			NSString *matchText = [self substringWithRange:[match range]];
			[result addObject:matchText];
			if (regex.numberOfCaptureGroups > 0) {
				for (NSUInteger i = 1; i <= regex.numberOfCaptureGroups; i++) {
					matchText = [self substringWithRange:[match rangeAtIndex:i]];
					[result addObject:matchText];
				}
			}
		}
	}
	return result == nil ? nil : [NSArray arrayWithArray:result];
}

- (NSDictionary<NSString *, NSNumber *> *)histogram {
	NSDictionary<NSString *, NSNumber *> *result = [NSMutableDictionary dictionary];
	
	for (NSString *c in [self allCharacters]) {
		if ([result.allKeys containsObject:c] == NO) {
			[result setValue:@0 forKey:c];
		}
		NSInteger count = [[result valueForKey:c] integerValue] + 1;
		[result setValue:[NSNumber numberWithInteger:count] forKey:c];
	}
	
	return result;
}

@end
