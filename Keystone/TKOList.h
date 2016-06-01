//
//  TKOList.h
//  Keystone
//
//  Created by Todd Olsen on 6/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOSourceListItem.h" // I shouldn't need this import :/

@class TKOList, TKOPassage, TKOProblem, TKOTag, TKOTemplate;

@interface TKOList : NSManagedObject <TKOSourceListItem>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * options;
@property (nonatomic, strong) NSDate * timestamp;
@property (nonatomic, strong) NSNumber * milliseconds;
@property (nonatomic, strong) NSNumber * index;
@property (nonatomic, strong) NSSet *problems;
@property (nonatomic, strong) NSSet *tags;
@property (nonatomic, strong) TKOPassage *passage;
@property (nonatomic, strong) TKOTemplate *listTemplate;
@property (nonatomic, strong) TKOList *parent;
@property (nonatomic, strong) NSSet *children;

@property (strong) NSAttributedString * attributedString;
@property (nonatomic, strong) NSMenu * menu;

+ (TKOList *)listWithName:(NSString *)name;
+ (TKOList *)sublistWithName:(NSString *)name
                      parent:(TKOList *)parent;
- (void)updateAttributedString;
+ (NSMenu *)contextMenuWithController:(id)controller;


@end

@interface TKOList (CoreDataGeneratedAccessors)

- (void)addProblemsObject:(TKOProblem *)value;
- (void)removeProblemsObject:(TKOProblem *)value;
- (void)addProblems:(NSSet *)values;
- (void)removeProblems:(NSSet *)values;

- (void)addTagsObject:(TKOTag *)value;
- (void)removeTagsObject:(TKOTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addChildrenObject:(TKOList *)value;
- (void)removeChildrenObject:(TKOList *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
