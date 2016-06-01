//
//  NSString+TKO.h
//  Keystone
//
//  Created by Todd Olsen on 6/7/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TKO)

- (NSString *)stringByTrimmingWhitespace;
- (NSString *)stringByTrimmingWhitespaceAndNewLineCharacters;

@end
