//
//  NSMutableAttributedString+MathematizerKit.m
//  Keystone
//
//  Created by Todd Olsen on 6/8/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSMutableAttributedString+MathematizerKit.h"
#import "TKOMathematizerKit.h"

@implementation NSMutableAttributedString (MathematizerKit)

- (void)mathematize
{
    [[TKOMathematizerKit defaultMathematizer] mathematize:self];
}

@end
