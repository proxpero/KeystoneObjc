//
//  TKOTableViewController.m
//  Keystone
//
//  Created by Todd Olsen on 6/16/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#define STANDARD_WIDTH 320.0

#import "TKOTableViewController.h"
#import "TKOProblemWindowController.h"

BOOL showPanel = NO;

@interface TKOTableViewController ()
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSArrayController *arrayController;

@property (weak) IBOutlet NSPanel *panel;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (strong) NSMenu * contextMenu;
@property (unsafe_unretained) IBOutlet NSTextView *listTextView;

- (IBAction)addToListAction:(id)sender;
- (IBAction)removeProblemFromList:(id)sender;

- (IBAction)savePdf:(id)sender;



@end

@implementation TKOTableViewController {
    CGFloat width;
}

# pragma mark - Set Up

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:TKOOutliveViewSelectionChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:TKOProblemAddedNotification
                                               object:nil];
    return self;
}

- (void)awakeFromNib
{
    static BOOL loaded = NO;
    if (!loaded) {
        loaded = YES;
        [_tableView setDoubleAction:@selector(showEditProblemPanel:)];
        [_tableView setTarget:self];
        
        TKOList * _root = [TKOList root];
        [_root addObserver:self
                forKeyPath:@"children.@count"
                   options:0
                   context:NULL];
    }
}

# pragma mark - Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"children.@count"]) {
        [self updateContextMenu];
    }
}

//- (NSUInteger)countOfProblems
//{
//    return self.problems.count;
//}
//
//- (id)objectInProblemsAtIndex:(NSUInteger)index
//{
//    return self.problems[index];
//}
//
//- (void)insertObject:(TKOProblem *)problem
//   inProblemsAtIndex:(NSUInteger)index
//{
//    [self.problems insertObject:problem
//                        atIndex:index];
//}
//
//- (void)removeObjectFromProblemsAtIndex:(NSUInteger)index
//{
//    [self.problems removeObjectAtIndex:index];
//}
//
//- (void)replaceObjectInProblemsAtIndex:(NSUInteger)index
//                            withObject:(id)object
//{
//    [self.problems replaceObjectAtIndex:index
//                             withObject:object];
//}

- (void)refreshTable:(id)sender
{
    [self setItem:[sender object]];
    NSLog(@"problems %@", self.item.problems);
//    [self setProblems:[NSMutableArray arrayWithArray:[[self.item problems] sortedByTimestamp]]];
}

- (void)showEditProblemPanel:(id)sender
{
    TKOProblem * problem = [[_arrayController selectedObjects] lastObject];
    [TKOProblemWindowController presentWindowForProblem:problem];
}

# pragma mark - Tear Down

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    TKOList * root = [TKOList root];
    [root removeObserver:self
              forKeyPath:@"children.@count"];
}

# pragma mark - Context Menu

- (void)updateContextMenu
{
    [_tableView setMenu:[TKOList contextMenuWithController:self]];
}

- (IBAction)addToListAction:(id)sender
{
//    NSIndexSet * selectedIndices = [_tableView selectedRowIndexes];
    NSArray * selectedProblems = [_arrayController selectedObjects];
//    NSArray * selectedProblems = [_problems objectsAtIndexes:selectedIndices];
    TKOList * list = (TKOList *)[sender representedObject];
    [list addProblems:[NSSet setWithArray:selectedProblems]];
}

- (IBAction)removeProblemFromList:(id)sender
{
    if ([self.item isKindOfClass:[TKOList class]]) {
        TKOList * list = (TKOList *)self.item;

        NSIndexSet * indexSet = _tableView.selectedRowIndexes;
        NSArray * array = [_arrayController selectedObjects];
//        NSArray * array = [_problems objectsAtIndexes:indexSet];
        NSSet * problems = [NSSet setWithArray:array];

        [list removeProblems:problems];
//        [self setProblems:[NSMutableArray arrayWithArray:list.problems.sortedByDifficulty]];
        [list updateAttributedString];
    }
}

- (IBAction)savePdf:(id)sender
{
    NSURL * url;
    url = [[[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory
                                                  inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"prbPDF.pdf"];
    NSData * prbPDF = [_listTextView dataWithPDFInsideRect:_listTextView.bounds];
    [prbPDF writeToURL:url atomically:YES];
}


@end
