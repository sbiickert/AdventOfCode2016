//
//  AOCPosition.m
//  AoC2016
//
//  Created by Simon Biickert on 2023-08-07.
//

#import <Foundation/Foundation.h>
#import "AOCPosition.h"

NSString * const CW = @"clockwise";
NSString * const CCW = @"counterclockwise";

@implementation AOCPosition

+ (AOCPosition *)origin {
	return [[AOCPosition alloc] initLocation: [AOCCoord2D origin] direction: NORTH];
}

- (AOCPosition *)initLocation:(AOCCoord2D *)loc direction:(NSString *)dir {
	self = [super init];
	_location = loc;
	_direction = dir;
	return self;
}

- (void)turn:(NSString *)turnDirection {
	int turn = 0;
	if ([turnDirection isEqualToString:LEFT] || [turnDirection isEqualToString:CCW]) {
		turn = -1;
	}
	else if ([turnDirection isEqualToString:RIGHT] || [turnDirection isEqualToString:CW]) {
		turn = 1;
	}
	else {
		NSLog(@"Unrecognized turn direction passed to turn: %@. See constants in AOCCoord.h and AOCPosition.h", turnDirection);
	}
	NSArray<NSString *> *dirs = @[NORTH, EAST, SOUTH, WEST];
	NSInteger index = [dirs indexOfObject:self.direction];
	if (index == NSNotFound) {
		dirs = @[UP, RIGHT, DOWN, LEFT];
		index = [dirs indexOfObject:self.direction];
		if (index == NSNotFound) {
			index = 0;
		}
	}
	index = (index + 4 + turn) % 4;
	_direction = dirs[index];
}

- (void)moveForward:(NSInteger)distance {
	for (NSInteger i = 0; i < distance; i++) {
		_location = [_location offset:_direction];
	}
}

- (BOOL)isEqualToPosition:(AOCPosition *)other {
	if (other == nil) {
		return NO;
	}
	return [self.location isEqualToCoord2D: other.location] && [self.direction isEqualToString:other.direction];
}

- (BOOL)isEqual:(nullable id)object {
	if (object == nil) {
		return NO;
	}

	if (self == object) {
		return YES;
	}

	if (![object isKindOfClass:[AOCPosition class]]) {
		return NO;
	}

	return [self isEqualToPosition:(AOCPosition *)object];
}

- (NSUInteger)hash {
	return [self.location hash] ^ [self.direction hash];
}

// NSCopying (to let this be a key in NSDictionary)
- (id)copyWithZone:(NSZone *)zone
{
	AOCPosition *copy = [[AOCPosition allocWithZone:zone] initLocation:_location direction:_direction];
	return copy;
}


@end
