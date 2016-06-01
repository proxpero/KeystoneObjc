//
//  TKOTag.h
//  Keystone
//
//  Created by Todd Olsen on 6/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

@class TKOList, TKOProblem, TKOTag, TKOTemplate;

@interface TKOTag : NSManagedObject <TKOSourceListItem>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSNumber * index;
@property (nonatomic, strong) TKOTag *parent;
@property (nonatomic, strong) NSSet *children;
@property (nonatomic, strong) NSSet *problems;
@property (nonatomic, strong) NSSet *lists;
@property (nonatomic, strong) NSSet *templates;

@property (nonatomic, strong) NSMenu * menu;

+ (TKOTag *)tagWithName:(NSString *)name;
+ (id)createWithName:(NSString *)name
               index:(NSInteger)index
              parent:(TKOTag *)parent;
+ (NSSet *)tagsWithNames:(NSArray *)names;

@end

@interface TKOTag (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(TKOTag *)value;
- (void)removeChildrenObject:(TKOTag *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

- (void)addProblemsObject:(TKOProblem *)value;
- (void)removeProblemsObject:(TKOProblem *)value;
- (void)addProblems:(NSSet *)values;
- (void)removeProblems:(NSSet *)values;

- (void)addListsObject:(TKOList *)value;
- (void)removeListsObject:(TKOList *)value;
- (void)addLists:(NSSet *)values;
- (void)removeLists:(NSSet *)values;

- (void)addTemplatesObject:(TKOTemplate *)value;
- (void)removeTemplatesObject:(TKOTemplate *)value;
- (void)addTemplates:(NSSet *)values;
- (void)removeTemplates:(NSSet *)values;

@end
