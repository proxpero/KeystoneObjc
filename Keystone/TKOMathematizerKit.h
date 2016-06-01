//
//  TKOMathematizerKit.h
//  Keystone
//
//  Created by Todd Olsen on 6/8/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKOMathematizerKit : NSObject

+ (instancetype)defaultMathematizer;

- (void)mathematize:(NSMutableAttributedString *)string;
- (void)addReplacementString:(NSString *)replacementString
                   forString:(NSString *)oldString;

@end
