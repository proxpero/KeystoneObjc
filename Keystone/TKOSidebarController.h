//
//  TKOSidebarController.h
//  Keystone
//
//  Created by Todd Olsen on 6/12/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKOOutlineViewController.h"

@interface TKOSidebarController : TKOOutlineViewController <NSOutlineViewDataSource, NSOutlineViewDelegate, NSTextDelegate>
@property (strong) TKOList * selectedList;

- (void)updateOutlineView:(id)sender;

@end
