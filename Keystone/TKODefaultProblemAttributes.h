//
//  TKODefaultProblemAttributes.h
//  Keystone
//
//  Created by Todd Olsen on 6/26/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKODefaultProblemAttributes : NSObject

+ (instancetype)sharedInstance;
- (NSDictionary *)attributesForName:(NSString *)name;
- (NSInteger)indexForAttributeName:(NSString *)name;
- (NSArray *)styles;

@end
