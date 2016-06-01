//
//  NSManagedObject+Keystone.h
//  Keystone
//
//  Created by Todd Olsen on 6/3/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

typedef NSUInteger TKOInteger;

@protocol TKOObjectOptions <NSObject>
@optional
+ (id)root;
- (NSNumber *)options;
- (void)setOptions:(NSNumber *)options;
- (id)parent;
- (void)setParent:(id)parent;
@end

@interface NSManagedObject (Keystone) <TKOObjectOptions>

+ (instancetype)createWithUniqueName:(NSString *)name;
+ (instancetype)createItemWithName:(NSString *)name
                            parent:(id)parent;

- (void)setOption:(TKOInteger)option
             flag:(BOOL)flag;
- (BOOL)getOption:(TKOInteger)option;

@end
