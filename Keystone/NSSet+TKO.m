//
//  NSSet+TKO.m
//  Keystone
//
//  Created by Todd Olsen on 6/3/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSSet+TKO.h"

static NSArray * _sortByName;
static NSArray * _sortByIndex;
static NSArray * _sortByTimestamp;
static NSArray * _sortByDifficulty;

@implementation NSSet (TKO)

- (NSArray *)sortedByIndex
{
    if (!_sortByIndex)
        _sortByIndex = @[[NSSortDescriptor sortDescriptorWithKey:@"index"
                                                       ascending:YES]];
    return [self sortedArrayUsingDescriptors:_sortByIndex];
}

- (NSArray *)sortedByName
{
    if (!_sortByName)
        _sortByName = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                      ascending:YES]];
    return [self sortedArrayUsingDescriptors:_sortByName];
}

- (NSArray *)sortedByTimestamp
{
    if (!_sortByTimestamp)
        _sortByTimestamp = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp"
                                                           ascending:YES]];
    return [self sortedArrayUsingDescriptors:_sortByTimestamp];
}

- (NSArray *)sortedByDifficulty
{
    if (!_sortByDifficulty)
        _sortByDifficulty = @[[NSSortDescriptor sortDescriptorWithKey:@"difficulty"
                                                            ascending:YES]];
    return [self sortedArrayUsingDescriptors:_sortByDifficulty];
}

@end
