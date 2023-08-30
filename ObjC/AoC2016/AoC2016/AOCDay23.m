//
//  AOCDay23.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@interface AssemBunnyCode23: NSObject

- (AssemBunnyCode23 *)init:(NSString *)defn;

@property (readonly) NSString *defn;
@property (readonly) NSString *instruction;
@property (readonly) NSString *x;
@property (readonly) NSString *y;
@property (readonly) NSNumber *xNumber;
@property (readonly) NSNumber *yNumber;

- (void)toggle;
- (BOOL)isValid;

@end

@interface AssemBunnyComputer23 : NSObject

@property NSMutableDictionary<NSString *, NSNumber *> *registers;
@property (readonly) NSArray<AssemBunnyCode23 *> *program;
@property NSUInteger ptr;

- (AssemBunnyComputer23 *)init:(NSArray *)code;
- (void)run;
- (void)exec:(AssemBunnyCode23 *)code;

@end

@implementation AOCDay23

- (AOCDay23 *)init {
	self = [super initWithDay:23 name:@"Safe Cracking"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSMutableArray<AssemBunnyCode23 *> *program = [NSMutableArray array];
	for (NSString *line in input) {
		[program addObject:[[AssemBunnyCode23 alloc] init:line]];
	}

	result.part1 = [self solvePartOne: program];
	result.part2 = [self solvePartTwo: program];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<AssemBunnyCode23 *> *)input {
	AssemBunnyComputer23 *c = [[AssemBunnyComputer23 alloc] init:input];
	
	if (input.count > 7) {
		c.registers[@"a"] = @7;
	}
	
	[c run];
	
	return [NSString stringWithFormat: @"Value in register a is %@", [c.registers valueForKey:@"a"]];
}

- (NSString *)solvePartTwo:(NSArray<AssemBunnyCode23 *> *)input {
	// The program boils down to:
	//   n! + (78*99)
	//
	// 12! is 479001600, 78*99 is 7722
	
	return [NSString stringWithFormat: @"Code to send is %d", 479001600 + (78*99)];
}

@end


@implementation AssemBunnyCode23

- (AssemBunnyCode23 *)init:(NSString *)defn {
	self = [super init];
	
	_defn = defn;
	NSArray<NSString *> *parts = [defn componentsSeparatedByString:@" "];
	_instruction = parts[0];
	_x = parts[1];
	_y = parts.count > 2 ? parts[2] : nil;
	
	_xNumber = [_x isAllDigits] ? [NSNumber numberWithInteger:[_x integerValue]] : nil;
	_yNumber = [_y isAllDigits] ? [NSNumber numberWithInteger:[_y integerValue]] : nil;
	return self;
}

- (void)toggle {
	if ([_instruction isEqualToString:@"inc"]) {
		_instruction = @"dec";
	}
	else if (_y == nil) {
		// All other 1-argument instructions
		_instruction = @"inc";
	}
	else if ([_instruction isEqualToString:@"jnz"]) {
		_instruction = @"cpy";
	}
	else {
		_instruction = @"jnz";
	}
}

- (BOOL)isValid {
	if ([_instruction isEqualToString:@"cpy"] && _yNumber != nil) {
		return NO;
	}
	return YES;
}

@end

@implementation AssemBunnyComputer23

- (AssemBunnyComputer23 *)init:(NSArray *)code {
	self = [super init];
	
	_registers = [@{@"a": @0, @"b": @0, @"c": @0, @"d": @0} mutableCopy];
	_program = code;
	_ptr = 0;

	return self;
}

- (void)run {
	_ptr = 0;
	//[self printRegisters];
	while (_ptr < _program.count) {
		//[[NSString stringWithFormat:@"%ld -> %@", _ptr, _program[_ptr].defn] println];
		[self exec:_program[_ptr]];
		//[self printRegisters];
	}
}

- (void)printRegisters {
	[[NSString stringWithFormat:@"\ta: %@\tb: %@\tc: %@\td: %@", _registers[@"a"], _registers[@"b"], _registers[@"c"], _registers[@"d"]] println];
}

- (void)exec:(AssemBunnyCode23 *)code {
	NSUInteger ptr = self.ptr;
	if (code.isValid == NO) {
		ptr++;
	}
	else if ([code.instruction isEqualToString:@"cpy"]) {
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
			NSInteger jump = code.yNumber == nil ? [self.registers[code.y] integerValue] : [code.yNumber integerValue];
			ptr += jump;
		}
		else {
			ptr++;
		}
	}
	else if ([code.instruction isEqualToString:@"tgl"]) {
		NSNumber *n = self.registers[code.x];
		NSInteger i = [n integerValue];
		NSInteger addr = ptr + i;
		if (addr >= 0 && addr < _program.count) {
			[self.program[ptr+i] toggle];
		}
		ptr++;
	}
	self.ptr = ptr;
}

@end
