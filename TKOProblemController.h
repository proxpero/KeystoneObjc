//
//  TKOProblemController.h
//  Keystone
//
//  Created by Todd Olsen on 6/26/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOProblemController : NSWindowController <NSWindowDelegate, NSTextDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource, NSSplitViewDelegate>
@property (strong) TKOProblem * problem;
@end
