//
//  TKOTemplate.h
//  Keystone
//
//  Created by Todd Olsen on 6/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

enum {
    TKOTemplateHasPassage                  = 1 << 0,
    TKOTemplateIsMultipleChoice            = 1 << 1,
    TKOTemplateIsGridIn                    = 1 << 2,
    TKOTemplateConsolidatesProblems        = 1 << 3,
    TKOTemplateHasDifficulty               = 1 << 4
};
typedef NSUInteger TKOTemplateOption;

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TKOList, TKOProblem, TKOTag, TKOTemplate;

@interface TKOTemplate : NSManagedObject <TKOSourceListItem>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * options;
@property (nonatomic, strong) NSNumber * milliseconds;
@property (nonatomic, strong) NSNumber * index;
@property (nonatomic, strong) NSSet *problems;
@property (nonatomic, strong) NSSet *tags;
@property (nonatomic, strong) NSSet *lists;
@property (nonatomic, strong) NSSet *children;
@property (nonatomic, strong) TKOTemplate *parent;

@property (assign) BOOL hasPassage;
@property (assign) BOOL isMultipleChoice;
@property (assign) BOOL isGridIn;
@property (assign) BOOL consolidatesProblems;
@property (assign) BOOL hasDifficulty;

@property (nonatomic, strong) NSMenu * menu;

+ (TKOTemplate *)templateWithName:(NSString *)name;
+ (TKOTemplate *)templateWithName:(NSString *)name
                           parent:(TKOTemplate *)parent;
+ (TKOTemplate *)templateWithName:(NSString *)name
                       parentName:(NSString *)parentName;

@end

@interface TKOTemplate (CoreDataGeneratedAccessors)

- (void)addProblemsObject:(TKOProblem *)value;
- (void)removeProblemsObject:(TKOProblem *)value;
- (void)addProblems:(NSSet *)values;
- (void)removeProblems:(NSSet *)values;

- (void)addTagsObject:(TKOTag *)value;
- (void)removeTagsObject:(TKOTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addListsObject:(TKOList *)value;
- (void)removeListsObject:(TKOList *)value;
- (void)addLists:(NSSet *)values;
- (void)removeLists:(NSSet *)values;

- (void)addChildrenObject:(TKOTemplate *)value;
- (void)removeChildrenObject:(TKOTemplate *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
