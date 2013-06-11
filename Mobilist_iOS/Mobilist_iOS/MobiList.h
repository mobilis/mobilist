//
//  MobiList.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 18.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobiListEntry.h"

@interface MobiList : NSObject

@property (nonatomic, strong) NSString* listName;
@property (nonatomic, strong) NSString* listId;
@property (nonatomic, strong) NSMutableArray* listEntries;

- (id)init;

- (void)addListEntry:(MobiListEntry* )aListEntry;
- (void)removeListEntry:(MobiListEntry* )aListEntry;
- (MobiListEntry* )entryAtIndex:(NSInteger)index;
- (MobiListEntry* )entryById:(NSString* )entryId;

@end
