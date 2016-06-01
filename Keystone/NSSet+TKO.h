//
//  NSSet+TKO.h
//  Keystone
//
//  Created by Todd Olsen on 6/3/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (TKO)

- (NSArray *)sortedByIndex;
- (NSArray *)sortedByName;
- (NSArray *)sortedByTimestamp;
- (NSArray *)sortedByDifficulty;

@end
