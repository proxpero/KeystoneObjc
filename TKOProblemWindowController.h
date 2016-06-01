//
//  TKOProblemWindowController.h
//  Keystone
//
//  Created by Todd Olsen on 6/22/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TKOTableViewController;

@interface TKOProblemWindowController : NSWindowController <NSWindowDelegate, NSTableViewDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource>
@property (strong) TKOProblem * problem;
@property (strong) TKOTableViewController * tableController;
@end
