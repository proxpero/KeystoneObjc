//
//  TKOMathematizerKit.m
//  Keystone
//
//  Created by Todd Olsen on 6/8/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOMathematizerKit.h"

static NSMutableDictionary * _attributes;
NSString * TKOProblemAttributeName = @"TKOProblemAttributeName";

@interface TKOMathematizerKit ()

@property (readwrite, nonatomic, strong) NSMutableArray * mutableReplacementRules;

@end

@interface TKOMathematizerRule : NSObject

@property (nonatomic, strong) NSString * replacementString;
@property (nonatomic, strong) NSString * oldString;

+ (instancetype)ruleWithReplacementString:(NSString *)replacementString
                                oldString:(NSString *)oldString;

- (NSRange)evaluateAttributedString:(NSMutableAttributedString *)string
                              range:(NSRange)range;

@end

@implementation TKOMathematizerKit

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    self.mutableReplacementRules = [[NSMutableArray alloc] init];
    _attributes = [[NSMutableDictionary alloc] init];
    
    NSFont * fixedPitchFont = [NSFont userFixedPitchFontOfSize:12.f];

    [_attributes setObject:fixedPitchFont
                    forKey:NSFontAttributeName];
    NSColor * blue = [NSColor blueColor];
    
    [_attributes setObject:blue
                    forKey:NSForegroundColorAttributeName];
    [_attributes setObject:@"TKOProblemMathAttributes"
                    forKey:TKOProblemAttributeName];
    
    return self;
}

+ (instancetype)defaultMathematizer {
    static id _defaultMathematizer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultMathematizer = [[self alloc] init];
        [_defaultMathematizer addDefaultRules];
    });
    
    return _defaultMathematizer;
}

- (void)mathematize:(NSMutableAttributedString *)string
{
    [self determineMathRangesOfString:string
                            fromIndex:0];
}

- (void)determineMathRangesOfString:(NSMutableAttributedString *)string
                          fromIndex:(NSInteger)index
{
    // http://stackoverflow.com/a/10457445/277905
    
    NSInteger openLocation = -1;
    for (NSInteger i = index; i < string.length; i++) {
        unichar c = [string.string characterAtIndex:i];
        if (c == '`') {
            if (openLocation == -1) {
                openLocation = i;
            } else {
                __block NSRange range = NSMakeRange(openLocation, i - openLocation + 1); // range of math mode
                
                // remove opening and closing backticks
                
                [string replaceCharactersInRange:NSMakeRange(i, 1)
                                      withString:@""];
                [string replaceCharactersInRange:NSMakeRange(openLocation, 1)
                                    withString:@""];
                range = NSMakeRange(range.location, range.length - 2);
                
                // replace LaTeX codes with unicode glyphs
                
                [self.mutableReplacementRules enumerateObjectsUsingBlock:^(id rule, NSUInteger idx, BOOL *stop) {
                    range = [rule evaluateAttributedString:string
                                                     range:range];
                }];
                
                // make letters italic
                
                [string addAttributes:_attributes
                                range:range];
                NSString * store = string.string;
                [store enumerateSubstringsInRange:range
                                          options:NSStringEnumerationByComposedCharacterSequences
                                       usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                           unichar k = [substring characterAtIndex:0];
                                           if ([[NSCharacterSet letterCharacterSet] characterIsMember:k]) { // this unichar is a letter
                                               NSFont * currentFont = [string attribute:NSFontAttributeName
                                                                                atIndex:substringRange.location
                                                                         effectiveRange:NULL];
                                               NSFont * newFont = [[NSFontManager sharedFontManager] convertFont:currentFont
                                                                                                     toHaveTrait:NSItalicFontMask];
                                               [string addAttribute:NSFontAttributeName // make this character italic
                                                              value:newFont
                                                              range:substringRange]; // range is one (visible) character
                                           }
                                       }];
                
                NSString * sqrt = @"\\sqrt";
                NSString * frac = @"\\frac";
                NSArray * fixedLengthWords = @[sqrt, frac];
                
                NSRange findRange; // Originally equal to the math mode range, continually narrowed as matched are identified.
                NSRange fixRange; // The range of the fixedWord to which to apply attributes
                
                for (NSString * fix in fixedLengthWords) {
                    findRange = NSMakeRange(range.location, range.length);
                    fixRange = [store rangeOfString:fix
                                            options:0
                                              range:range];
                    while (fixRange.location != NSNotFound) {
                        NSFont * newFont = [NSFont userFixedPitchFontOfSize:9.0];
                        [string addAttribute:NSFontAttributeName
                                       value:newFont
                                       range:fixRange];
                        findRange = NSMakeRange(findRange.location + fix.length, findRange.length - fix.length);
                        fixRange = [store rangeOfString:fix
                                                options:0
                                                  range:findRange];
                    }
                }
                
                NSString  * functionBegining = @"f(";
                NSArray * loosenKernCombinations = @[functionBegining];
                
                for (NSString * kern in loosenKernCombinations) {
                    findRange = NSMakeRange(range.location, range.length);
                    fixRange = [store rangeOfString:kern options:0 range:range];
                    fixRange = NSMakeRange(fixRange.location, fixRange.length - 1);
                    while (fixRange.location != NSNotFound) {
                        NSDictionary * loosenAttribute = @{NSKernAttributeName: @(2.0)};
                        [string addAttributes:loosenAttribute
                                        range:fixRange];
                        findRange = NSMakeRange(findRange.location + kern.length, findRange.length - kern.length);
                        fixRange = [store rangeOfString:kern options:0 range:findRange];
                    }
                }
                
                [self determineMathRangesOfString:string
                                        fromIndex:openLocation + range.length];
            }
        }
    }
}

