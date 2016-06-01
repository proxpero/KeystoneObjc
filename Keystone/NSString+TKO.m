//
//  NSString+TKO.m
//  Keystone
//
//  Created by Todd Olsen on 6/7/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSString+TKO.h"

@implementation NSString (TKO)

- (NSString *)stringByTrimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByTrimmingWhitespaceAndNewLineCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
