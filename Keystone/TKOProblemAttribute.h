//
//  TKOProblemAttribute.h
//  Keystone
//
//  Created by Todd Olsen on 6/27/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKOProblemAttribute : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSDictionary * attributes;
@property (assign) NSInteger index;

+ (NSArray *)headers;
+ (NSArray *)paragraphStyles;
+ (NSArray *)characterStyles;
+ (NSArray *)listStyles;

+ (TKOProblemAttribute *)problemAttributeForName:(NSString *)name;
+ (NSAttributedString *)componentForString:(NSString *)string
                             attributeName:(NSString *)name;
+ (NSAttributedString *)listForArray:(NSArray *)array
                       attributeName:(NSString *)name;
+ (NSIndexSet *)indexSetForArrayOfStyleNames:(NSArray *)names;

@end


