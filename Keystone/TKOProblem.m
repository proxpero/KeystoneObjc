//
//  TKOProblem.m
//  Keystone
//
//  Created by Todd Olsen on 6/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOProblem.h"
#import "TKOList.h"
#import "TKOTag.h"
#import "TKOTemplate.h"
#import "NSMutableAttributedString+MathematizerKit.h"

//static NSMutableArray * _styles = nil;
static NSFont * _defaultFont = nil;
static NSDictionary * _mathAttributes;

@implementation TKOProblem

@dynamic uuid;
@dynamic attributedString;
//@dynamic rtfd;
@dynamic difficulty;
@dynamic timestamp;
@dynamic string;
@dynamic pdf;
@dynamic answerDesc;
@dynamic milliseconds;
@dynamic possibleAnswers;
@dynamic multipleChoiceAnswer;
@dynamic options;
@dynamic lists;
@dynamic problemTemplate;
@dynamic tags;

# pragma mark - Set Up

//- (NSAttributedString *)makeRomansWithArray:(NSArray *)array
//{
//    static NSMutableDictionary * attributes = nil;
//    static NSTextList * list = nil;
//    if (!attributes) {
//        attributes = [NSMutableDictionary dictionary];
//        
//        NSMutableParagraphStyle * paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//        [paragraph setAlignment:NSNaturalTextAlignment];
//        list = [[NSTextList alloc] initWithMarkerFormat:@"{upper-roman}."
//                                                options:0];
//        [paragraph setTextLists:@[list]];
//        NSTextTab * tab1 = [[NSTextTab alloc] initWithType:NSLeftTabStopType
//                                                  location:30.0];
//        NSTextTab * tab2 = [[NSTextTab alloc] initWithType:NSLeftTabStopType
//                                                  location:50.0];
//        
//        [paragraph setTabStops:@[tab1, tab2]];
//        [paragraph setHeadIndent:50.0];
//        [paragraph setParagraphSpacing:4.0];
//        
//        [attributes setObject:paragraph
//                       forKey:NSParagraphStyleAttributeName];
//        [attributes setObject:_defaultFont
//                       forKey:NSFontAttributeName];
//        [attributes setObject:@"TKOProblemComponentRomans"
//                       forKey:TKOProblemComponentNameKey];
//    }
//    
//    NSMutableString * romans = [NSMutableString string];
//    [array enumerateObjectsUsingBlock:^(id roman, NSUInteger idx, BOOL *stop) {
//        [roman stringByTrimmingWhitespaceAndNewLineCharacters];
//        roman = [NSString stringWithFormat:@"\t%@\t%@\n", [list markerForItemNumber:idx+1], roman];
//        [romans appendString:roman];
//    }];
//    return [[NSAttributedString alloc] initWithString:romans
//                                           attributes:attributes];
//}

//+ (NSAttributedString *)makeChoicesWithArray:(NSArray *)array
//{
//    static NSMutableDictionary * attributes = nil;
//    static NSTextList * list = nil;
//    if (!attributes) {
//        if (!_defaultFont)
//            _defaultFont = [NSFont fontWithName:@"Adobe Garamond Pro"
//                                           size:12.0];
//        attributes = [NSMutableDictionary dictionary];
//        
//        NSMutableParagraphStyle * paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//        [paragraph setAlignment:NSNaturalTextAlignment];
//        list = [[NSTextList alloc] initWithMarkerFormat:@"({upper-alpha})"
//                                                options:0];
//        [paragraph setTextLists:@[list]];
//        NSTextTab * tab = [[NSTextTab alloc] initWithType:NSLeftTabStopType
//                                                 location:20.0];
//        [paragraph setTabStops:@[tab]];
//        [paragraph setHeadIndent:20.0];
//        [paragraph setParagraphSpacing:4.0];
//        
//        [attributes setObject:paragraph
//                       forKey:NSParagraphStyleAttributeName];
//        [attributes setObject:_defaultFont
//                       forKey:NSFontAttributeName];
//        [attributes setObject:@"TKOProblemComponentChoices"
//                       forKey:TKOProblemComponentNameKey];
//        [attributes setObject:@"Choices"
//                       forKey:NSToolTipAttributeName];
//    }
//    
//    NSMutableString * choices = [NSMutableString string];
//    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [obj stringByTrimmingWhitespaceAndNewLineCharacters];
//        obj = [NSString stringWithFormat:@"%@\t%@\n", [list markerForItemNumber:idx+1], obj];
//        [choices appendString:obj];
//    }];
//    
//    return [[NSAttributedString alloc] initWithString:choices
//                                           attributes:attributes];
//}

