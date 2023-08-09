//
//  AOCStrings.h
//  AoC2017
//
//  Created by Simon Biickert .
//

@interface NSString (AOCString)

+ (NSString *)binaryStringFromInteger:(int)number width:(int)width;
- (NSArray<NSString *> *)allCharacters;
- (void)print;
- (void)println;
- (NSString *)stringByReplacingWithPattern:(NSString *)pattern withTemplate:(NSString *)withTemplate error:(NSError **)error;
- (BOOL)isAllDigits;
- (NSArray<NSString *> *)splitOnSpaces;
- (NSArray<NSNumber *> *)integersFromCSV;
- (NSArray<NSString *> *)match:(NSString *)pattern;
- (NSDictionary<NSString *, NSNumber *> *)histogram;

@end
