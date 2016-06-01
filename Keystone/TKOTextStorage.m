//
//  TKOTextStorage.m
//  CoreDataAttributedString
//
//  Created by Todd Olsen on 6/25/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOTextStorage.h"
NSString *const TKODefaultTokenName = @"TKODefaultTokenName";

@implementation TKOTextStorage
{
    NSMutableAttributedString * _backingStore;
    BOOL _dynamicTextNeedsUpdate;
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    _backingStore = [[NSMutableAttributedString alloc] initWithString:@"Hello, World"];
    return self;
}

# pragma mark - Overriding four privitive methods to subclass NSTextStorage
// https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/TextStorageLayer/Tasks/Subclassing.html

- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location
                             effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range
                      withString:(NSString *)str
{
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range
                                 withString:str];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes
           range:range
  changeInLength:str.length - range.length];
    
    _dynamicTextNeedsUpdate = YES;
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs
                range:(NSRange)range
{
    [self beginEditing];
    [_backingStore setAttributes:attrs
                           range:range];
    [self edited:NSTextStorageEditedAttributes
           range:range
  changeInLength:0];
    [self endEditing];    
}

# pragma mark - Text Storage Override

- (void)processEditing
{
    if (_dynamicTextNeedsUpdate) {
        _dynamicTextNeedsUpdate = NO;
        [self performReplacementsForCharacterChangeInRange:[self editedRange]];
    }
    [super processEditing];
}

# pragma mark - Custom Methods

- (void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange
{
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    [self applyTokenAttributesToRange:extendedRange];
}

- (void)applyTokenAttributesToRange:(NSRange)searchRange
{
    NSDictionary *defaultAttributes = [self.tokens objectForKey:TKODefaultTokenName];
    
    [[_backingStore string] enumerateSubstringsInRange:searchRange options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        NSDictionary *attributesForToken = [self.tokens objectForKey:substring];
        if (!attributesForToken)
            attributesForToken = defaultAttributes;
        
        if (attributesForToken)
            [self addAttributes:attributesForToken
                          range:substringRange];
    }];
}

@end
