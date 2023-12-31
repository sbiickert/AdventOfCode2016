//
//  AOCCoord2D.h
//  AoC2017
//
//  Created by Simon Biickert .
//

extern NSString * const NORTH;
extern NSString * const SOUTH;
extern NSString * const WEST;
extern NSString * const EAST;
extern NSString * const NW;
extern NSString * const NE;
extern NSString * const SW;
extern NSString * const SE;
extern NSString * const HN;  // hex grid
extern NSString * const HS;  // hex grid
extern NSString * const HNW; // hex grid
extern NSString * const HNE; // hex grid
extern NSString * const HSW; // hex grid
extern NSString * const HSE; // hex grid
extern NSString * const UP;
extern NSString * const DOWN;
extern NSString * const LEFT;	// Also used for AOCPosition turn:
extern NSString * const RIGHT;	// Also used for AOCPosition turn:

@interface AOCCoord2D : NSObject <NSCopying>

+ (AOCCoord2D *)origin;
+ (AOCCoord2D *)x:(NSInteger)x y:(NSInteger)y;
+ (AOCCoord2D *)copyOf:(AOCCoord2D *)other;
+ (AOCCoord2D *)offset:(NSString *)direction;

- (AOCCoord2D *)initX:(NSInteger)x y:(NSInteger)y;

@property (readonly) NSInteger x;
@property (readonly) NSInteger y;

- (NSInteger)row;
- (NSInteger)col;

- (BOOL)isEqualToCoord2D:(AOCCoord2D *)other;

- (AOCCoord2D *)add:(AOCCoord2D *)other;
- (AOCCoord2D *)delta:(AOCCoord2D *)other;
- (AOCCoord2D *)offset:(NSString *)direction;

- (double)distanceTo:(AOCCoord2D *)other;
- (NSInteger)manhattanDistanceTo:(AOCCoord2D *)other;

@end

@interface AOCCoord3D : NSObject <NSCopying>

+ (AOCCoord3D *)origin;
+ (AOCCoord3D *)x:(NSInteger)x y:(NSInteger)y z:(NSInteger)z;
+ (AOCCoord3D *)copyOf:(AOCCoord3D *)other;
//+ (AOCCoord2D *)offset:(NSString *)direction;

- (AOCCoord3D *)initX:(NSInteger)x y:(NSInteger)y z:(NSInteger)z;

@property (readonly) NSInteger x;
@property (readonly) NSInteger y;
@property (readonly) NSInteger z;

- (BOOL)isEqualToCoord3D:(AOCCoord3D *)other;

- (AOCCoord3D *)add:(AOCCoord3D *)other;
- (AOCCoord3D *)delta:(AOCCoord3D *)other;
//- (AOCCoord3D *)offset:(NSString *)direction;

- (double)distanceTo:(AOCCoord3D *)other;
- (NSInteger)manhattanDistanceTo:(AOCCoord3D *)other;

@end
