//
//  AOCPosition.h
//  AoC2016
//
//  Created by Simon Biickert on 2023-08-07.
//

#import "AOCCoord.h"

extern NSString * const CW;
extern NSString * const CCW;

@interface AOCPosition: NSObject <NSCopying>

+ (AOCPosition *)origin;

@property AOCCoord2D *location;

/*
 One of AOCCoord constants:
 NORTH, SOUTH, EAST, WEST
 UP, DOWN, LEFT, RIGHT
 */
@property (readonly) NSString *direction;

/*
 One of AOCCoord constants: LEFT, RIGHT
 or AOCPosition constants: CW, CCW
 */
- (void)turn:(NSString *)turnDirection;
- (void)moveForward:(NSInteger)distance;

@end
