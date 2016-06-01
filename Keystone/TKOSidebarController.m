//
//  TKOSidebarController.m
//  Keystone
//
//  Created by Todd Olsen on 6/12/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#define SEED_DATA

#import "TKOSidebarController.h"
#import "TKOHeaderCellView.h"

@interface TKOSidebarController ()
//@property (strong) NSArray * problems;

- (IBAction)newListAction:(id)sender;
- (IBAction)headerButtonAction:(id)sender;

@end

@implementation TKOSidebarController {
    NSArray * _topLevelItems;
}

# pragma mark - Set Up

- (void)awakeFromNib
{
    [super awakeFromNib];
    static BOOL loaded = NO;
    if (!loaded) {
        loaded = YES;
        _topLevelItems = @[[TKOList root], [TKOTag root], [TKOTemplate root]];

#ifdef SEED_DATA
        [self seedData];
#endif
        
        NSOutlineView * _outlineView = self.outlineView;
        [_outlineView reloadData];
        [_outlineView expandItem:[TKOList root]];
        [_outlineView expandItem:[TKOTag root]];
        [_outlineView expandItem:[TKOTemplate root]];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(refreshOutlineView)
//                                                     name:TKOItemChangedNotification
//                                                   object:nil];
    }
}

- (void)seedData
{
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSURL * url;
    NSArray * array;
    
    url = [mainBundle URLForResource:@"TKOProblemSeedData"
                       withExtension:@"plist"];
    array = [NSArray arrayWithContentsOfURL:url];
    [array enumerateObjectsUsingBlock:^(id dict, NSUInteger idx, BOOL *stop) {
        [TKOProblem problemWithDictionary:dict];
    }];
}

# pragma mark - Outline View Delegate

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item
{
    if ([_topLevelItems containsObject:item]) {
        TKOHeaderCellView * result = [outlineView makeViewWithIdentifier:@"HeaderCell"
                                                                   owner:self];
        NSString * value = [[item name] uppercaseString];
        [result.textField setStringValue:value];
        NSMenu * menu = [item menu];
        if (menu) {
            NSArray * menuItems = [menu itemArray];
            [menuItems makeObjectsPerformSelector:@selector(setRepresentedObject:)
                                       withObject:self];
        }

        [result.badge setUsesMenu:YES];
        [result.badge setMenu:[item menu]];
        
        return result;
    }
    
    TKOHeaderCellView * result = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    NSMenu * menu = [item menu];
    if (menu) {
        [result.badge setUsesMenu:YES];
        [result.badge setMenu:[item menu]];
    }
    [result.textField setStringValue:[item name]];
    
    return result;
}

- (void)updateOutlineView:(id)sender
{
    [self.outlineView reloadItem:sender reloadChildren:YES];
    [self.outlineView expandItem:sender expandChildren:NO];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger row = [[notification object] selectedRow];
    if (row == -1)
        return;
    
    id <TKOSourceListItem> item = [self.outlineView itemAtRow:row];
//    [self setProblems:[[item problems] sortedByTimestamp]];
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOOutliveViewSelectionChangedNotification
                                                        object:item];

    if ([item isKindOfClass:[TKOList class]]) {
        TKOList * list = (TKOList *)item;
        [list updateAttributedString];
        [self setSelectedList:list];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   shouldSelectItem:(id)item
{
    return ![_topLevelItems containsObject:item];
}

- (void)   outlineView:(NSOutlineView *)outlineView
willDisplayOutlineCell:(id)cell
        forTableColumn:(NSTableColumn *)tableColumn
                  item:(id)item
{
    if ([_topLevelItems containsObject:item] || ([[item problems] count] > 0))
        cell = nil;
}

- (BOOL)            outlineView:(NSOutlineView *)outlineView
   shouldShowOutlineCellForItem:(id)item
{
    if ([_topLevelItems containsObject:item])
        return NO;
    
    if ([[item problems] count] > 0)
        return NO;
    
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
        isGroupItem:(id)item
{
    return [_topLevelItems containsObject:item];
}

# pragma mark - Outline View Data Source

- (NSInteger)outlineView:(NSOutlineView *)outlineView
  numberOfChildrenOfItem:(id <TKOSourceListItem>)item
{
    if (!item)
        return _topLevelItems.count;
    else
        return [[item items] count];
}

- (id)outlineView:(NSOutlineView *)outlineView
            child:(NSInteger)index
           ofItem:(id <TKOSourceListItem>)item
{
    if (!item)
        return _topLevelItems[index];
    else
        return item.items[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(id <TKOSourceListItem>)item
{
    return !([[item problems] count] > 0);
}

- (id)          outlineView:(NSOutlineView *)outlineView
  objectValueForTableColumn:(NSTableColumn *)tableColumn
                     byItem:(id)item
{
    return item;
}

- (IBAction)newListAction:(id)sender
{
    NSString * name = @"New List";
    TKOList * newList = [TKOList listWithName:name];
    while (newList) {
        static NSInteger index = 0;
        index++;
        name = [NSString stringWithFormat:@"%@ %lu", name, index];
        newList = [TKOList listWithName:name];
    }
    
    [newList setName:@"My New List Name"];
    
    [[TKOList root] addChildrenObject:newList];
    [self.outlineView reloadItem:[TKOList root]
                  reloadChildren:YES];
    [self.outlineView expandItem:[TKOList root]
                  expandChildren:YES];
}

# pragma mark - Text Field Delegate Methods

- (void)controlTextDidEndEditing:(NSNotification *)notification
{
    NSTextField * label = [notification object];
    NSInteger row = [self.outlineView rowForView:label];
    id <TKOSourceListItem> item = [self.outlineView itemAtRow:row];
    [item setName:label.stringValue];
}

@end
