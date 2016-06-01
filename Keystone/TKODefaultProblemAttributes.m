//
//  TKODefaultProblemAttributes.m
//  Keystone
//
//  Created by Todd Olsen on 6/26/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKODefaultProblemAttributes.h"

@implementation TKODefaultProblemAttributes
{
    NSMutableArray * _styles;
}

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        [_sharedInstance setUpDefaultAttributes];
    });
    
    return _sharedInstance;
}

- (void)setUpDefaultAttributes
{
    _styles = [NSMutableArray array];
    [_styles addObject:@{
        @"name": @"Component Styles",
        @"isHeader": @(YES)
     }];
    [_styles addObjectsFromArray:[self componentStyles]];
    
    [_styles addObject:@{
        @"name": @"Character Styles",
        @"isHeader": @(YES)
     }];
    [_styles addObjectsFromArray:[self characterStyles]];
}

- (NSArray *)styles
{
    return _styles;
}

- (NSArray *)componentStyles
{
    NSMutableArray * _components = [[NSMutableArray alloc] init];
    
    NSDictionary * attributes;
    NSMutableParagraphStyle * paragraphStyle;
    NSFont * font;
    NSString * name;
    
    name = @"Free";
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setParagraphSpacing:12.0];
//    font = [NSFont fontWithName:@"Adobe Garamond Pro"
//                           size:12.0];
    attributes = @{NSParagraphStyleAttributeName: paragraphStyle,
                   NSFontAttributeName: font,
                   NSToolTipAttributeName: name,
                   @"name": name
                   };
    
    [_components addObject:attributes];
    
    name = @"Question";
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setParagraphSpacing:12.0];
//    font = [NSFont fontWithName:@"Adobe Garamond Pro"
//                           size:12.0];
    attributes = @{NSParagraphStyleAttributeName: paragraphStyle,
                   NSFontAttributeName: font,
                   NSToolTipAttributeName: name,
                   NSForegroundColorAttributeName: [NSColor redColor],
                   @"name": name
                   };
    [_components addObject:attributes];
    
    return _components;
}

- (NSArray *)characterStyles
{
    NSMutableArray * _characterStyles = [[NSMutableArray alloc] init];
    [_characterStyles addObject:@{@"name": @"Exponent"}];
    return _characterStyles;
}

- (NSDictionary *)attributesForName:(NSString *)name
{
    __block NSDictionary * attributes;
    [_styles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"name"] isEqualToString:name]) {
            attributes = obj;
            *stop = YES;
        }
    }];
    return attributes;
}

- (NSInteger)indexForAttributeName:(NSString *)name
{
    __block NSInteger index;
    [_styles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"name"] isEqualToString:name]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}
@end
