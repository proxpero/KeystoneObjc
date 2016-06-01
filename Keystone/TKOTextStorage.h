//
//  TKOTextStorage.h
//  CoreDataAttributedString
//
//  Created by Todd Olsen on 6/25/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
NSString *const TKODefaultTokenName;

@interface TKOTextStorage : NSTextStorage
@property (nonatomic, copy) NSDictionary *tokens;
@end
