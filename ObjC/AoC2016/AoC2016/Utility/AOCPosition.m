//
//  AOCPosition.m
//  AoC2016
//
//  Created by Simon Biickert on 2023-08-07.
//

#import <Foundation/Foundation.h>
#import "AOCPosition.h"

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

- (void)rotate:(NSString *)dirLR {
	int turn = [[[dirLR substringToIndex: 1] uppercaseString] isEqualToString:@"L"] ? -1 : 1;
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
