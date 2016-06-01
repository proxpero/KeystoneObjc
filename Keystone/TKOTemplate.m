//
//  TKOTemplate.m
//  Keystone
//
//  Created by Todd Olsen on 6/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSManagedObject+Keystone.h"
#import "TKOSidebarController.h"

static NSMutableDictionary * _templates = nil;

@implementation TKOTemplate

@dynamic name;
@dynamic options;
@dynamic milliseconds;
@dynamic index;
@dynamic problems;
@dynamic tags;
@dynamic lists;
@dynamic children;
@dynamic parent;

@synthesize menu = _menu;

# pragma mark - Set Up

+ (void)initialize
{
    if (!_templates)
        _templates = [[NSMutableDictionary alloc] init];
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setName:@"New Template"];
    [self updateMenu];
}

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    [self updateMenu];
}

+ (id)createWithName:(NSString *)name
{
    TKOTemplate * template = [self createWithUniqueName:name];
    [_templates setObject:template
                   forKey:template.name];
    return template;
}

+ (id)createWithName:(NSString *)name
              parent:(id)parent
{
    TKOTemplate * template = [TKOTemplate createWithName:name];
    [template setParent:parent];
    return template;
}

+ (id)createWithName:(NSString *)name
          parentName:(NSString *)parentName
{
    TKOTemplate * template = [TKOTemplate createWithName:name];
    TKOTemplate * parent = [TKOTemplate templateWithName:parentName];
    [template setParent:parent];
    return template;
}

+ (TKOTemplate *)templateWithName:(NSString *)name
{
    TKOTemplate * template = [_templates objectForKey:name];
    
    if (template)
        return template;
    
    template = [self fetchObjectWithName:name];
    if (template)
    {
        [_templates setObject:template
                       forKey:name];
        return template;
    }
    return nil;
}

+ (TKOTemplate *)templateWithName:(NSString *)name
                       parentName:(NSString *)parentName
{
    TKOTemplate * parent = [TKOTemplate templateWithName:parentName];
    if (!parent)
        parent = [TKOTemplate root];
    return [TKOTemplate templateWithName:name parent:parent];
}

+ (TKOTemplate *)templateWithName:(NSString *)name parent:(TKOTemplate *)parent
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSSet * filter = [parent.children filteredSetUsingPredicate:predicate];
    TKOTemplate * child = [filter anyObject];
    return child;
    return [[parent.children filteredSetUsingPredicate:predicate] anyObject];
}

+ (NSSet *)childTemplatesWithArray:(NSArray *)array
                        withParent:(TKOTemplate *)parent
{
    if (!array || array.count < 1)
        return nil;
    
    NSMutableSet * children = [NSMutableSet set];
    [array enumerateObjectsUsingBlock:^(id dict, NSUInteger idx, BOOL *stop) {
        NSString * name = dict[@"Template Name"];
        TKOTemplate * child;
        child = [TKOTemplate templateWithName:name
                                       parent:parent];
        if (!child)
            child = [TKOTemplate createWithName:name
                                         parent:parent];
        [child setIndex:@(idx)];
        [child setMilliseconds:dict[@"Milliseconds"]];
        [child setHasPassage:[dict[@"HasPassage"] isEqualToString:@"TRUE"]];
        [child setIsMultipleChoice:[dict[@"IsMultipleChoice"] isEqualToString:@"TRUE"]];
        [child setIsGridIn:[dict[@"IsGridIn"] isEqualToString:@"TRUE"]];
        [child setConsolidatesProblems:[dict[@"ConsolidatesProblems"] isEqualToString:@"TRUE"]];
        [child setHasDifficulty:[dict[@"HasDifficulty"] isEqualToString:@"TRUE"]];
        [child addChildren:[TKOTemplate childTemplatesWithArray:dict[@"Children"] withParent:child]];
        [child addTags:[TKOTag tagsWithNames:dict[@"Tags"]]];
        
        if (child)
            [children addObject:child];
    }];
    return children;
}

# pragma mark - Source List Protocol

+ (TKOTemplate *)root
{
    NSString * name = TKOTemplatesRootName;
    TKOTemplate * _root;

    _root = [self templateWithName:name];
    if (_root) {
//        [_root setMenu:[self rootMenu]];
        return _root;
    }
    
    _root = [TKOTemplate createWithName:name];
    [_root setIndex:@0];
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"TKOTemplateSeedData"
                                          withExtension:@"plist"];
    NSArray * array = [NSArray arrayWithContentsOfURL:url];
    [_root setChildren:[TKOTemplate childTemplatesWithArray:array
                                                 withParent:_root]];
    [_root updateMenu];
    
    return _root;
}

- (void)updateMenu;
{
    _menu = [[NSMenu alloc] init];
    NSMenuItem * mi;
    
    mi = [[NSMenuItem alloc] init];
    [mi setTitle:@"New Template"];
    [mi setTarget:self];
    [mi setAction:@selector(makeNewTemplateFromMenuItem:)];
    [_menu addItem:mi];
    
    mi = [[NSMenuItem alloc] init];
    [mi setTitle:[NSString stringWithFormat:@"Remove %@", self.name]];
    [mi setTarget:self];
    [mi setAction:@selector(deleteObject)];
    [_menu addItem:mi];
    
    mi = [[NSMenuItem alloc] init];
    [mi setTitle:@"New Problem"];
    [mi setTarget:self];
    [mi setAction:@selector(makeNewProblemFromMenuItem:)];
    [_menu addItem:mi];
}

- (void)makeNewTemplateFromMenuItem:(NSMenuItem *)mi
{
    TKOTemplate * parent = self.parent;
    if (!parent)
        parent = [TKOTemplate root];
    
    [TKOTemplate createWithName:@"New Template"
                         parent:parent];
    [[mi representedObject] updateOutlineView:self];
}

- (void)makeNewProblemFromMenuItem:(NSMenuItem *)mi
{
    TKOProblem * problem = [TKOProblem create];
    [problem setProblemTemplate:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOProblemAddedNotification
                                                        object:self];
}

- (NSArray *)items
{
    return [self.children sortedByIndex];
}

# pragma mark - Accessors

- (BOOL)hasPassage {
    return [self getOption:TKOTemplateHasPassage];
}
- (void)setHasPassage:(BOOL)hasPassage {
    [self setOption:TKOTemplateHasPassage flag:hasPassage];
}
- (BOOL)isMultipleChoice {
    return [self getOption:TKOTemplateIsMultipleChoice];
}
- (void)setIsMultipleChoice:(BOOL)isMultipleChoice {
    [self setOption:TKOTemplateIsMultipleChoice flag:isMultipleChoice];
}
- (BOOL)isGridIn {
    return [self getOption:TKOTemplateIsGridIn];
}
- (void)setIsGridIn:(BOOL)isGridIn {
    [self setOption:TKOTemplateIsGridIn flag:isGridIn];
}
- (BOOL)consolidatesProblems {
    return [self getOption:TKOTemplateConsolidatesProblems];
}
- (void)setConsolidatesProblems:(BOOL)consolidatesProblems {
    [self setOption:TKOTemplateConsolidatesProblems flag:consolidatesProblems];
}
- (BOOL)hasDifficulty {
    return [self getOption:TKOTemplateHasDifficulty];
}
- (void)setHasDifficulty:(BOOL)hasDifficulty
{
    [self setOption:TKOTemplateHasDifficulty flag:hasDifficulty];
}

@end
