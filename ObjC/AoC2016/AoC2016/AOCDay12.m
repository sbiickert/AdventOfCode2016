//
//  AOCDay12.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@interface AssemBunnyCode: NSObject

- (AssemBunnyCode *)init:(NSString *)defn;

@property (readonly) NSString *instruction;
@property (readonly) NSString *x;
@property (readonly) NSString *y;
@property (readonly) NSNumber *xNumber;
@property (readonly) NSNumber *yNumber;

@end

@interface AssemBunnyComputer : NSObject

@property NSMutableDictionary<NSString *, NSNumber *> *registers;
@property (readonly) NSArray<AssemBunnyCode *> *program;
@property NSUInteger ptr;

- (AssemBunnyComputer *)init:(NSArray *)code;
- (void)run;
- (void)exec:(AssemBunnyCode *)code;

@end

@implementation AOCDay12

- (AOCDay12 *)init {
	self = [super initWithDay:12 name:@"Leonardo's Monorail"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSMutableArray<AssemBunnyCode *> *program = [NSMutableArray array];
	for (NSString *line in input) {
		[program addObject:[[AssemBunnyCode alloc] init:line]];
	}
	result.part1 = [self solvePartOne: program];
	result.part2 = [self solvePartTwo: program];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<AssemBunnyCode *> *)input {
	AssemBunnyComputer *c = [[AssemBunnyComputer alloc] init:input];
	[c run];
	
	return [NSString stringWithFormat: @"Value in register a is %@", [c.registers valueForKey:@"a"]];
}

- (NSString *)solvePartTwo:(NSArray<AssemBunnyCode *> *)input {
	AssemBunnyComputer *c = [[AssemBunnyComputer alloc] init:input];
	c.registers[@"c"] = @1;
	[c run];
	
	return [NSString stringWithFormat: @"Value in register a is %@", [c.registers valueForKey:@"a"]];
}

@end

@implementation AssemBunnyCode

- (AssemBunnyCode *)init:(NSString *)defn {
	self = [super init];
	
	NSArray<NSString *> *parts = [defn componentsSeparatedByString:@" "];
	_instruction = parts[0];
	_x = parts[1];
	_y = parts.count > 2 ? parts[2] : nil;
	
	_xNumber = [_x isAllDigits] ? [NSNumber numberWithInteger:[_x integerValue]] : nil;
	_yNumber = [_y isAllDigits] ? [NSNumber numberWithInteger:[_y integerValue]] : nil;
	return self;
}

@end

@implementation AssemBunnyComputer

- (AssemBunnyComputer *)init:(NSArray *)code {
	self = [super init];
	
	_registers = [@{@"a": @0, @"b": @0, @"c": @0, @"d": @0} mutableCopy];
	_program = code;
	_ptr = 0;

	return self;
}

- (void)run {
	_ptr = 0;
	while (_ptr < _program.count) {
		[self exec:_program[_ptr]];
	}
}

- (void)exec:(AssemBunnyCode *)code {
	NSUInteger ptr = self.ptr;
	if ([code.instruction isEqualToString:@"cpy"]) {
		NSNumber *n = code.xNumber;
		if (n == nil) {
			n = self.registers[code.x];
		}
		self.registers[code.y] = [n copy];
		ptr++;
	}
	else if ([code.instruction isEqualToString:@"inc"]) {
		NSNumber *n = self.registers[code.x];
		n = [NSNumber numberWithInteger:[n integerValue] + 1];
		self.registers[code.x] = n;
		ptr++;
	}
	else if ([code.instruction isEqualToString:@"dec"]) {
		NSNumber *n = self.registers[code.x];
		n = [NSNumber numberWithInteger:[n integerValue] - 1];
		self.registers[code.x] = n;
		ptr++;
	}
	else if ([code.instruction isEqualToString:@"jnz"]) {
		NSNumber *n = code.xNumber;
		if (n == nil) {
			n = self.registers[code.x];
		}
		NSInteger i = [n integerValue];
		if (i != 0) {
			ptr += [code.yNumber integerValue];
		}
		else {
			ptr++;
		}
	}
	self.ptr = ptr;
}

@end
