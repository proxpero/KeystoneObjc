//
//  NSMutableString+TKO.m
//  Keystone
//
//  Created by Todd Olsen on 6/7/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSMutableString+TKO.h"

@implementation NSMutableString (TKO)

- (void)trimWhitespace
{
    [self setString:[self stringByTrimmingWhitespace]];
}

- (void)trimWhitespaceAndNewLineCharacters
{
    [self setString:[self stringByTrimmingWhitespaceAndNewLineCharacters]];
}

- (void)trimPunctuation
{
    [self setString:[self stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]]];
}

- (void)trimList
{
    NSMutableCharacterSet * charSet = [[NSMutableCharacterSet alloc] init];
    [charSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [self setString:[self stringByTrimmingCharactersInSet:charSet]];
}

@end
