//
//  TKOList.m
//  Keystone
//
//  Created by Todd Olsen on 6/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOSidebarController.h"

static NSMutableDictionary * _lists = nil;

@implementation TKOList

@dynamic name;
@dynamic options;
@dynamic timestamp;
@dynamic milliseconds;
@dynamic index;
@dynamic problems;
@dynamic tags;
@dynamic passage;
@dynamic listTemplate;
@dynamic parent;
@dynamic children;

@synthesize attributedString;
@synthesize menu = _menu;

# pragma mark - 

+ (void)initialize
{
    if (_lists)
        _lists = [[NSMutableDictionary alloc] init];
}

+ (TKOList *)listWithName:(NSString *)name
{
    TKOList * list = [_lists objectForKey:name];
    
    if (list)
        return list;
    
    list = [self fetchObjectWithName:name];
    if (list)
    {
        [_lists setObject:list
                   forKey:name];
        return list;
    }
    return nil;
}

+ (TKOList *)sublistWithName:(NSString *)name
                      parent:(TKOList *)parent
{
    if (!parent)
        return [TKOList listWithName:name];
    
    for (TKOList * list in [parent children]) {
        if ([list.name isEqualToString:name]) {
            return list;
        }
    }
    
    return nil;
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setName:@"New List"];
    [self setTimestamp:[NSDate date]];
    [self registerKVO];
    [self updateMenu];
}

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    [self registerKVO];
    [self updateAttributedString];
    [self updateMenu];
    
}

- (void)registerKVO
{
    [self addObserver:self
           forKeyPath:@"children.@count"
              options:0
              context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self updateAttributedString];
    
}

- (void)updateAttributedString
{
    NSArray * problems = [self.problems sortedByDifficulty];
    if (problems.count < 1)
        return;
    
    NSMutableAttributedString * _listString = [[NSMutableAttributedString alloc] init];
    NSInteger milliseconds = 0;

    [_listString beginEditing];
    for (TKOProblem * problem in problems) {
        [_listString appendAttributedString:problem.attributedString];
        [_listString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        NSRange range = [_listString.string paragraphRangeForRange:NSMakeRange(_listString.length - 1, 1)];
        NSMutableParagraphStyle * ps = [[_listString attribute:NSParagraphStyleAttributeName
                                                       atIndex:_listString.length - 2 effectiveRange:NULL] mutableCopy];
        [ps setParagraphSpacing:24.0];
        [_listString addAttribute:NSParagraphStyleAttributeName
                            value:ps
                            range:range];
        milliseconds += problem.milliseconds.integerValue;
        
    }
    [_listString endEditing];
    
    [self setAttributedString:_listString];
    [self setMilliseconds:@(milliseconds)];
}

+ (NSMenu *)contextMenuWithController:(id)controller
{
    NSMenu * menu = [[NSMenu alloc] init];
    [menu setAutoenablesItems:YES];
    NSMenuItem * mi;
    
    mi = [[NSMenuItem alloc] init];
    [mi setTitle:@"Add to List"];
    [menu addItem:mi];
    [menu addItem:[NSMenuItem separatorItem]];
    
    TKOList * root = [TKOList root];
    TKOList * list;
    for (list in root.items) {
        mi = [[NSMenuItem alloc] init];
        [mi setTitle:list.name];
        [mi setTarget:controller];
        [mi setAction:@selector(addToListAction:)];
        [mi setRepresentedObject:list];
        [menu addItem:mi];
    }
    return menu;
}

# pragma mark - Source List Protocol

+ (id)root
{
    NSString * rootName = @"Lists";
    TKOList * _root = [self listWithName:rootName];
    if (_root)
        return _root;
    
    _root = [TKOList create];
    [_root setName:rootName];
    [_lists setObject:_root
               forKey:rootName];
    [_root setListTemplate:[TKOTemplate root]];
    [_root setIndex:@0];
    [_root updateMenu];
    
    return _root;
}

- (void)updateMenu;
{
    _menu = [[NSMenu alloc] init];
    NSMenuItem * mi;
    
    mi = [[NSMenuItem alloc] init];
    [mi setTitle:@"New List"];
    [mi setTarget:self];
    [mi setAction:@selector(makeNewListFromMenuItem:)];
    [_menu addItem:mi];
    
    mi = [[NSMenuItem alloc] init];
    [mi setTitle:@"Export List"];
    [mi setTarget:self];
    [mi setAction:@selector(exportListFromMenuItem:)];
    [_menu addItem:mi];
    
    mi = [[NSMenuItem alloc] init];
    [mi setTitle:[NSString stringWithFormat:@"Remove %@", self.name]];
    [mi setTarget:self];
    [mi setAction:@selector(deleteObject)];
    [_menu addItem:mi];
    
    [_menu addItem:[NSMenuItem separatorItem]];
    
    mi = [[NSMenuItem alloc] init];
    [mi setTitle:@"Remove Selected Problem"];
    [mi setTarget:self];
    [mi setAction:@selector(removeSelectedProblem:)];
    [_menu addItem:mi];
    
}

- (void)makeNewListFromMenuItem:(NSMenuItem *)mi
{
    TKOList * parent = self.parent;
    if (!parent)
        parent = [TKOList root];
    
    [TKOList createItemWithName:@"New List"
                         parent:parent];
    [[mi representedObject] updateOutlineView:self];
}

- (void)exportListFromMenuItem:(NSMenuItem *)mi
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] init];
    NSArray * array = [self.problems sortedByDifficulty];
    for (TKOProblem * problem in array) {
        [string appendAttributedString:problem.attributedString];
    }
    [self setAttributedString:string];
}

- (void)removeSelectedProblem:(NSMenuItem *)mi
{
    NSLog(@"Shit");
}

- (NSArray *)items
{
    return [self.children sortedByIndex];
}

- (BOOL)isExpandable
{
    return !(self.problems.count > 0);
}

- (TKOList *)makeChild
{
    TKOList * list = [TKOList create];
    [list setIndex:@(self.children.count)];
    [list setName:[NSString stringWithFormat:@"List %@", list.index]];
    [self addChildrenObject:list];
    return list;
}

@end
