//
//  TKOHeaderCellView.h
//  Keystone
//
//  Created by Todd Olsen on 6/22/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DropDownButton.h"

@interface TKOHeaderCellView : NSTableCellView
//@property (strong) NSPopUpButtonCell * popUpCell;
@property (weak) IBOutlet DropDownButton * badge;
@end
