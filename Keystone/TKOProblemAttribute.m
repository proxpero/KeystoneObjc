//
//  TKOProblemAttribute.m
//  Keystone
//
//  Created by Todd Olsen on 6/27/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

static NSArray * _headers = nil;
static NSMutableDictionary * _styles = nil;
static NSFont * _defaultFont = nil;
static NSUInteger componentIndex;

#import "TKOProblemAttribute.h"

@implementation TKOProblemAttribute

+ (void)initialize
{
    if (!_styles) {
        _styles = [NSMutableDictionary dictionary];
        _defaultFont = [NSFont fontWithName:@"Times-Roman"
                                       size:0.0];
        componentIndex = 0;
        
        _headers = @[ @{ @"name": @"Component Styles",
                         @"index": @(componentIndex),
                         @"children": [self componentStyles]},
                      @{ @"name": @"Character Styles",
                         @"index": @(componentIndex + 1),
                         @"children": [self characterStyles]},
                      @{ @"name": @"List Styles",
                         @"index": @(componentIndex + 2),
                         @"children": [self listStyles]} ];
    }
}

+ (NSArray *)paragraphStyles
{
    NSMutableArray * array = [NSMutableArray array];
    
}

+ (NSArray *)componentStyles
{
    NSMutableArray * children = [NSMutableArray array];
    
    TKOProblemAttribute * problemAttr;
    NSString * name;
    NSMutableParagraphStyle * paragraphStyle;
    NSMutableDictionary * attributes;
    
    name = @"Image";
    problemAttr = [[TKOProblemAttribute alloc] init];
    attributes = [NSMutableDictionary dictionary];
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setParagraphSpacing:9.0];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    [attributes setObject:paragraphStyle
                   forKey:NSParagraphStyleAttributeName];
    [attributes setObject:@"TKOProblemComponentImage"
                   forKey:TKOProblemComponentNameKey];
    [attributes setObject:@(++componentIndex)
                   forKey:@"index"];
    
    [problemAttr setName:name];
    [problemAttr setAttributes:attributes];
//    [problemAttr setIndex:componentIndex++];
    [children addObject:problemAttr];
    [_styles setObject:problemAttr forKey:name];
        NSLog(@"%@ index: %@", name, attributes[@"index"]);
    name = @"Caption";
    problemAttr = [[TKOProblemAttribute alloc] init];
    attributes = [NSMutableDictionary dictionary];
//    [attributes setObject:[NSFont fontWithName:@"Times-Roman"
//                                          size:0.0]
//                   forKey:NSFontAttributeName];
    [attributes setObject:@"TKOProblemComponentCaption"
                   forKey:TKOProblemComponentNameKey];
    [attributes setObject:@(++componentIndex)
                   forKey:@"index"];
    NSLog(@"%@ index: %@", name, attributes[@"index"]);
    [problemAttr setName:name];
    [problemAttr setAttributes:attributes];
//    [problemAttr setIndex:componentIndex++];
    
    [children addObject:problemAttr];
    [_styles setObject:problemAttr forKey:name];
    
    name = @"Prelude";
    problemAttr = [[TKOProblemAttribute alloc] init];
    attributes = [NSMutableDictionary dictionary];
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setParagraphSpacing:9.0];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    [attributes setObject:paragraphStyle
                   forKey:NSParagraphStyleAttributeName];
//    [attributes setObject:_defaultFont
//                   forKey:NSFontAttributeName];
    [attributes setObject:@"TKOProblemComponentPrelude"
                   forKey:TKOProblemComponentNameKey];
    [attributes setObject:@(++componentIndex)
                   forKey:@"index"];

    NSLog(@"%@ index: %@", name, attributes[@"index"]);
    
    [problemAttr setName:name];
    [problemAttr setAttributes:attributes];
//    [problemAttr setIndex:componentIndex++];
    
    [children addObject:problemAttr];
    [_styles setObject:problemAttr forKey:name];
    
    name = @"Question";
    problemAttr = [[TKOProblemAttribute alloc] init];
    attributes = [NSMutableDictionary dictionary];
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setParagraphSpacing:9.0];
    [paragraphStyle setAlignment:NSNaturalTextAlignment];
    [attributes setObject:paragraphStyle
                   forKey:NSParagraphStyleAttributeName];
//    [attributes setObject:_defaultFont
//                   forKey:NSFontAttributeName];
    [attributes setObject:@"TKOProblemComponentQuestion"
                   forKey:TKOProblemComponentNameKey];
    [attributes setObject:@(++componentIndex)
                   forKey:@"index"];
    NSLog(@"%@ index: %@", name, attributes[@"index"]);
    
    [problemAttr setName:name];
    [problemAttr setAttributes:attributes];
