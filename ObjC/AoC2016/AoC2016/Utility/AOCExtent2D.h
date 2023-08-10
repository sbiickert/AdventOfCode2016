//
//  AOCExtent2D.h
//  AoC2017
//
//  Created by Simon Biickert .
//
#import "AOCCoord.h"

@interface AOCExtent2D : NSObject

+ (AOCExtent2D *)xMin:(NSInteger)xmin yMin:(NSInteger)ymin xMax:(NSInteger)xmax yMax:(NSInteger)ymax;
+ (AOCExtent2D *)copyOf:(AOCExtent2D *)other;

- (AOCExtent2D *)initXMin:(NSInteger)xmin yMin:(NSInteger)ymin xMax:(NSInteger)xmax yMax:(NSInteger)ymax;
- (AOCExtent2D *)initMin:(AOCCoord2D *)min max:(AOCCoord2D *)max;
- (AOCExtent2D *)initFrom:(NSArray<AOCCoord2D *> *)array;

@property (readonly) AOCCoord2D *min;
@property (readonly) AOCCoord2D *max;

- (NSInteger)width;
- (NSInteger)height;
- (NSInteger)area;
- (AOCCoord2D *)center;

- (void)expandToFit:(AOCCoord2D *)coord;
- (NSArray<AOCCoord2D *> *)allCoords;
- (NSArray<AOCCoord2D *> *)coordsInColumn:(NSInteger)column;
- (NSArray<AOCCoord2D *> *)coordsInRow:(NSInteger)row;
- (BOOL)contains:(AOCCoord2D *)coord;
- (AOCExtent2D *)inset:(NSInteger)amount;


@end