- (void)addReplacementString:(NSString *)newString
                   forString:(NSString *)oldString
{
    [self.mutableReplacementRules addObject:[TKOMathematizerRule ruleWithReplacementString:newString
                                                                                   oldString:oldString]];
}

- (void)addDefaultRules
{
    #define TIMES                           @"×"    // U+00D7
    #define PLUS_OR_MINUS                   @"±"    // U+00B1
    #define DIVIDED_BY                      @"÷"    // U+00F7
    #define NO_BREAK_SPACE                  @" "    // U+202F
    #define SCRIPT_SMALL_L                  @"ℓ"    // U+2113
    #define MINUS_SIGN                      @"−"    // U+2212
    #define ANGLE                           @"∠"    // U+2220
    #define NOT_EQUAL_TO                    @"≠"    // U+2260
    #define PERPENDICULAR                   @"⊥"    // U+22A5
    #define DIAMOND                         @"◆"    // U+25C6
    #define BLACK_SQUARE                    @"◼"    // U+25FC
    #define PARALLEL                        @"‖"    // U+2016
    #define TRIANGLE                        @"△"    // U+25B3
    #define PI_CHARACTER                    @"π"    // U+03C0
    #define UP_ARROW                        @"⇧"    // U+21E7
//    [self addReplacementString:PLUS_OR_MINUS forString:@"???"];
//    [self addReplacementString:DIVIDED_BY forString:@"???"];
    [self addReplacementString:NO_BREAK_SPACE           forString:@" "];
    [self addReplacementString:MINUS_SIGN               forString:@"-"];
    [self addReplacementString:NOT_EQUAL_TO             forString:@"!="];
    [self addReplacementString:PERPENDICULAR            forString:@"\\perp"];
    [self addReplacementString:TIMES                    forString:@"\\times"];
    [self addReplacementString:DIAMOND                  forString:@"\\diamond"];
    [self addReplacementString:SCRIPT_SMALL_L           forString:@"\\ell"];
    [self addReplacementString:ANGLE                    forString:@"\\angle"];
    [self addReplacementString:BLACK_SQUARE             forString:@"\\blacksquare"];
    [self addReplacementString:PARALLEL                 forString:@"\\|"];
    [self addReplacementString:TRIANGLE                 forString:@"\\triangle"];
    [self addReplacementString:PI_CHARACTER             forString:@"\\pi"];
    [self addReplacementString:UP_ARROW                 forString:@"\\Uparrow"];
}

@end

@implementation TKOMathematizerRule

+ (instancetype)ruleWithReplacementString:(NSString *)replacementString
                                oldString:(NSString *)oldString
{
    TKOMathematizerRule * rule = [[TKOMathematizerRule alloc] init];
    [rule setReplacementString:replacementString];
    [rule setOldString:oldString];

    return rule;
}

- (NSRange)evaluateAttributedString:(NSMutableAttributedString *)string
                              range:(NSRange)range
{
    NSUInteger factor = [string.mutableString replaceOccurrencesOfString:self.oldString
                                                              withString:self.replacementString                                             options:0                                               range:range];
    NSUInteger length = range.length - (factor * (self.oldString.length - self.replacementString.length));
    return NSMakeRange(range.location, length);
}

@end