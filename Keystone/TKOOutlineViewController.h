//
//  TKOOutlineViewController.h
//  Keystone-OSX
//
//  Created by Todd Olsen on 4/4/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOSourceListItem.h"

@interface TKOOutlineViewController : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource>
@property (weak) IBOutlet NSOutlineView * outlineView;
@property (strong) id <TKOSourceListItem> rootItem;
@property (strong) id <TKOSourceListItem> draggedItem;
@end
