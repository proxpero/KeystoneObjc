//
//  TKOProblemController.m
//  Keystone
//
//  Created by Todd Olsen on 6/26/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#define STANDARD_WIDTH 320.0

#import "TKOProblemController.h"
#import "TKOTextStorage.h"

@interface TKOProblemController ()
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (unsafe_unretained) IBOutlet NSTextView *textView;


@end

@implementation TKOProblemController
{
    NSArray * _styles;
}

- (id)init
{
    self = [super initWithWindowNibName:@"TKOProblemController"];
    if (!self )
        return nil;

    [_textView.layoutManager replaceTextStorage:[[TKOTextStorage alloc] init]];
    NSTextContainer * container = _textView.textContainer;
    [container setWidthTracksTextView:YES];
    [container setHeightTracksTextView:NO];
    [container setContainerSize:NSMakeSize(_textView.bounds.size.width, CGFLOAT_MAX)];
    [_textView setTextContainerInset:NSMakeSize(30.0, 30.0)];
    
    return self;
}

# pragma mark - Window Delegate

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

- (void)windowDidResize:(NSNotification *)notification
{
    [self zoomText];
}

# pragma mark - Text View Delegate

- (void)textDidEndEditing:(NSNotification *)notification
{
    NSLog(@"%@", NSStringFromClass([_textView.textStorage class]));
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
