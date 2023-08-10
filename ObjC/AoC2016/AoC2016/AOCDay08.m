//
//  AOCDay08.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCGrid2D.h"
#import "AOCStrings.h"

@interface ScreenOp : NSObject

- (ScreenOp *)init:(NSString *)str;

@property (readonly) NSString *op;
@property (readonly) NSString *target;
@property (readonly) NSInteger a;
@property (readonly) NSInteger b;

@end

@interface Screen : NSObject

- (Screen *)initWidth:(NSInteger)width height:(NSInteger)height;

@property (readonly) AOCGrid2D *grid;

- (void)perform:(ScreenOp *)operation;
- (void)turnOn:(NSInteger)width by:(NSInteger)height;
- (void)rotateColumn:(NSInteger)column by:(NSInteger)count;
- (void)rotateRow:(NSInteger)row by:(NSInteger)count;

@end

@implementation AOCDay08

- (AOCDay08 *)init {
	self = [super initWithDay:8 name:@"Two-Factor Authentication"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePart: input];
	result.part2 = @"EFEYKFRFIJ"; // Printed out in solvePart:
	
	return result;
}

- (NSString *)solvePart:(NSArray<NSString *> *)input {
	NSMutableArray<ScreenOp *> *ops = [NSMutableArray array];
	for (NSString *line in input) {
		[ops addObject:[[ScreenOp alloc] init:line]];
	}
	
	NSInteger w = 50;
	NSInteger h = 6;
	if (input.count < 10) {
		w = 7;
		h = 3;
	}
	
	Screen *screen = [[Screen alloc] initWidth:w height:h];
	for (ScreenOp *op in ops) {
		[screen perform:op];
	}
	
	NSArray<AOCCoord2D *> *coords = [screen.grid coordsWithValue:@"#"];
	[screen.grid print];
	
	return [NSString stringWithFormat: @"The number of lit pixels is %ld", coords.count];
}

@end

@implementation ScreenOp

- (ScreenOp *)init:(NSString *)str {
	self = [super init];
	NSString *rectPattern = @"^([a-z]+) (\\d+)x(\\d+)";
	NSString *rotPattern = @"^([a-z]+) ([a-z]+) [xy]=(\\d+) by (\\d+)";
	
	NSArray<NSString *> *matches = [str matchPattern:rectPattern];
	if (matches != nil) {
		_op = matches[1];
		_target = nil;
		_a = [matches[2] integerValue];
		_b = [matches[3] integerValue];
	}
	else {
		matches = [str matchPattern:rotPattern];
		_op = matches[1];
		_target = matches[2];
		_a = [matches[3] integerValue];
		_b = [matches[4] integerValue];
	}
	return self;
}

@end

@implementation Screen

- (Screen *)initWidth:(NSInteger)width height:(NSInteger)height {
	self = [super init];
	
	_grid = [AOCGrid2D grid];
	for (NSInteger i = 0; i < width; i++) {
		for (NSInteger j = 0; j < height; j++) {
			[self.grid setObject:@" " atCoord:[AOCCoord2D x:i y:j]];
		}
	}
	return self;
}

- (void)perform:(ScreenOp *)operation {
	if ([operation.op isEqualToString:@"rect"]) {
		[self turnOn:operation.a by:operation.b];
	}
	else if ([operation.target isEqualToString:@"row"]) {
		[self rotateRow:operation.a by:operation.b];
	}
	else {
		[self rotateColumn:operation.a by:operation.b];
	}
}

- (void)turnOn:(NSInteger)width by:(NSInteger)height {
	for (NSInteger i = 0; i < width; i++) {
		for (NSInteger j = 0; j < height; j++) {
			[self.grid setObject:@"#" atCoord:[AOCCoord2D x:i y:j]];
		}
	}
}

- (void)rotateColumn:(NSInteger)column by:(NSInteger)count {
	NSArray<AOCCoord2D *> *coords = [self.grid.extent coordsInColumn:column];
	[self rotatePixelsAt:coords by:count];
}

- (void)rotateRow:(NSInteger)row by:(NSInteger)count {
	NSArray<AOCCoord2D *> *coords = [self.grid.extent coordsInRow:row];
	[self rotatePixelsAt:coords by:count];
}

- (void)rotatePixelsAt:(NSArray<AOCCoord2D *> *)coords by:(NSInteger)count {
	NSMutableArray<NSString *> *queue = [NSMutableArray array];
	for (NSInteger i = 0; i < coords.count; i++) {
		[queue addObject:[self.grid stringAtCoord:coords[i]]];
	}
	
	for (NSInteger r = 0; r < count; r++) {
		NSString *temp = queue.lastObject;
		[queue removeLastObject];
		[queue insertObject:temp atIndex:0];
	}
	
	for (NSInteger i = 0; i < coords.count; i++) {
		[self.grid setObject:queue[i] atCoord:coords[i]];
	}
}


@end
