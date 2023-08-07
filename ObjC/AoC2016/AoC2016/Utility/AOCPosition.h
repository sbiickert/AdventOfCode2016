//
//  AOCPosition.h
//  AoC2016
//
//  Created by Simon Biickert on 2023-08-07.
//

#import "AOCCoord.h"

@interface AOCPosition: NSObject <NSCopying>

+ (AOCPosition *)origin;

@property AOCCoord2D *location;
@property (readonly) NSString *direction;

- (void)rotate:(NSString *)instruction;
- (void)moveForward:(NSInteger)distance;

@end
