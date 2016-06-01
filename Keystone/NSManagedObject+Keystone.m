//
//  NSManagedObject+Keystone.m
//  Keystone
//
//  Created by Todd Olsen on 6/3/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSManagedObject+Keystone.h"

@implementation NSManagedObject (Keystone)

+ (id)createWithUniqueName:(NSString *)name
{
    NSLog(@"self class: %@", NSStringFromClass([self class]));
    id item = [self create];
    NSString * temp = name;
    NSInteger uniquifier = 1;
    while ([self fetchObjectWithName:temp]) {
        id obj = [self fetchObjectWithName:temp];
        NSLog(@"name: %@", [obj name]);
        temp = [NSString stringWithFormat:@"%@ %lu", name, uniquifier];
        uniquifier++;
    }
    
    [item setValue:temp forKey:@"name"];
    
    return item;
}

+ (id)createItemWithName:(NSString *)name
                  parent:(id)parent
{
    NSLog(@"self class: %@", NSStringFromClass([self class]));
    id item = [self createWithUniqueName:name];
    NSLog(@"item class: %@, parent class: %@", NSStringFromClass([item class]), NSStringFromClass([parent class]));
    [item setParent:parent];
    return item;
}

- (void)setOption:(TKOInteger)option
             flag:(BOOL)flag {
    NSInteger opts = self.options.integerValue;
    if (flag)
        opts = opts | option;
    else
        opts = opts & ~option;
    [self setOptions:@(opts)];
}

- (BOOL)getOption:(TKOInteger)option
{
    NSInteger result = self.options.integerValue & option;
    if (result == 0)
        return NO;
    return YES;
}

@end
