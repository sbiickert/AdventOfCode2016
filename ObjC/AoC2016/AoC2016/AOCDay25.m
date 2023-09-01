//
//  AOCDay25.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@interface AssemBunnyCode25: NSObject

- (AssemBunnyCode25 *)init:(NSString *)defn;

@property (readonly) NSString *defn;
@property (readonly) NSString *instruction;
@property (readonly) NSString *x;
@property (readonly) NSString *y;
@property (readonly) NSNumber *xNumber;
@property (readonly) NSNumber *yNumber;

- (void)toggle;
- (BOOL)isValid;

@end

@interface AssemBunnyComputer25 : NSObject

@property NSMutableDictionary<NSString *, NSNumber *> *registers;
@property (readonly) NSArray<AssemBunnyCode25 *> *program;
@property NSUInteger ptr;
@property NSNumber *output;

- (AssemBunnyComputer25 *)init:(NSArray *)code;
- (void)run;
- (NSNumber *)runToOutput:(BOOL)stopAtOutput initPointer:(BOOL)resetPtr;
- (void)exec:(AssemBunnyCode25 *)code;

@end

@implementation AOCDay25

- (AOCDay25 *)init {
	self = [super initWithDay:25 name:@"Clock Signal"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSMutableArray<AssemBunnyCode25 *> *program = [NSMutableArray array];
	for (NSString *line in input) {
		[program addObject:[[AssemBunnyCode25 alloc] init:line]];
	}

	result.part1 = [self solvePartOne: program];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<AssemBunnyCode25 *> *)input {
	//BOOL foundClock = NO;
	
	NSInteger seed = 0;
	while (YES) {
		AssemBunnyComputer25 *c = [[AssemBunnyComputer25 alloc] init:input];
		c.registers[@"a"] = [NSNumber numberWithInteger:seed];
		
		NSMutableArray<NSNumber *> *output = [NSMutableArray array];
		
		NSInteger MAX_ITERATION = 100;
		NSInteger iteration = 0;
		[c runToOutput:YES initPointer:YES];
		while (iteration < MAX_ITERATION) {
			if ([c.output integerValue] != iteration % 2) {
				break;
			}
			
			[output addObject:c.output];
			c.output = nil;
			
			iteration++;
			[c runToOutput:YES initPointer:NO];
		}
		
		if (iteration == MAX_ITERATION) {
			// Did this MAX_ITERATION times and it was always 0,1,0,1...
			break;
		}
		seed++;
	}
	
	return [NSString stringWithFormat: @"The seed resulting in a clock is %ld", seed];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return [NSString stringWithFormat: @"Merry Christmas!"];
}

@end

@implementation AssemBunnyCode25

- (AssemBunnyCode25 *)init:(NSString *)defn {
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

@implementation AssemBunnyComputer25

- (AssemBunnyComputer25 *)init:(NSArray *)code {
	self = [super init];
	
	_registers = [@{@"a": @0, @"b": @0, @"c": @0, @"d": @0} mutableCopy];
	_program = code;
	_ptr = 0;
	_output = nil;

	return self;
}

- (void)run {
	_ptr = 0;
	[self runToOutput:NO initPointer:YES];
}

- (NSNumber *)runToOutput:(BOOL)stopAtOutput initPointer:(BOOL)resetPtr {
	//[self printRegisters];
	if (resetPtr) {
		self.ptr = 0;
	}
	while (_ptr < _program.count) {
		//[[NSString stringWithFormat:@"%ld -> %@", _ptr, _program[_ptr].defn] println];
		[self exec:_program[_ptr]];
		//[self printRegisters];
		if (stopAtOutput && self.output != nil) {
			break;
		}
	}
	return self.output;
}


- (void)printRegisters {
	[[NSString stringWithFormat:@"\ta: %@\tb: %@\tc: %@\td: %@", _registers[@"a"], _registers[@"b"], _registers[@"c"], _registers[@"d"]] println];
}

- (void)exec:(AssemBunnyCode25 *)code {
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
	else if ([code.instruction isEqualToString:@"out"]) {
		NSNumber *n = code.xNumber;
		if (n == nil) {
			n = self.registers[code.x];
		}
		self.output = n;
		ptr++;
	}
	self.ptr = ptr;
}

@end
