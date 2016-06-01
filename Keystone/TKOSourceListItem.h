//
//  TKOSourceListItem.h
//  Keystone
//
//  Created by Todd Olsen on 6/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKOSourceListItem <NSObject>

+ (id)root;
- (NSString *)name;
- (void)setName:(NSString *)name;
- (NSArray *)items;
- (id)parent;
@optional
- (NSNumber *)index;
- (NSSet *)problems;
- (NSAttributedString *)attributedString;
@end

