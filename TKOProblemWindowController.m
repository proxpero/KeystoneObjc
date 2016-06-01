//
//  TKOProblemWindowController.m
//  Keystone
//
//  Created by Todd Olsen on 6/22/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#define STANDARD_WIDTH 320.0

#import "TKOProblemWindowController.h"
#import "INAppStoreWindow.h"
#import "TKOTableViewController.h"
#import "TKODefaultProblemAttributes.h"

static NSArray * _styles = nil;

@interface TKOProblemWindowController ()
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSOutlineView *outlineView;

@end

@implementation TKOProblemWindowController

+ (void)initialize
{
    if (!_styles) {
        _styles = [[TKODefaultProblemAttributes sharedInstance] styles];
//        _styles = [[NSMutableArray alloc] init];
//        
//        NSMutableDictionary * attributes;
//        
//        attributes = [[NSMutableDictionary alloc] init];
//        [attributes setObject:@"Component Styles" forKey:@"name"];
//        [_styles addObject:attributes];
//        
//        NSMutableArray * children = [[NSMutableArray alloc] init];
//        NSMutableDictionary * child;
//        
//        child = [[NSMutableDictionary alloc] init];
//        [child setObject:@"Image" forKey:@"name"];
//        [children addObject:child];
//        
//        child = [[NSMutableDictionary alloc] init];
//        [child setObject:@"Caption" forKey:@"name"];
//        [children addObject:child];
//        
//        child = [[NSMutableDictionary alloc] init];
//        [child setObject:@"Prelude" forKey:@"name"];
//        [children addObject:child];
//        
//        child = [[NSMutableDictionary alloc] init];
//        [child setObject:@"Question" forKey:@"name"];
//        [children addObject:child];
//        
//        child = [[NSMutableDictionary alloc] init];
//        [child setObject:@"Romans" forKey:@"name"];
//        [children addObject:child];
//        
//        child = [[NSMutableDictionary alloc] init];
//        [child setObject:@"Choices" forKey:@"name"];
//        [children addObject:child];
//        
//        [attributes setObject:children forKey:@"children"];
//        
    }
}

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    [self setTableController:sender];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    INAppStoreWindow * window = (INAppStoreWindow *)[self window];
    [window setTitleBarHeight:30.0];
    
    [_textView setTextContainerInset:NSMakeSize(30.0, 30.0)];
    [_textView setHorizontallyResizable:NO];
    [_textView setVerticallyResizable:YES];
    NSTextContainer * container = [_textView textContainer];
    [container setWidthTracksTextView:YES];
    [container setHeightTracksTextView:NO];
    [_outlineView expandItem:nil expandChildren:YES];

}

- (void)zoomText
{
    NSRect textViewBounds = [_textView bounds];
    CGFloat ratio = _textView.frame.size.height / _textView.frame.size.width;
    textViewBounds.size.height = ratio * STANDARD_WIDTH;
    textViewBounds.size.width = STANDARD_WIDTH;
    
    [_textView setBounds:textViewBounds];
    [_textView setFrameSize:[_textView frame].size];
    [_textView sizeToFit];
    
    [_textView setNeedsDisplayInRect:[_textView visibleRect]];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[self tableController] closeProblemPanel:self];
}

# pragma mark - Window Delegate

- (void)windowDidResize:(NSNotification *)notification
{
    [self zoomText];
}

# pragma mark - Outline View Delegate

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item
{
    if ([_styles containsObject:item]) {
        NSTableCellView * result = [outlineView makeViewWithIdentifier:@"HeaderCell"
                                                                 owner:self];
        NSString * name = [item objectForKey:@"name"];
        [result.textField setStringValue:name];
        return result;
    }
    
    NSTableCellView * result = [outlineView makeViewWithIdentifier:@"DataCell"
                                                             owner:self];
    NSString * name = [item objectForKey:@"name"];
    [result.textField setStringValue:name];
    return result;

}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return !([_styles containsObject:item]);
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
        isGroupItem:(id)item
{
    return [_styles containsObject:item];
}

# pragma mark - Outline View Data Source

- (id)outlineView:(NSOutlineView *)outlineView
            child:(NSInteger)index
           ofItem:(id)item
{
    if (!item)
        return _styles[index];
    return [item objectForKey:@"children"][index];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView
  numberOfChildrenOfItem:(id)item
{
    if (!item)
        return _styles.count;
    return [[item objectForKey:@"children"] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(id)item
{
    return [_styles containsObject:item];
}

# pragma mark - Split View Delegate

- (BOOL)        splitView:(NSSplitView *)splitView
shouldAdjustSizeOfSubview:(NSView *)view
{
    return !([view.identifier isEqualToString:@"StylesBar"]);
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
