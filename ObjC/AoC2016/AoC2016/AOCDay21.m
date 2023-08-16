//
//  AOCDay21.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@interface ScrambleOp : NSObject

@property (readonly) NSString *defn;
@property (readonly) NSString *action;
@property (readonly) NSInteger pos1;
@property (readonly) NSInteger pos2;
@property (readonly) NSString *direction;
@property (readonly) NSString *letter1;
@property (readonly) NSString *letter2;

- (ScrambleOp *)init:(NSString *)defn;
- (NSString *)operateOn:(NSString *)str;
- (NSString *)operateOn:(NSString *)str inverted:(BOOL)inverted;

@end

@implementation AOCDay21

- (AOCDay21 *)init {
	self = [super initWithDay:21 name:@"Scrambled Letters and Hash"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSString *initialString = [input firstObject];
	NSMutableArray<ScrambleOp *> *ops = [NSMutableArray array];
	for (NSInteger i = 1; i < input.count; i++) {
		[ops addObject:[[ScrambleOp alloc] init:input[i]]];
	}
	
	result.part1 = [self solvePartOne:initialString operations:ops];
	
	// Testing:
//	for (ScrambleOp *testOp in ops) {
//		NSString *result = [testOp operateOn:@"abcdefgh" inverted:NO];
//		result = [testOp operateOn:result inverted:YES];
//		assert([result isEqualToString:@"abcdefgh"]);
//	}
	
	initialString = @"fbgdceah";
	result.part2 = [self solvePartTwo:initialString operations:ops];

	return result;
}

- (NSString *)solvePartOne:(NSString *)initialString operations:(NSArray<ScrambleOp *> *)ops {
	NSString *str = initialString;
	for (ScrambleOp *op in ops) {
		str = [op operateOn:str];
	}
	
	return [NSString stringWithFormat: @"The scrambled string is %@", str];
}

- (NSString *)solvePartTwo:(NSString *)initialString operations:(NSArray<ScrambleOp *> *)ops {
	NSString *str = initialString;
	for (ScrambleOp *op in [ops reverseObjectEnumerator]) {
		str = [op operateOn:str inverted:YES];
	}
	
	return [NSString stringWithFormat: @"The unscrambled string is %@", str]; //efhdgabc, efghdabc wrong
}

@end

@implementation ScrambleOp

- (ScrambleOp *)init:(NSString *)defn {
	self = [super init];

	_defn = defn;
	_pos1 = -1;
	_pos2 = -1;
	_letter1 = nil;
	_letter2 = nil;
	_direction = nil;
	
	NSArray<NSString *> *matches;
	
	matches = [defn matchPattern:@"^(swap position) (\\d+) with position (\\d+)"];
	if (matches != nil) {
		_action = matches[1];
		_pos1 = [matches[2] integerValue];
		_pos2 = [matches[3] integerValue];
		return self;
	}
	
	matches = [defn matchPattern:@"^(swap letter) ([a-z]) with letter ([a-z])"];
	if (matches != nil) {
		_action = matches[1];
		_letter1 = matches[2];
		_letter2 = matches[3];
		return self;
	}
	
	matches = [defn matchPattern:@"^(rotate based) .+ letter ([a-z])"];
	if (matches != nil) {
		_action = matches[1];
		_letter1 = matches[2];
		_direction = @"right";
		return self;
	}
	
	matches = [defn matchPattern:@"^(rotate) ([a-z]+) (\\d+) step"];
	if (matches != nil) {
		_action = matches[1];
		_direction = matches[2];
		_pos1 = [matches[3] integerValue];
		return self;
	}
	
	matches = [defn matchPattern:@"^(reverse) positions (\\d+) through (\\d+)"];
	if (matches != nil) {
		_action = matches[1];
		_pos1 = [matches[2] integerValue];
		_pos2 = [matches[3] integerValue];
		return self;
	}
	
	matches = [defn matchPattern:@"^(move) position (\\d+) to position (\\d+)"];
	if (matches != nil) {
		_action = matches[1];
		_pos1 = [matches[2] integerValue];
		_pos2 = [matches[3] integerValue];
		return self;
	}

	return self;
}

- (NSString *)operateOn:(NSString *)str {
	return [self operateOn:str inverted:NO];
}

- (NSString *)operateOn:(NSString *)str inverted:(BOOL)inverted {
	//NSLog(@"%@ on %@ %@", self.defn, str, inverted ? @"(INVERTED)" : @"");
	NSString *result;
	if ([self.action isEqualToString:@"swap position"]) {
		result = [self _swapPosition:str inverted:inverted];
	}
	else if ([self.action isEqualToString:@"swap letter"]) {
		result = [self _swapLetter:str inverted:inverted];
	}
	else if ([self.action isEqualToString:@"rotate based"]) {
		result = [self _rotateBased:str inverted:inverted];
	}
	else if ([self.action isEqualToString:@"rotate"]) {
		result = [self _rotate:str inverted:inverted];
	}
	else if ([self.action isEqualToString:@"reverse"]) {
		result = [self _reverse:str inverted:inverted];
	}
	else if ([self.action isEqualToString:@"move"]) {
		result = [self _move:str inverted:inverted];
	}
	//NSLog(@"Result: %@", result);
	return result;
}


- (NSString *)_swapPosition:(NSString *)str inverted:(BOOL)inverted {
	NSMutableArray<NSString *> *letters = [[str allCharacters] mutableCopy];
	
	NSInteger p1 = inverted ? self.pos1 : self.pos2;
	NSInteger p2 = inverted ? self.pos2 : self.pos1;
	
	NSString *temp = letters[p1];
	letters[p1] = letters[p2];
	letters[p2] = temp;
	return [letters componentsJoinedByString:@""];
}

- (NSString *)_swapLetter:(NSString *)str inverted:(BOOL)inverted {
	_pos1 = [str rangeOfString:self.letter1].location;
	_pos2 = [str rangeOfString:self.letter2].location;
	if (inverted) {
		NSInteger temp = _pos1;
		_pos1 = _pos2;
		_pos2 = temp;
	}
	return [self _swapPosition:str inverted:inverted];
}

- (NSString *)_rotateBased:(NSString *)str inverted:(BOOL)inverted {
	if (inverted == NO) {
		// rotate the string to the right one time, plus a number of times equal to that index, plus one additional time if the index was at least 4
		NSInteger index = [str rangeOfString:self.letter1].location;
		NSInteger r = 1 + index;
		if (index >= 4) {
			r++;
		}
		_pos1 = r;
	}
	else {
		// worked out the reverse rotations for all options
		NSInteger index = [str rangeOfString:self.letter1].location;
		NSInteger r = 0;
		if (index == 1)			{ r = 1; }
		else if (index == 3)	{ r = 2; }
		else if (index == 5)	{ r = 3; }
		else if (index == 7)	{ r = 4; }
		else if (index == 2)	{ r = 6; }
		else if (index == 4)	{ r = 7; }
		else if (index == 0)	{ r = 1; }
		_pos1 = r;
	}
	return [self _rotate:str inverted:inverted];
}

- (NSString *)_rotate:(NSString *)str inverted:(BOOL)inverted {
	NSString *result;
	NSInteger r = self.pos1 % str.length;
	NSString *direction = self.direction;
	if (inverted) {
		direction = [self.direction isEqualToString:@"left"] ? @"right" : @"left";
	}
	if ([direction isEqualToString:@"left"]) {
		NSString *ltrim = [str substringToIndex:r];
		NSString *remainder = [str substringFromIndex:r];
		result = [@[remainder, ltrim] componentsJoinedByString:@""];
	}
	else {
		NSInteger rIndex = str.length-r;
		NSString *rtrim = [str substringFromIndex:rIndex];
		NSString *remainder = [str substringToIndex:rIndex];
		result = [@[rtrim, remainder] componentsJoinedByString:@""];
	}
	return result;
}

- (NSString *)_reverse:(NSString *)str inverted:(BOOL)inverted {
	// No change for inversion
	NSString *ltrim = [str substringToIndex:self.pos1];
	NSInteger rIndex = self.pos2 + 1;
	NSString *rtrim = [str substringFromIndex:rIndex];
	NSString *reversed = [[str substringWithRange:NSMakeRange(self.pos1, self.pos2-self.pos1+1)] reverse];
	return [@[ltrim, reversed, rtrim] componentsJoinedByString:@""];
}

- (NSString *)_move:(NSString *)str inverted:(BOOL)inverted {
	NSMutableArray<NSString *> *letters = [[str allCharacters] mutableCopy];

	NSInteger p1 = inverted ? self.pos2 : self.pos1;
	NSInteger p2 = inverted ? self.pos1 : self.pos2;

	NSString *temp = letters[p1];
	[letters removeObjectAtIndex:p1];
	[letters insertObject:temp atIndex:p2];
	return [letters componentsJoinedByString:@""];
}

@end
