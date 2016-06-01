//
//  TKOProblem.h
//  Keystone
//
//  Created by Todd Olsen on 6/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

typedef enum {
    TKOProblemComponentImage,
    TKOProblemComponentCaption,
    TKOProblemComponentPrelude,
    TKOProblemComponentQuestion,
    TKOProblemComponentRoman,
    TKOProblemComponentChoices
} TKOProblemComponentType;

enum {
    TKOProblemOptionHasQuestion     = 1 << 0,
    TKOProblemOptionHasAnswer       = 1 << 1,
    TKOProblemOptionHasImage        = 1 << 2,
    TKOProblemOptionHasPrelude      = 1 << 3,
    TKOProblemOptionHasRoman        = 1 << 4,
    TKOProblemOptionHasDifficulty   = 1 << 5,
    TKOProblemOptionHasFlaw         = 1 << 6
};

@class TKOList, TKOTag, TKOTemplate;

@interface TKOProblem : NSManagedObject <TKOSourceListItem>

@property (nonatomic, strong) NSString * uuid;
@property (nonatomic, strong) id attributedString;
@property (nonatomic, strong) NSNumber * difficulty;
@property (nonatomic, strong) NSDate * timestamp;
@property (nonatomic, strong) NSString * string;
@property (nonatomic, strong) NSData * pdf;
@property (nonatomic, strong) NSString * answerDesc;
@property (nonatomic, strong) NSNumber * milliseconds;
@property (nonatomic, strong) NSData * possibleAnswers;
@property (nonatomic, strong) NSNumber * multipleChoiceAnswer;
@property (nonatomic, strong) NSNumber * options;
@property (nonatomic, strong) NSSet *lists;
@property (nonatomic, strong) TKOTemplate *problemTemplate;
@property (nonatomic, strong) NSSet *tags;

@property (assign) BOOL hasQuestion;
@property (assign) BOOL hasAnswer;
//@property (assign) BOOL hasImage;
//@property (assign) BOOL hasPrelude;
//@property (assign) BOOL hasRoman;
//@property (assign) BOOL hasTaxonomy;
@property (assign) BOOL hasDifficulty;
@property (assign) BOOL hasFlaw;

+ (TKOProblem *)problemWithDictionary:(NSDictionary *)dict;

+ (NSArray *)paragraphStyles;
+ (NSArray *)characterStyles;
+ (NSArray *)listStyles;

- (NSString *)tagList;

@end

@interface TKOProblem (CoreDataGeneratedAccessors)

- (void)addListsObject:(TKOList *)value;
- (void)removeListsObject:(TKOList *)value;
- (void)addLists:(NSSet *)values;
- (void)removeLists:(NSSet *)values;

- (void)addTagsObject:(TKOTag *)value;
- (void)removeTagsObject:(TKOTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end

extern NSString * const TKOProblemParagraphStylesArrayKey;
