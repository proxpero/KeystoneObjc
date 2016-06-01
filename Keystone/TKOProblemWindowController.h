//
//  TKOProblemWindowController.h
//  Keystone
//
//  Created by Todd Olsen on 6/26/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOProblemWindowController : NSWindowController <NSWindowDelegate, NSTextDelegate, NSTextViewDelegate, NSSplitViewDelegate, NSTableViewDelegate, NSTableViewDataSource, NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (strong) TKOProblem * problem;

+ (void)presentWindowForProblem:(TKOProblem *)problem;
@end