# pragma mark - Set Up

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setTimestamp:[NSDate date]];
    [self setUuid:[[NSUUID UUID] UUIDString]];
    [self registerKVO];
}

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    [self registerKVO];
}

- (void)registerKVO
{
    // this might be an unnecessary set of attrStr called twice if it's fired on awakeFromFetch
    [self addObserver:self
           forKeyPath:@"attributedString"
              options:0
              context:NULL];
    [self addObserver:self
           forKeyPath:@"difficulty"
              options:0
              context:NULL];
    [self addObserver:self
           forKeyPath:@"problemTemplate.milliseconds"
              options:0
              context:NULL];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"attributedString"];
    [self removeObserver:self forKeyPath:@"difficulty"];
    [self removeObserver:self forKeyPath:@"problemTemplate.milliseconds"];
}

# pragma mark - Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"attributedString"]) {
        [self setString:[self.attributedString string]];
        return;
    }
    
    if ([keyPath isEqualToString:@"difficulty"]) {
        [self computeMilliseconds];
        return;
    }
    
    if ([keyPath isEqualToString:@"problemTemplate.milliseconds"]) {
        [self computeMilliseconds];
        return;
    }
}

+ (TKOProblem *)problemWithDictionary:(NSDictionary *)dict
{
    NSString * ancestorName = dict[@"ParentName"];
    NSString * templateName = dict[@"TemplateName"];
    TKOTemplate * template = [TKOTemplate templateWithName:templateName
                                                parentName:ancestorName];
    NSAssert(template, @"No Template with name %@ parent %@", templateName, ancestorName);
    
    NSMutableString * tagName = [NSMutableString stringWithFormat:@"%@ %@", dict[@"ListName"], dict[@"Section"]];
    [tagName trimWhitespace];
    [tagName insertString:@"Test " atIndex:0];
    
    TKOTag * testTag = [TKOTag tagWithName:@"Test"];
    
    TKOTag * tag = [TKOTag tagWithName:tagName];
    if (!tag)
        tag = [TKOTag createWithName:tagName
                               index:0
                              parent:testTag];

    TKOProblem * problem;
    
    NSString * content = dict[@"Question"];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.string contains %@", content];
    NSSet * duplicates = [template problems];
    duplicates = [duplicates filteredSetUsingPredicate:predicate];
    
    NSAssert([duplicates count] < 2, @"Error deduplicating Problem Import");
    
    if (duplicates.count == 1) {
        problem = duplicates.anyObject;
        
    } else {        
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc] init];
        NSArray * array;

        if (content && content.length > 0) {
            
            content = [content stringByTrimmingWhitespaceAndNewLineCharacters];
            content = [content stringByAppendingString:@"\n"];
            [text appendAttributedString:[TKOProblemAttribute componentForString:content
                                                                   attributeName:@"Question"]];
        }
        
        array = dict[@"Choices"];
        NSMutableAttributedString * c = [[NSMutableAttributedString alloc] init];
        if (array) {
            [c appendAttributedString:[TKOProblemAttribute listForArray:array
                                                          attributeName:@"Choices"]];
        }
        
        [c.mutableString trimWhitespaceAndNewLineCharacters];
        [text appendAttributedString:c];
        
        problem = [TKOProblem create];
        [problem setAnswerDesc:dict[@"AnswerDescription"]];
        [problem setMultipleChoiceAnswer:dict[@"Answer"]];
        [problem setDifficulty:dict[@"Composite"]];
        
        [text mathematize];
        [problem setAttributedString:text];
//        NSLog(@"text: %@", problem.attributedString);
    }
    
    [problem addTagsObject:tag];
    [problem setProblemTemplate:template];
    
    return problem;
}

- (NSString *)tagList
{
    NSMutableString * tags = [[NSMutableString alloc] init];
    for (TKOTag * tag in self.tags.sortedByName)
        [tags appendFormat:@"%@, ",tag.name];
    
    [tags trimList];
    
    return tags;
}

