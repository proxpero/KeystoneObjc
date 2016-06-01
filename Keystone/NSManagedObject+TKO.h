//
//  NSManagedObject+TKO.h
//  Prototype
//
//  Created by Todd Olsen on 5/7/12.
//  Copyright (c) 2012 Phosphorescent LLC. All rights reserved.
//

@interface NSManagedObject (TKO) <NSPasteboardWriting>

+ (id)create;
+ (NSManagedObjectContext *)managedObjectContext;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSEntityDescription *)entity;
+ (NSFetchRequest *)allFetchRequest;
+ (NSArray *)allObjects;
+ (NSUInteger)allObjectsCount;
+ (id)fetchObjectWithName:(NSString *)name;
- (BOOL)save;
- (void)deleteObject;

- (NSDateFormatter *)dateFormatter;

@end
