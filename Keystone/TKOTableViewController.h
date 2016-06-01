//
//  TKOTableViewController.h
//  Keystone
//
//  Created by Todd Olsen on 6/16/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKOTableViewController : NSObject <NSTableViewDelegate, NSWindowDelegate, NSTextViewDelegate>
@property (strong) id <TKOSourceListItem> item;
//@property (strong) NSMutableArray * problems;

@end