- (void)computeMilliseconds
{
    float averageTime = self.problemTemplate.milliseconds.floatValue;
    float difficulty = self.difficulty.floatValue;
    
    #define time_difficulty_coefficient 0.8
    #define midrange                    300.0 // (800 - 200) / 2
    
    float slope = (time_difficulty_coefficient / midrange);
    
    float multiplier = (slope * difficulty) + 1 - (slope * 500.0);
    float milliseconds = averageTime * multiplier;
    [self setMilliseconds:@(milliseconds)];    
}

# pragma mark - Source List Protocol

+ (NSString *)name
{
    return @"Problems";
}

+ (void)createNewItem
{
    
}

- (NSArray *)items
{
    NSArray * items;
    return items;
}

# pragma mark - Style Attributes

+ (NSArray *)paragraphStyles
{
    NSArray * paragraphStyles;
    paragraphStyles = [[NSUserDefaults standardUserDefaults] arrayForKey:TKOProblemParagraphStylesArrayKey];
    if (paragraphStyles)
        return paragraphStyles;
    
    NSMutableArray * _defaults = [NSMutableArray array];
    
    
    paragraphStyles = [NSArray arrayWithArray:_defaults];
    [[NSUserDefaults standardUserDefaults] setObject:paragraphStyles
                                              forKey:TKOProblemParagraphStylesArrayKey];
    return paragraphStyles;
}

# pragma mark - Make PDF

- (void)updatePDF
{
    CGFloat myWidth = 260.0;
    
    NSTextStorage * textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedString];
    NSTextContainer * textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(myWidth, FLT_MAX)];

    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textContainer setLineFragmentPadding:0.0];
    
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    
    CGFloat h = [layoutManager usedRectForTextContainer:textContainer].size.height;
    NSRect textViewFrame = NSMakeRect(0.0, 0.0, 260, h);
    
    NSTextView * textView = [[NSTextView alloc] initWithFrame:textViewFrame textContainer:textContainer];
    NSData * pdf = [textView dataWithPDFInsideRect:textView.frame];
    [self setPdf:pdf];
    
}

# pragma mark - Problem Options

# pragma mark - Image

- (BOOL)hasImage
{
    return [self getOption:TKOProblemOptionHasImage];
}

- (void)setHasImage:(BOOL)hasImage
{
    [self setOption:TKOProblemOptionHasImage flag:hasImage];
}

# pragma mark - Prelude

- (BOOL)hasPrelude
{
    return [self getOption:TKOProblemOptionHasPrelude];
}

- (void)setHasPrelude:(BOOL)hasPrelude
{
    [self setOption:TKOProblemOptionHasPrelude
               flag:hasPrelude];
}

# pragma mark - Question

- (BOOL)hasQuestion
{
    return [self getOption:TKOProblemOptionHasQuestion];
}

- (void)setHasQuestion:(BOOL)hasQuestion
{
    [self setOption:TKOProblemOptionHasQuestion flag:hasQuestion];
}

# pragma mark - Roman

- (BOOL)hasRoman
{
    return [self getOption:TKOProblemOptionHasRoman];
}

- (void)setHasRoman:(BOOL)hasRoman {
    [self setOption:TKOProblemOptionHasRoman flag:hasRoman];
}

# pragma mark - Answer

- (BOOL)hasAnswer
{
    return [self getOption:TKOProblemOptionHasAnswer];
}

- (void)setHasAnswer:(BOOL)hasAnswer
{
    [self setOption:TKOProblemOptionHasAnswer flag:hasAnswer];
}

# pragma mark - Difficulty

- (BOOL)hasDifficulty
{
    return [self getOption:TKOProblemOptionHasDifficulty];
}

- (void)setHasDifficulty:(BOOL)hasDifficulty
{
    [self setOption:TKOProblemOptionHasDifficulty flag:hasDifficulty];
}

# pragma mark - Flaw

- (BOOL)hasFlaw
{
    return [self getOption:TKOProblemOptionHasFlaw];
}

- (void)setHasFlaw:(BOOL)hasFlaw
{
    [self setOption:TKOProblemOptionHasFlaw flag:hasFlaw];
}

@end

NSString * const TKOProblemParagraphStylesArrayKey = @"TKOProblemParagraphStylesArrayKey";
