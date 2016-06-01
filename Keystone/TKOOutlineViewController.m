//
//  TKOOutlineViewController.m
//  Keystone-OSX
//
//  Created by Todd Olsen on 4/4/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOOutlineViewController.h"

@interface TKOOutlineViewController ()

@end

@implementation TKOOutlineViewController {
    NSString * _dragTypeName;
}

- (void)awakeFromNib
{
    if (!_dragTypeName)
        _dragTypeName = @"TKODragType";
    [_outlineView registerForDraggedTypes:@[_dragTypeName]];
}

# pragma mark - Outline View Drag and Drop

- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView
                pasteboardWriterForItem:(id)item
{
    return (id <NSPasteboardWriting>)item;
}

- (void)outlineView:(NSOutlineView *)outlineView
    draggingSession:(NSDraggingSession *)session
   willBeginAtPoint:(NSPoint)screenPoint
           forItems:(NSArray *)draggedItems
{
    _draggedItem = nil;
    _draggedItem = draggedItems.lastObject;
    [session.draggingPasteboard setData:[NSData data]
                                forType:_dragTypeName];
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView
                  validateDrop:(id<NSDraggingInfo>)info
                  proposedItem:(id)item
            proposedChildIndex:(NSInteger)index
{
    if (!item)
        item = _rootItem;
    
    if ((![[item children] containsObject:_draggedItem]) ||                     // no leaving parent
            ([[item children] count] < 1) ||                                    // leaf
            (index == NSOutlineViewDropOnItemIndex && (item != _rootItem)) ||   // no drops 'on' leaf
                 // no outside sources
            ([info draggingSourceOperationMask] == NSDragOperationCopy) ||      // copy not supported
        (!_draggedItem))                                                        // no entity saved
        return NSDragOperationNone;
    
    if (![[info draggingSource] isEqual:_outlineView]) { // outside source
        NSLog(@"outside source");
    }
    
    id itemWalker = item;
    while (itemWalker) {
        if (itemWalker == _draggedItem)
            return NSDragOperationNone; // no becoming own descendant
        itemWalker = [outlineView parentForItem:itemWalker];
    }
        
    return NSDragOperationMove;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
         acceptDrop:(id<NSDraggingInfo>)info
               item:(id <TKOSourceListItem>)item
         childIndex:(NSInteger)index
{
    id destinationEntity = nil;
    if (!item) {
        destinationEntity = _rootItem;
    } else {
        destinationEntity = (id <TKOSourceListItem>)item;
    }
    
    NSAssert(([[destinationEntity children] count] > 0), @"Internal error: expecting a folder entity for dropping onto");
    
    if (index == NSOutlineViewDropOnItemIndex) // 'on' drop becomes first child
        index = 0;
    
    // perform drag reorder
    
    NSInteger fromIndex = [[_draggedItem index] integerValue];
    if (fromIndex == index)
        return NO;
    if (fromIndex < index)
        index--;
    
    NSArray * items = [destinationEntity items];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ((fromIndex < idx) && (idx <= index))
            [obj setValue:@(idx - 1)
                   forKey:@"index"];
        
        if ((index <= idx) && (idx < fromIndex))
            [obj setValue:@(idx + 1)
                   forKey:@"index"];
    }];
    
    [(NSManagedObject *)_draggedItem setValue:@(index)
                                       forKey:@"index"];
    
    [outlineView beginUpdates];
    if ([destinationEntity isEqual:_rootItem])
        destinationEntity = nil;
    [outlineView moveItemAtIndex:fromIndex
                        inParent:destinationEntity
                         toIndex:index
                        inParent:destinationEntity];
    [outlineView endUpdates];
    
    return YES;
}


@end
