//
//  NSMutableString+TKO.h
//  Keystone
//
//  Created by Todd Olsen on 6/7/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (TKO)

- (void)trimWhitespace;
- (void)trimWhitespaceAndNewLineCharacters;
- (void)trimPunctuation;
- (void)trimList;

@end
