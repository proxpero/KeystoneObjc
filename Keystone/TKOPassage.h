//
//  TKOPassage.h
//  Keystone
//
//  Created by Todd Olsen on 6/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TKOList;

@interface TKOPassage : NSManagedObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSData * text;
@property (nonatomic, strong) TKOList *list;


@end
