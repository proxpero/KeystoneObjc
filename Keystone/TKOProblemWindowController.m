//
//  TKOProblemWindowController.m
//  Keystone
//
//  Created by Todd Olsen on 6/26/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#define STANDARD_WIDTH 340.0

#import "TKOProblemWindowController.h"
#import "INAppStoreWindow.h"
#import "TKOTextStorage.h"
#import "TKODefaultProblemAttributes.h"
#import "TKOHeaderCellView.h"

static NSMutableArray * _instances = nil;
static NSArray * _headers = nil;

@interface TKOProblemWindowController ()

@property (weak) IBOutlet NSView *titleView;
@property (weak) IBOutlet NSOutlineView *outlineView;

@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation TKOProblemWindowController

+ (void)presentWindowForProblem:(TKOProblem *)problem
{
    TKOProblemWindowController * controller = [[TKOProblemWindowController alloc] initWithWindowNibName:@"TKOProblemWindowController"];
    [[TKOProblemWindowController instances] addObject:controller];
    [controller setProblem:problem];
    [controller showWindow:self];
    
    NSTextView * textView = controller.textView;
    [textView.layoutManager replaceTextStorage:[[TKOTextStorage alloc] init]];
    [textView bind:@"attributedString"
          toObject:problem
       withKeyPath:@"attributedString"
           options:@{NSContinuouslyUpdatesValueBindingOption: @(YES)}];
    [textView setTextContainerInset:NSMakeSize(30.0, 30.0)];
    [textView setFont:[NSFont fontWithName:@"Times"
                                      size:12.0]];
    [textView setUsesRuler:YES];
    
    NSOutlineView * outlineView = controller.outlineView;
    [outlineView reloadData];
    [outlineView expandItem:nil
             expandChildren:YES];
}

+ (NSMutableArray *)instances
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instances = [[NSMutableArray alloc] init];
        _headers = [TKOProblemAttribute headers];
    });
    
    return _instances;
}

# pragma mark - Text Delegate

- (void)textDidEndEditing:(NSNotification *)notification
{

}

# pragma mark - Text View Delegate

- (void)textViewDidChangeSelection:(NSNotification *)notification
{
    NSRange range = [_textView selectedRange];
    if (range.location == NSNotFound) {
        [_outlineView deselectAll:nil];
        return;
    }

    __block NSMutableIndexSet * selectedStylesIndexSet = [[NSMutableIndexSet alloc] init];
    [_textView.attributedString enumerateAttributesInRange:range
                                                   options:0
                                                usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                                                    NSInteger index = [attrs[@"index"] integerValue];
                                                    NSLog(@"index %lu", index);
                                                    [selectedStylesIndexSet addIndex:index];
                                                }];
    NSLog(@"selectedStylesIndexSet: %@", selectedStylesIndexSet);
    [_outlineView selectRowIndexes:selectedStylesIndexSet
              byExtendingSelection:NO];
}

# pragma mark - Outline View Delegate

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedIndex = [_outlineView selectedRow];
    NSRange range = [_textView selectedRange];
    NSRange effectiveRange;
    NSDictionary * paragraphAttribute = [_textView.textStorage attribute:NSParagraphStyleAttributeName
                                                                 atIndex:range.location
                                                   longestEffectiveRange:&effectiveRange
                                                                 inRange:NSMakeRange(0,_textView.textStorage.length)];
    NSLog(@"selected index = %lu\trange = %@\t\teffective range = %@", selectedIndex, NSStringFromRange(range), NSStringFromRange(effectiveRange));
    
    
