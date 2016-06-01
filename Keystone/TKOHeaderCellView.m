//
//  TKOHeaderCellView.m
//  Keystone
//
//  Created by Todd Olsen on 6/22/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOHeaderCellView.h"

@implementation TKOHeaderCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    
    return self;
}

- (void)awakeFromNib
{
    [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.bounds
                                                       options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp
                                                         owner:self
                                                      userInfo:nil]];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [_badge setHidden:NO];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [_badge setHidden:YES];
}

@end
