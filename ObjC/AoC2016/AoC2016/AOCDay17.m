//
//  AOCDay17.m
//  Advent of Code 2016
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCGrid2D.h"
#import "AOCStrings.h"

@interface MazeState : NSObject

@property (class, readonly) AOCExtent2D *extent;
@property (class, readonly) AOCCoord2D *vaultPosition;
@property (class, readonly) NSCharacterSet *openSet;
@property (class, readonly) NSDictionary<NSString *, NSString *> *dirLookup;

@property (readonly) NSString *password;
@property (readonly) AOCCoord2D *position;

+ (AOCCoord2D *)vaultPosition;
+ (AOCExtent2D *)extent;
+ (NSCharacterSet *)openSet;
+ (NSDictionary<NSString *, NSString *> *)dirLookup;

- (MazeState *)init:(NSString *)pass atPosition:(AOCCoord2D *)pos;

- (NSArray<NSString *> *)openDirections;
- (MazeState *)go:(NSString *)direction;
- (BOOL)isFinished;

@end

@implementation AOCDay17

- (AOCDay17 *)init {
	self = [super initWithDay:17 name:@"Two Steps Forward"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePartOne: input[0]];
	result.part2 = [self solvePartTwo: input[0]];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)input {
	NSArray<MazeState *> *work = @[[[MazeState alloc] init:input atPosition:[AOCCoord2D origin]]];
	
	MazeState *shortest = nil;
	while (shortest == nil && work.count > 0) {
		NSMutableArray<MazeState *> *nextWork = [NSMutableArray array];
		
		for (MazeState *ms in work) {
			if (ms.isFinished) {
				shortest = ms;
				break;
			}
			for (NSString *dir in ms.openDirections) {
				MazeState *newMS = [ms go:dir];
				if (newMS != nil) {
					[nextWork addObject:newMS];
				}
			}
		}
		work = nextWork;
	}
	
	if (shortest == nil) {
		return [NSString stringWithFormat: @"Invalid password %@", input];
	}
	
	NSString *path = [shortest.password substringFromIndex:input.length];

	return [NSString stringWithFormat: @"The shortest path is %@ with length %ld.", path, path.length];
}

- (NSString *)solvePartTwo:(NSString *)input {
	NSArray<MazeState *> *work = @[[[MazeState alloc] init:input atPosition:[AOCCoord2D origin]]];
	
	MazeState *longest = nil;
	while (work.count > 0) {
		NSMutableArray<MazeState *> *nextWork = [NSMutableArray array];
		
		for (MazeState *ms in work) {
			if (ms.isFinished) {
				longest = ms;
				continue;
			}
			for (NSString *dir in ms.openDirections) {
				MazeState *newMS = [ms go:dir];
				if (newMS != nil) {
					[nextWork addObject:newMS];
				}
			}
		}
		work = nextWork;
	}
	
	if (longest == nil) {
		return [NSString stringWithFormat: @"Invalid password %@", input];
	}
	
	NSString *path = [longest.password substringFromIndex:input.length];

	return [NSString stringWithFormat: @"The longest path has length %ld.", path.length];
}

@end

@implementation MazeState

static AOCExtent2D *_extent = nil;
static AOCCoord2D *_vaultPosition = nil;
static NSCharacterSet *_openSet = nil;
static NSDictionary<NSString *, NSString *> *_dirLookup = nil;

+ (AOCCoord2D *)vaultPosition {
	if (_vaultPosition == nil) {
		_vaultPosition = [AOCCoord2D x:3 y:3];
	}
	return _vaultPosition;
}

+ (AOCExtent2D *)extent {
	if (_extent == nil) {
		_extent = [[AOCExtent2D alloc] initMin:[AOCCoord2D origin] max:MazeState.vaultPosition];
	}
	return _extent;
}

+ (NSCharacterSet *)openSet {
	if (_openSet == nil) {
		_openSet = [NSCharacterSet characterSetWithCharactersInString:@"bcdef"];
	}
	return _openSet;
}

+ (NSDictionary<NSString *, NSString *> *)dirLookup {
	if (_dirLookup == nil) {
		_dirLookup = @{UP: @"U", DOWN: @"D", LEFT: @"L", RIGHT: @"R"};
	}
	return _dirLookup;
}


- (MazeState *)init:(NSString *)pass atPosition:(AOCCoord2D *)pos {
	self = [super init];
	
	_password = pass;
	_position = pos;
	
	return self;
}

- (NSArray<NSString *> *)openDirections {
	NSString *md5 = [[self.password md5Hex] substringToIndex:4];
	NSArray<NSString *> *chars = [md5 allCharacters];
	NSMutableArray<NSString *> *dirs = [NSMutableArray array];
	if ([chars[0] rangeOfCharacterFromSet:MazeState.openSet].location != NSNotFound) {
		[dirs addObject:UP];
	}
	if ([chars[1] rangeOfCharacterFromSet:MazeState.openSet].location != NSNotFound) {
		[dirs addObject:DOWN];
	}
	if ([chars[2] rangeOfCharacterFromSet:MazeState.openSet].location != NSNotFound) {
		[dirs addObject:LEFT];
	}
	if ([chars[3] rangeOfCharacterFromSet:MazeState.openSet].location != NSNotFound) {
		[dirs addObject:RIGHT];
	}
	return dirs;
}

- (MazeState *)go:(NSString *)direction {
	// Will return nil if a wall
	AOCCoord2D *newPosition = [self.position offset:direction];
	if ([MazeState.extent contains:newPosition] == NO) {
		return nil;
	}
	NSString *newPassword = [self.password stringByAppendingString:[MazeState.dirLookup valueForKey:direction]];
	return [[MazeState alloc] init:newPassword atPosition:newPosition];
}

- (BOOL)isFinished {
	return [self.position isEqualToCoord2D:MazeState.vaultPosition];
}

@end
