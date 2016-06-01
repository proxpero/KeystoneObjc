//
//  TKOAppDelegate.h
//  Keystone
//
//  Created by Todd Olsen on 6/12/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"

@interface TKOAppDelegate : NSObject <NSApplicationDelegate, NSSplitViewDelegate>

//@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet INAppStoreWindow * window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
