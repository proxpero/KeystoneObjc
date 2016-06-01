//
//  TKOTag.m
//  Keystone
//
//  Created by Todd Olsen on 6/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOTag.h"
#import "TKOList.h"
#import "TKOProblem.h"
#import "TKOTag.h"
#import "TKOTemplate.h"

static NSMutableDictionary * _tags = nil;

@implementation TKOTag

@dynamic name;
@dynamic desc;
@dynamic index;
@dynamic parent;
@dynamic children;
@dynamic problems;
@dynamic lists;
@dynamic templates;

@synthesize menu;

# pragma mark - Set Up

+ (void)initialize
{
    if (!_tags)
        _tags = [[NSMutableDictionary alloc] init];
}

+ (id)createWithName:(NSString *)name
{
    TKOTag * tag = [super create];
    [tag setName:name];
    [_tags setObject:tag
              forKey:name];
    return tag;
}

+ (id)createWithName:(NSString *)name index:(NSInteger)index
{
    TKOTag * tag = [self createWithName:name];
    [tag setIndex:@(index)];
    return tag;
}

+ (id)createWithName:(NSString *)name index:(NSInteger)index parent:(TKOTag *)parent
{
    TKOTag * tag = [self createWithName:name index:index];
    [tag setParent:parent];
    return tag;
}

+ (TKOTag *)tagWithName:(NSString *)name
{
    TKOTag * tag = [_tags objectForKey:name];
    
    if (tag)
        return tag;
    
    tag = [self fetchObjectWithName:name];
    if (tag)
    {
        [_tags setObject:tag
                  forKey:name];
        return tag;
    }
    return nil;
}

+ (NSSet *)tagsWithNames:(NSArray *)names
{
    NSMutableSet * tags = [NSMutableSet set];
    [names enumerateObjectsUsingBlock:^(id name, NSUInteger idx, BOOL *stop) {
        TKOTag * tag = [TKOTag tagWithName:name];
        if (tag)
            [tags addObject:tag];
    }];
    return tags;
}

# pragma mark - Source List Protocol

+ (TKOTag *)root
{
    NSString * name;
    
    // Root
    name = @"Tags";
    TKOTag * _root = [self tagWithName:name];
    if (_root)
        return _root;
    
    _root = [TKOTag createWithName:name index:0];
    
    [TKOTag createWithName:@"Problems" index:0 parent:_root];
    TKOTag * lists = [TKOTag createWithName:@"Lists" index:1 parent:_root];
    [TKOTag createWithName:@"Test" index:1 parent:lists];
    [TKOTag createWithName:@"Templates" index:2 parent:_root];
    
    return _root;
}

- (NSArray *)items
{
    return [self.children sortedByIndex];
}

@end