//    TKOProblemAttribute * problemAttribute = [
    
    
}

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item
{
    if ([_headers containsObject:item]) {
        TKOHeaderCellView * result = [outlineView makeViewWithIdentifier:@"HeaderCell"
                                                                   owner:nil];
        [result.textField setStringValue:[[item objectForKey:@"name"] uppercaseString]];
        return result;
    } else {
        NSTableCellView * result = [outlineView makeViewWithIdentifier:@"DataCell"
                                                                 owner:self];
        [result.textField setStringValue:[item name]];
        return result;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
        isGroupItem:(id)item
{
    return [_headers containsObject:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   shouldSelectItem:(id)item
{
    return ![_headers containsObject:item];
}

- (BOOL)            outlineView:(NSOutlineView *)outlineView
   shouldShowOutlineCellForItem:(id)item
{
    return ![_headers containsObject:item];    
}

- (void)outlineView:(NSOutlineView *)outlineView
    willDisplayCell:(id)cell
     forTableColumn:(NSTableColumn *)tableColumn
               item:(id)item
{
    if ([_headers containsObject:item])
        cell = nil;
}

# pragma mark - Outline View Data Source

- (NSInteger)outlineView:(NSOutlineView *)outlineView
  numberOfChildrenOfItem:(id)item
{
    if (!item)
        return _headers.count;
    
    NSDictionary * header = (NSDictionary *)item;
    NSArray * children = header[@"children"];
    return [children count];
}

- (id)outlineView:(NSOutlineView *)outlineView
            child:(NSInteger)index
           ofItem:(id)item
{
    if (!item)
        return _headers[index];
    NSDictionary * header = (NSDictionary *)item;
    NSArray * children = header[@"children"];
    return children[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(id)item
{
    return [_headers containsObject:item];
}

# pragma mark - Window delegate

- (void)windowDidLoad
{
    INAppStoreWindow * window = (INAppStoreWindow *)self.window;
    [window setTitleBarHeight:37.0];
    NSView * titleBarView = window.titleBarView;
    _titleView.frame = titleBarView.bounds;
    [_titleView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [titleBarView addSubview:_titleView];
    [self zoomText];
}

- (void)windowWillClose:(NSNotification *)notification
{
    //  TODO: Fix Leak
    //    [[TKOProblemWindowController instances] removeObject:self];
}

- (void)zoomText
{
    NSRect textViewBounds = [_textView bounds];
    CGFloat ratio = _textView.frame.size.height / _textView.frame.size.width;
    textViewBounds.size.height = ratio * STANDARD_WIDTH;
    textViewBounds.size.width = STANDARD_WIDTH;
    
    NSLog(@"ratio: %f, textViewBounds: %@", ratio, NSStringFromRect(textViewBounds));
    
    [_textView setBounds:textViewBounds];
    [_textView setFrameSize:[_textView frame].size];
    [_textView sizeToFit];
    
    [_textView setNeedsDisplayInRect:[_textView visibleRect]];
}

- (void)windowDidResize:(NSNotification *)notification
{
    [self zoomText];
}

# pragma mark - Split View Delegate

- (BOOL)        splitView:(NSSplitView *)splitView
shouldAdjustSizeOfSubview:(NSView *)view
{
    return !([view.identifier isEqualToString:@"SideBar"]);
}

- (CGFloat)     splitView:(NSSplitView *)splitView
   constrainMaxCoordinate:(CGFloat)proposedMaximumPosition
              ofSubviewAt:(NSInteger)dividerIndex
{
    if (dividerIndex == 0) {
        if (proposedMaximumPosition > 300.0) {
            proposedMaximumPosition = 300.0;
        }
    }
    return proposedMaximumPosition;
}

- (CGFloat)     splitView:(NSSplitView *)splitView
   constrainMinCoordinate:(CGFloat)proposedMinimumPosition
              ofSubviewAt:(NSInteger)dividerIndex
{
    if (dividerIndex == 0) {
        if (proposedMinimumPosition < 150.0) {
            proposedMinimumPosition = 150.0;
        }
    }
    return proposedMinimumPosition;
}

- (void)splitViewDidResizeSubviews:(NSNotification *)notification
{
    [self zoomText];
}

@end