//    [problemAttr setIndex:componentIndex++];
    
    [children addObject:problemAttr];
    [_styles setObject:problemAttr forKey:name];
    
    name = @"Roman";
    problemAttr = [[TKOProblemAttribute alloc] init];
    attributes = [NSMutableDictionary dictionary];
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSNaturalTextAlignment];
    NSTextList * list = [[NSTextList alloc] initWithMarkerFormat:@"{upper-roman}."
                                                         options:0];
    [paragraphStyle setTextLists:@[list]];
    NSTextTab * tab1 = [[NSTextTab alloc] initWithType:NSLeftTabStopType
                                              location:30.0];
    NSTextTab * tab2 = [[NSTextTab alloc] initWithType:NSLeftTabStopType
                                              location:50.0];
    
    [paragraphStyle setTabStops:@[tab1, tab2]];
    [paragraphStyle setHeadIndent:50.0];
    [paragraphStyle setParagraphSpacing:4.0];
    
    [attributes setObject:paragraphStyle
                   forKey:NSParagraphStyleAttributeName];
//    [attributes setObject:_defaultFont
//                   forKey:NSFontAttributeName];
    [attributes setObject:@"TKOProblemComponentRomans"
                   forKey:TKOProblemComponentNameKey];
    [attributes setObject:@(++componentIndex)
                   forKey:@"index"];
    NSLog(@"%@ index: %@", name, attributes[@"index"]);
    [problemAttr setName:name];
    [problemAttr setAttributes:attributes];
//    [problemAttr setIndex:componentIndex++];
    
    [children addObject:problemAttr];
    [_styles setObject:problemAttr forKey:name];
    
    name = @"Choices";
    problemAttr = [[TKOProblemAttribute alloc] init];
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSNaturalTextAlignment];
    list = [[NSTextList alloc] initWithMarkerFormat:@"({upper-alpha})"
                                            options:0];
    [paragraphStyle setTextLists:@[list]];
    NSTextTab * tab = [[NSTextTab alloc] initWithType:NSLeftTabStopType
                                             location:20.0];
    [paragraphStyle setTabStops:@[tab]];
    [paragraphStyle setHeadIndent:20.0];
    [paragraphStyle setParagraphSpacing:4.0];
    
    [attributes setObject:paragraphStyle
                   forKey:NSParagraphStyleAttributeName];
//    [attributes setObject:_defaultFont
//                   forKey:NSFontAttributeName];
    [attributes setObject:@"TKOProblemComponentChoices"
                   forKey:TKOProblemComponentNameKey];
    [attributes setObject:@(++componentIndex)
                   forKey:@"index"];
    NSLog(@"%@ index: %@", name, attributes[@"index"]);
    [problemAttr setName:name];
    [problemAttr setAttributes:attributes];
//    [problemAttr setIndex:componentIndex++];
    
    [children addObject:problemAttr];
    [_styles setObject:problemAttr forKey:name];

    return children;
}

+ (NSArray *)characterStyles
{
    return [NSArray array];
}

+ (NSArray *)listStyles
{
    return [NSArray array];
}

+ (NSArray *)headers
{
    return _headers;
}

+ (TKOProblemAttribute *)problemAttributeForName:(NSString *)name
{
    return _styles[name];
}

+ (NSAttributedString *)componentForString:(NSString *)string
                             attributeName:(NSString *)name
{
    TKOProblemAttribute * attribute = [_styles objectForKey:name];
    string = [string stringByReplacingOccurrencesOfString:@"\\n"
                                               withString:@"\n"];
    NSAttributedString * text = [[NSAttributedString alloc] initWithString:string
                                                                attributes:attribute.attributes];
    return text;
}

+ (NSAttributedString *)listForArray:(NSArray *)array
                       attributeName:(NSString *)name
{
    TKOProblemAttribute * attribute = [TKOProblemAttribute problemAttributeForName:name];
    NSDictionary * attributes = [attribute attributes];
    NSParagraphStyle * paragraphStyle = attributes[NSParagraphStyleAttributeName];
    NSTextList * list = paragraphStyle.textLists[0];
    
    NSMutableString * choices = [NSMutableString string];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [obj stringByTrimmingWhitespaceAndNewLineCharacters];
        obj = [NSString stringWithFormat:@"%@\t%@\n", [list markerForItemNumber:idx+1], obj];
        [choices appendString:obj];
    }];

    return [[NSAttributedString alloc] initWithString:choices
                                           attributes:attributes];
}

+ (NSIndexSet *)indexSetForArrayOfStyleNames:(NSArray *)names
{
    return nil;
}
@end
