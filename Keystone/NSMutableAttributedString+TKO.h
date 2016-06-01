//
//  NSMutableAttributedString+TKO.h
//  Keystone
//
//  Created by Todd Olsen on 6/9/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (TKO)

//- (void)addAttributes:(NSDictionary *)attributes
- (NSArray *)rangesBetweenOpenString:(NSString *)openString
                         closeString:(NSString *)closeString
                    removeDelimiters:(BOOL)remove;

@end
