//
//  NSManagedObject+TKO.m
//  Prototype
//
//  Created by Todd Olsen on 5/7/12.
//  Copyright (c) 2012 Phosphorescent LLC. All rights reserved.
//

#import "NSManagedObject+TKO.h"

static NSDateFormatter * _dateFormatter;

@implementation NSManagedObject (TKO)

+ (id)create {
	NSEntityDescription *entityDecription = [self entity];
	NSString *name = [entityDecription name];
	return [NSEntityDescription insertNewObjectForEntityForName:name
                                         inManagedObjectContext:[self managedObjectContext]] ;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [(id)[NSApp delegate] managedObjectContext];
}

+ (NSManagedObjectModel *)managedObjectModel {
    return [(id)[NSApp delegate] managedObjectModel];
}

+ (NSEntityDescription *)entity {
    NSManagedObjectModel * model = [self managedObjectModel];
    NSDictionary * entities = [model entitiesByName];
    NSString * class = NSStringFromClass([self class]);
    NSEntityDescription * entity = [entities objectForKey:class];
	return entity;
}

+ (NSFetchRequest *)allFetchRequest {
	NSFetchRequest * request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	return request;
}

+ (NSArray *)allObjects {
	return [[self managedObjectContext] executeFetchRequest:[self allFetchRequest] error:nil];
}

+ (NSUInteger)allObjectsCount {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	return [[self managedObjectContext] countForFetchRequest:request
                                                       error:nil];
}

+ (id)fetchObjectWithName:(NSString *)name
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[self entity]];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [request setPredicate:predicate];
    NSManagedObjectContext * moc = [self managedObjectContext];
    NSArray * results = [moc executeFetchRequest:request
                                           error:nil];
    id object = [results lastObject];
    return object;
}

- (BOOL)save {
	return [[self managedObjectContext] save:nil];	
}

- (void)deleteObject {
	[[self managedObjectContext] deleteObject:self];
}

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter) return (_dateFormatter);
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [_dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    return _dateFormatter;
}

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    return nil;
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type
                                         pasteboard:(NSPasteboard *)pasteboard
{
    return 0;
}

@end
